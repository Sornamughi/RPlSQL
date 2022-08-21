-- create and call procedure

CREATE TABLE proc_demo_table (answer text)

-- procedure without input parameters
CREATE OR REPLACE PROCEDURE sp_demo()
LANGUAGE 'plpgsql'
AS $$
BEGIN
INSERT INTO proc_demo_table VALUES ('procedure without parameter'); 
END
$$

SELECT * FROM proc_demo_table -- no value will be inserted yet

CALL sp_demo()

SELECT * FROM proc_demo_table -- now value will be inserted in table after calling procedure

-- procedure with input parameters

CREATE OR REPLACE PROCEDURE sp_param_demo(num1 integer, num2 integer) 
LANGUAGE 'plpgsql'
AS $$
DECLARE
  v_result int := num1/num2;
BEGIN
  INSERT INTO proc_demo_table VALUES (CONCAT('The division result is ',v_result));
END
$$

CALL sp_param_demo(10,2)

SELECT * FROM proc_demo_table -- inserts the division result in table

-- procedure with exception handling
CREATE OR REPLACE PROCEDURE sp_param_ex_demo(num1 integer, num2 integer)
LANGUAGE 'plpgsql'
AS $$
DECLARE 
v_result text; 
BEGIN
v_result := num1/num2;
EXCEPTION WHEN OTHERS THEN
   v_result := 'undefined';
INSERT INTO proc_demo_table VALUES (CONCAT('The division result is ',v_result));
END
$$

CALL sp_param_ex_demo(10,2)
CALL sp_param_ex_demo(10,0)

SELECT * FROM proc_demo_table; -- execption is handled and result is stored as undefined in table

-- procedure with output value
CREATE OR REPLACE PROCEDURE sp_params_out_demo(num1 numeric, num2 numeric, v_sum OUT numeric)
LANGUAGE 'plpgsql'
AS $$
BEGIN
 v_sum := num1+num2;
END 
$$ 

--output variable has to be declared and passed when calling procedure
DO $$
DECLARE
v_sum numeric;
BEGIN
CALL public.sp_params_out_demo(1,2,v_sum);
RAISE NOTICE 'Sum is %',v_sum;
END $$ 
 



DO $$ 
DECLARE
   counter    INTEGER := 1;
   first_name VARCHAR(50) := 'John';
   last_name  VARCHAR(50) := 'Doe';
   payment    NUMERIC(11,2) := 20.5;
BEGIN 
   RAISE NOTICE '% % % has been paid % USD', counter, first_name, last_name, payment;
END $$;
 
DO $$
DECLARE vsum integer;
BEGIN
CALL sp_params_out_demo(:vsum);
SELECT vsum;
END $$

SELECT * FROM emp_table;
--using tcl
CREATE PROCEDURE sp_tcl_demo() 
LANGUAGE 'plpgsql'
AS $$
BEGIN
  INSERT INTO emp_table VALUES (1, 'Rahul','Male',2,34);
  COMMIT;
  INSERT INTO emp_table VALUES(2, 'Preeti','Female',1,23);
  ROLLBACK;
END $$

CALL sp_tcl_demo() -- only committed value is inserted

--procedure overloading
CREATE OR REPLACE PROCEDURE sp_overloading_demo(name1 text)
LANGUAGE 'plpgsql'
AS $$
BEGIN
RAISE NOTICE '%',name1;
END $$

CREATE OR REPLACE PROCEDURE sp_overloading_demo(name1 text, name2 text)
LANGUAGE 'plpgsql'
AS $$
BEGIN
RAISE NOTICE '% and %',name1,name2;
END $$

CALL sp_overloading_demo('It is demo for overloading with single input');
CALL sp_overloading_demo('name1','name2');






