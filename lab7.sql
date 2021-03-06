
@/home/student/Data/cit225/oracle/lab6/lab6.sql

spool lab7.log

-- #1

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'PRICE'
, 'ACTIVE_FLAG'
, 'Y'
, 'YES'
, 'yes'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'PRICE'
, 'ACTIVE_FLAG'
, 'N'
, 'NO'
, 'no'
, 1
, SYSDATE
, 1
, SYSDATE);

COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'PRICE'
AND      common_lookup_column = 'ACTIVE_FLAG'
ORDER BY 1, 2, 3 DESC;

-- #2

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'PRICE'
, 'PRICE_TYPE'
, '1'
, '1-DAY RENTAL'
, '1-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'PRICE'
, 'PRICE_TYPE'
, '3'
, '3-DAY RENTAL'
, '3-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'PRICE'
, 'PRICE_TYPE'
, '5'
, '5-DAY RENTAL'
, '5-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '1'
, '1-DAY RENTAL'
, '1-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '3'
, '3-DAY RENTAL'
, '3-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_code
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '5'
, '5-DAY RENTAL'
, '5-Day Rental'
, 1
, SYSDATE
, 1
, SYSDATE);

COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN ('PRICE','RENTAL_ITEM')
AND      common_lookup_column IN ('PRICE_TYPE','RENTAL_ITEM_TYPE')
ORDER BY 3;

-- #3

-- a
UPDATE   rental_item ri
SET      rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
              (SELECT   cast(r.return_date - r.check_out_date as VARCHAR2(30))
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id)
	       AND cl.common_lookup_table = 'RENTAL_ITEM'
	       AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE');

COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

SELECT   ROW_COUNT
,        col_count
FROM    (SELECT   COUNT(*) AS ROW_COUNT
         FROM     rental_item) rc CROSS JOIN
        (SELECT   COUNT(rental_item_type) AS col_count
         FROM     rental_item
         WHERE    rental_item_type IS NOT NULL) cc;

-- b

ALTER TABLE rental_item
MODIFY rental_item_type NUMBER NOT NULL;

COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_TYPE';

-- #4
COLUMN item_id  FORMAT 9999 HEADING "ITEM|ID"
COLUMN active_flag FORMAT A6 HEADING "ACTIVE|FLAG"
COLUMN price_type   FORMAT 9999 HEADING "PRICE|TYPE"
COLUMN start_date  FORMAT A20 HEADING "START|DATE"
COLUMN end_date FORMAT A20 HEADING "END|DATE"
COLUMN amount    FORMAT 9999 HEADING "AMOUNT"

SELECT i.item_id
,      af.active_flag
,      cl.common_lookup_id as price_type
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
AND NOT (active_flag = 'N' AND SYSDATE - i.release_date <= 30)
ORDER BY 1, 2, 3;




spool off
