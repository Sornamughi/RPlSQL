--function with out
CREATE OR REPLACE FUNCTION total_employees() 
RETURNS integer
LANGUAGE 'plpgsql'
AS $$
DECLARE
total integer;
BEGIN
SELECT COUNT(*) INTO total FROM emp_table;
RETURN total;
END $$

SELECT total_employees(); -- returns total number of records

--function with input
CREATE OR REPLACE FUNCTION get_emp_name(eid integer)
RETURNS VARCHAR(30)
LANGUAGE 'plpgsql'
AS $$
DECLARE ename varchar(30);
BEGIN
 SELECT emp_name INTO ename FROM emp_table WHERE emp_id = eid;
 RETURN ename;
END $$

SELECT get_emp_name(1);

--function with inout
CREATE OR REPLACE FUNCTION swap(num1 INOUT integer, num2 INOUT integer)
LANGUAGE 'plpgsql'
AS $$
BEGIN
SELECT num1, num2 INTO num2,num1;
END $$

SELECT * FROM swap(2,3);


