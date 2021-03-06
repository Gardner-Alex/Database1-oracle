
-- Enable echoing all SQL commands.
SET ECHO ON
 SPOOL ORACLE_GRANDMA.TXT
-- Conditionally drop a table and sequence.
BEGIN
  FOR i IN (SELECT object_name
            ,      object_type
            FROM   user_objects
            WHERE  object_name IN ('GRANDMA','GRANDMA_SEQ')) LOOP
    IF i.object_type = 'TABLE' THEN
      -- Use the cascade constraints to drop the dependent constraint.
      EXECUTE IMMEDIATE 'DROP TABLE '||i.object_name||' CASCADE CONSTRAINTS';
    ELSE
      EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.object_name;
    END IF;
  END LOOP;
END;
/
 
-- Create the table.
CREATE TABLE GRANDMA
( grandma_id     NUMBER       CONSTRAINT grandma_nn1 NOT NULL
, grandma_house  VARCHAR2(30) CONSTRAINT grandma_nn2 NOT NULL
, CONSTRAINT grandma_pk       PRIMARY KEY (grandma_id)
);
 
-- Create the sequence.
CREATE SEQUENCE grandma_seq;
 
-- Create a trigger to mimic automatic numbering.
CREATE OR REPLACE TRIGGER BI_GRANDMA  
  BEFORE INSERT ON GRANDMA              
  FOR EACH ROW
  WHEN (NEW.grandma_id IS NULL) -- Only fire when no ID value exists.
BEGIN  
  SELECT grandma_seq.NEXTVAL INTO :NEW.GRANDMA_ID FROM dual;
END;
/   
 
-- Conditionally drop a table and sequence.
BEGIN
  FOR i IN (SELECT object_name
            ,      object_type
            FROM   user_objects
            WHERE  object_name IN ('TWEETIE_BIRD','TWEETIE_BIRD_SEQ')) LOOP
    IF i.object_type = 'TABLE' THEN
      EXECUTE IMMEDIATE 'DROP TABLE '||i.object_name||' CASCADE CONSTRAINTS';
    ELSE
      EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.object_name;
    END IF;
  END LOOP;
END;
/
 
-- Create the table with primary and foreign key out-of-line constraints.
CREATE TABLE TWEETIE_BIRD
( tweetie_bird_id     NUMBER        CONSTRAINT tweetie_bird_nn1 NOT NULL
, tweetie_bird_house  VARCHAR2(30)  CONSTRAINT tweetie_bird_nn2 NOT NULL
, grandma_id          NUMBER        CONSTRAINT tweetie_bird_nn3 NOT NULL
, CONSTRAINT tweetie_bird_pk        PRIMARY KEY (tweetie_bird_id)
, CONSTRAINT tweetie_bird_fk        FOREIGN KEY (grandma_id)
  REFERENCES GRANDMA (GRANDMA_ID)
);
 
-- Create sequence.
CREATE SEQUENCE tweetie_bird_seq; 
 
-- Create trigger to mimic automatic numbering.
CREATE OR REPLACE TRIGGER BI_TWEETIE_BIRD  
  BEFORE INSERT ON TWEETIE_BIRD              
  FOR EACH ROW
  WHEN (NEW.tweetie_bird_id IS NULL) -- Only fire when no ID value exists.
BEGIN  
  SELECT tweetie_bird_seq.NEXTVAL INTO :NEW.tweetie_bird_id FROM dual;
END;
/
SPOOL OFF
