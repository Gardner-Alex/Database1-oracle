@/home/student/Data/cit225/oracle/lab7/lab7.sql

spool lab8.log
-- 1
Insert Into price
(SELECT price_s1.nextval
,      i.item_id
,      cl.common_lookup_id as price_type
,      af.active_flag
,CASE 
WHEN ((TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
OR  active_flag = 'N')
THEN i.release_date
ELSE i.release_date + 31
END as start_date
,Case
WHEN active_flag = 'N'
THEN i.release_date + 30
ELSE
NULL
END as end_date
,(CASE
     WHEN (af.active_flag = 'Y' AND (SYSDATE - i.release_date) < 31) 
     OR   (af.active_flag = 'N' AND (SYSDATE - i.release_date) > 30)
        THEN 
	     (CASE
                WHEN dr.rental_days = '1'
	             THEN 3
		WHEN dr.rental_days = '3'
	             THEN 10
                WHEN dr.rental_days = '5'
	             THEN 15
               END)
      ELSE
          TO_NUMBER(dr.rental_days)
    END) as amount
, 1
, SYSDATE
, 1
, SYSDATE
FROM     item i CROSS JOIN
        (SELECT 'Y' AS active_flag FROM dual
         UNION ALL
         SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
        (SELECT '1' AS rental_days FROM dual
         UNION ALL
         SELECT '3' AS rental_days FROM dual
         UNION ALL
         SELECT '5' AS rental_days FROM dual) dr INNER JOIN
         common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
WHERE    cl.common_lookup_table = 'RENTAL_ITEM'
AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
AND NOT (active_flag = 'N' AND SYSDATE - i.release_date <= 30));


SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND      end_date IS NULL
UNION ALL
SELECT  'OLD N' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND NOT end_date IS NULL
UNION ALL
SELECT  'NEW Y' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      end_date IS NULL
UNION ALL
SELECT  'NEW N' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      NOT (end_date IS NULL);

-- 2

ALTER TABLE price
MODIFY price_type NUMBER NOT NULL; 

COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'PRICE'
AND      column_name = 'PRICE_TYPE';

-- 3

/*
UPDATE   rental_item ri
SET      rental_item_price =
           (SELECT   p.amount
            FROM     price p CROSS JOIN rental r
            WHERE    p.item_id = ri.item_id
            AND      ri.rental_id = r.rental_id
            AND      r.check_out_date
                       BETWEEN p.start_date AND NVL(p.end_date, SYSDATE)
            AND   p.price_type = ri.rental_item_type);

SELECT   ri.rental_item_id, ri.rental_item_price, p.amount
FROM     price p JOIN rental_item ri 
ON       p.item_id = ri.item_id AND p.price_type = ri.rental_item_type
JOIN     rental r ON ri.rental_id = r.rental_id
WHERE    r.check_out_date BETWEEN p.start_date AND NVL(p.end_date, SYSDATE)
ORDER BY 1;
*/

UPDATE   rental_item ri
SET      rental_item_price =
          (SELECT   p.amount
           FROM     price p INNER JOIN common_lookup cl1
           ON       p.price_type = cl1.common_lookup_id CROSS JOIN rental r
                    CROSS JOIN common_lookup cl2 
           WHERE    p.item_id = ri.item_id AND ri.rental_id = r.rental_id
           AND      ri.rental_item_type = cl2.common_lookup_id
           AND      cl1.common_lookup_code = cl2.common_lookup_code
           AND      r.check_out_date
                      BETWEEN p.start_date AND NVL(p.end_date, SYSDATE));

SELECT   ri.rental_item_id
,        ri.rental_item_price
,        p.amount
FROM     price p INNER JOIN common_lookup cl1
ON       p.price_type = cl1.common_lookup_id INNER JOIN rental_item ri 
ON       p.item_id = ri.item_id INNER JOIN common_lookup cl2
ON       ri.rental_item_type = cl2.common_lookup_id INNER JOIN rental r
ON       ri.rental_id = r.rental_id
WHERE    cl1.common_lookup_code = cl2.common_lookup_code
AND      r.check_out_date
BETWEEN  p.start_date AND NVL(p.end_date, SYSDATE)
ORDER BY 1;

-- 4

ALTER TABLE rental_item
MODIFY rental_item_price NUMBER NOT NULL; 

COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_PRICE';


spool off
