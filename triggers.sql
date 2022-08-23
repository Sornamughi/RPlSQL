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







----Different types of triggers

CREATE TABLE Employee(
"EmployeeId" INT NOT NULL,
"LastName" VARCHAR(20) NOT NULL,
"FirstName" VARCHAR(20) NOT NULL,
"Title" VARCHAR(30),
"ReportsTo" INT,
"BirthDate" TIMESTAMP,
"HireDate" TIMESTAMP,
"Address" VARCHAR(70),
"City" VARCHAR(40),
"State" VARCHAR(40),
"Country" VARCHAR(40),
"PostalCode" VARCHAR(10),
"Phone" VARCHAR(24),
"Fax" VARCHAR(24),
"Email" VARCHAR(60),
CONSTRAINT "PK_Employee" PRIMARY KEY  ("EmployeeId"));

CREATE TABLE Employee_Audit(
"EmployeeId" INT NOT NULL,
"LastName" VARCHAR(20) NOT NULL,
"FirstName" VARCHAR(20) NOT NULL,
"UserName" VARCHAR(20) NOT NULL,
"EmpAdditionTime" VARCHAR(20) NOT NULL);



-----1. INSERT LEVEL Trigger:

CREATE TRIGGER employee_insert_trigger
  AFTER INSERT
  ON Employee
  FOR EACH ROW
  EXECUTE PROCEDURE employee_insert_trigger_fnc();

CREATE OR REPLACE FUNCTION employee_insert_trigger_fnc()
RETURNS trigger 
LANGUAGE 'plpgsql'
AS $$
BEGIN
    INSERT INTO Employee_Audit ( "EmployeeId", "LastName", "FirstName","UserName" ,"EmpAdditionTime")
         VALUES(NEW."EmployeeId",NEW."LastName",NEW."FirstName",current_user,current_date);
    RETURN NEW;
END;
$$

INSERT INTO Employee VALUES(10,' Adams','Andrew','Manager',1,'1962-02-18 00:00:00','2010-08-14 00:00:00','11120 Jasper Ave NW','Edmonton','AB','Canada','T5K 2N1','+1 780 428-9482','+1 780 428-3457','abc@gmail.com');

--------2. Before Insert

CREATE TRIGGER employee_before_insert_trigger
  BEFORE INSERT
  ON employee
  FOR EACH ROW
  EXECUTE PROCEDURE employee_before_insert_trigger_fn();

CREATE OR REPLACE PROCEDURE employee_before_insert_trigger_fn()
RETURNS trigger
LANGUAGE 'plpgsql'
AS $$
BEGIN
  NEW.FirstName = LTRIM(NEW.FirstName)
  NEW.LastName = LTRIM(NEW.LastName)
  NEW.State = UPPER(NEW.State)
  RETURN NEW
END;
$$ 

INSERT INTO Employee VALUES(10,'      Andy','  James','Manager',1,'1962-02-18 00:00:00','2010-08-14 00:00:00','11120 Jasper Ave NW','Edmonton','ab','Canada','T5K 2N1','+1 780 428-9482','+1 780 428-3457','abc@gmail.com');




----Student_Mast : Contains student details of whole school
-----Student_Class_3 : Contains student details of class 3
------Student_Class_3_Marks : Contains marks of class 3

CREATE TABLE Student_Mast(
	StudentId int primary key,
	StudentName varchar(20),
	StudentClass int);
CREATE TABLE student_class_3(
    StudentId int primary key,
    StudentName varchar(30));
CREATE TABLE student_class_3_marks(
    StudentId int primary key,
    English int,
    Maths int,
    Science int,
    Total int);	



-------3. Before/After Update Trigger
CREATE TRIGGER student_mast_update_trigger
BEFORE UPDATE
ON student_class_3
FOR EACH ROW
EXECUTE PROCEDURE student_mast_update_trigger_fn();

CREATE OR REPLACE FUNCTION student_mast_update_trigger_fn()
RETURNS trigger
LANGUAGE 'plpgsql'
AS $$
BEGIN
  UPDATE student_mast SET FirstName = NEW.FirstName WHERE studentId = NEW.studentId;
  RETURN NEW;
END;
$$

UPDATE student_class_3 SET studentname = 'Shruti. P' WHERE studentid = 1;

-------4. Before/After Delete Trigger

CREATE OR REPLACE TRIGGER student_mast_del_trigger
AFTER DELETE
ON student_mast
FOR EACH ROW
EXECUTE PROCEDURE student_del_trigger_fn();

CREATE OR REPLACE FUNCTION student_del_trigger_fn()
RETURNS TRIGGER
LANGUAGE 'plpgsql'
AS $$
BEGIN
  DELETE FROM student_class_3 WHERE studentid = OLD.studentid;
  RETURN OLD;
END;
$$

INSERT INTO student_mast VALUES(3,'Sorna',3);
INSERT INTO student_class_3 VALUES(3,'Sorna');

DELETE FROM student_mast WHERE studentid = 3;

select * from student_class_3