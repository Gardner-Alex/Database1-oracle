
@/home/student/Data/cit225/oracle/lab5/lab5.sql

spool lab6.log

-- #1

ALTER TABLE rental_item
  ADD (rental_item_price NUMBER)
  ADD (rental_item_type NUMBER);


COLUMN TABLE_NAME   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A10
SELECT   TABLE_NAME
,        column_id
,        column_name
,        data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
ORDER BY 2;

-- #2
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE price CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE price_s1';
  END LOOP;
END;
/
CREATE TABLE price
( price_id          NUMBER
, item_id           NUMBER
, price_type        NUMBER
, active_flag       VARCHAR2(1)    CONSTRAINT FLAG NOT NULL
, start_date        DATE           CONSTRAINT DATE1 NOT NULL
, end_date	    DATE
, amount	    NUMBER
, created_by	    NUMBER
, create_date       DATE	   CONSTRAINT CDATE NOT NULL
, last_updated_by   NUMBER
, last_update_date  DATE           CONSTRAINT LDATE NOT NULL
, CONSTRAINT pk_price_1      PRIMARY KEY(price_id)
, CONSTRAINT fk_price_1      FOREIGN KEY(price_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_2      FOREIGN KEY(created_by) REFERENCES system_user(SYSTEM_USER_ID)
, CONSTRAINT fk_price_3      FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));

CREATE SEQUENCE price_s1 START WITH 1001;

COLUMN TABLE_NAME  FORMAT A10
COLUMN column_id   FORMAT 9999
COLUMN column_name FORMAT A18
COLUMN data_type   FORMAT A10
SELECT   TABLE_NAME
,        column_id
,        column_name
,        data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'PRICE'
ORDER BY 2;

-- #3
-- a
ALTER TABLE item RENAME COLUMN item_release_date TO release_date;

OLUMN TABLE_NAME FORMAT A14
COLUMN column_id  FORMAT 9999
COLUMN column_name FORMAT A22
COLUMN data_type   FORMAT A10
SELECT   TABLE_NAME
,        column_id
,        column_name
,        data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'ITEM'
ORDER BY 2;

--b
INSERT INTO item VALUES
( item_s1.nextval
,'9736-05640-4'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'X Men 9','The search for more money','PG-13'
, sysdate
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'9736-05640-4'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Superman 16','Special Collector''s Edition','PG-13'
, sysdate
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'9736-05640-4'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Hunger Games 3','Killing Children has never been funnier','PG-13'
, sysdate
, 3, SYSDATE, 3, SYSDATE);



SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

--c

INSERT INTO member VALUES
( member_s1.nextval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'GROUP')
,'B293-71449'
,'1111-2222-3333-4444'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Harry','','Potter'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','Utah','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Ginny','','Potter'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','Utah','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Lily','Luna','Potter'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'Provo','Utah','95192'
, 2, SYSDATE, 2, SYSDATE);


INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);


COLUMN full_name FORMAT A20
COLUMN city      FORMAT A10
COLUMN state     FORMAT A10
SELECT   c.last_name || ', ' || c.first_name AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id
WHERE    c.last_name = 'Potter';

--d

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, SYSDATE, SYSDATE + 1
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, SYSDATE, SYSDATE + 3
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Superman 16'
  AND      i.item_subtitle = 'Special Collector''s Edition'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Ginny')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'The Hunger Games 3'
  AND      i.item_subtitle = 'Killing Children has never been funnier'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Lily')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'X Men 9'
  AND      i.item_subtitle = 'The search for more money'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

SELECT   c.last_name
,        COUNT(*)
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name;
-- #4
-- step1

ALTER TABLE common_lookup
  ADD (common_lookup_table VARCHAR2(30))
  ADD (common_lookup_column VARCHAR2(30))
  ADD (common_lookup_code VARCHAR2(30));

-- step2

UPDATE   common_lookup
SET      common_lookup_table = common_lookup_context
WHERE    common_lookup_context!= 'MULTIPLE';

UPDATE   common_lookup
SET      common_lookup_table = 'ADDRESS'
,        common_lookup_column = 'ADDRESS_TYPE'
WHERE    common_lookup_context = 'MULTIPLE';

UPDATE   common_lookup
SET      common_lookup_column = 'CREDIT_CARD_TYPE'
WHERE    common_lookup_type LIKE '%CARD';

UPDATE   common_lookup
SET      common_lookup_column = 'CONTACT_TYPE'
WHERE    common_lookup_table = 'CONTACT';

UPDATE   common_lookup
SET      common_lookup_column = 'ITEM_TYPE'
WHERE    common_lookup_table = 'ITEM';

UPDATE   common_lookup
SET      common_lookup_column = 'SYSTEM_USER_TYPE'
WHERE    common_lookup_table = 'SYSTEM_USER';

UPDATE   common_lookup
SET      common_lookup_column = 'MEMBER_TYPE'
WHERE    common_lookup_table = 'MEMBER'
AND      common_lookup_type IN ('INDIVIDUAL','GROUP');

-- step3

DROP INDEX common_lookup_u2;

-- step4

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, common_lookup_context
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'HOME'
, 'Home'
, 'TELPHONE'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, common_lookup_context
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.NEXTVAL
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'WORK'
, 'Work'
, 'TELEPHONE'
, 1
, SYSDATE
, 1
, SYSDATE);

-- step5

UPDATE   telephone
SET      telephone_type = 
        (SELECT common_lookup_id
         FROM common_lookup
         WHERE common_lookup_table = 'TELEPHONE'
         AND common_lookup_column = 'TELEPHONE_TYPE'
         AND common_lookup_type = 'HOME');

-- step6

ALTER TABLE common_lookup
DROP COLUMN common_lookup_context;

-- step7

ALTER TABLE common_lookup
MODIFY common_lookup_table CHAR(30) NOT NULL
MODIFY common_lookup_column CHAR(30) NOT NULL; 

-- step8
CREATE UNIQUE INDEX common_lookup_u3
 ON common_lookup (common_lookup_table, common_lookup_column, common_lookup_type);

COLUMN TABLE_NAME   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A10
SELECT   TABLE_NAME
,        column_id
,        column_name
,        data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'COMMON_LOOKUP'
ORDER BY 2;

COLUMN common_lookup_table  FORMAT A20
COLUMN common_lookup_column FORMAT A20
COLUMN common_lookup_type   FORMAT A20
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;



spool off
