CREATE DATABASE employee;
--DROP DATABASE employee;

CREATE TABLE emp_table (emp_id int,
					    emp_name varchar(30),
					    gender varchar(10),
					    department_id int);
ALTER TABLE emp_table 
ADD CONSTRAINT pk_emp_id PRIMARY KEY(emp_id);
ALTER TABLE emp_table
ADD COLUMN age int;
ALTER TABLE emp_table
ADD COLUMN salary int;
ALTER TABLE emp_table
DROP COLUMN salary;
ALTER TABLE emp_table
ALTER COLUMN age SET NOT NULL;
ALTER TABLE emp_table
ALTER COLUMN age TYPE integer;
						
						