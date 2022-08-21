--demo for trigger
--a trigger is called to add entry into audit table whenever a record is added in 
--company table

-- creating company and audit tables
CREATE TABLE COMPANY(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);

CREATE TABLE AUDIT(
   EMP_ID INT NOT NULL,
   ENTRY_DATE TEXT NOT NULL
);

--creating trigger
CREATE TRIGGER example_trigger AFTER INSERT ON COMPANY
FOR EACH ROW EXECUTE PROCEDURE auditlogfunc();

--creating auditlogfunc()
CREATE OR REPLACE FUNCTION auditlogfunc()  
RETURNS TRIGGER
LANGUAGE 'plpgsql'
AS $example_table$
BEGIN
      INSERT INTO AUDIT(EMP_ID, ENTRY_DATE) VALUES (new.ID, current_timestamp);
      RETURN NEW;
   END;
$example_table$;

select * from company;
select * from audit;	

--inserting record in company
--trigger function is called and record added to audit table automatically
INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
VALUES (1, 'Paul', 32, 'California', 20000.00 );