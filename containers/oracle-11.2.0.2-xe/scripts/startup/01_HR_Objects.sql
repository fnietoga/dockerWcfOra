CREATE OR REPLACE PACKAGE HR.PKG_HR_EMPLOYEES_STATE IS

	-- Public constant declarations	 
	V_FILTERS_ERROR_MESSAGE CONSTANT VARCHAR(80) := 'Se ha producido un error al realizar la consulta, revise los filtros aportados.';


	TYPE EMPLOYEEINFOTYPE IS RECORD (
		EMPLOYEE_ID		NUMBER(6),
		JOB_ID			VARCHAR2(10),
		MANAGER_ID		NUMBER(6),
		DEPARTMENT_ID	NUMBER(4),
		LOCATION_ID		NUMBER(4),
		COUNTRY_ID		CHAR(2),
		FIRST_NAME		VARCHAR2(20),
		LAST_NAME		VARCHAR2(25),
		SALARY			NUMBER(8,2),
		COMMISSION_PCT	NUMBER(2,2),
		DEPARTMENT_NAME	VARCHAR2(30),
		JOB_TITLE		VARCHAR2(35),
		CITY			VARCHAR2(30),
		STATE_PROVINCE	VARCHAR2(25),
		COUNTRY_NAME	VARCHAR2(40),
		REGION_NAME		VARCHAR2(25) 
	);

	TYPE RETURNEMPLOYEEINFO IS REF CURSOR RETURN EMPLOYEEINFOTYPE;	

END PKG_HR_EMPLOYEES_STATE;


CREATE OR REPLACE PACKAGE HR.PKG_HR_EMPLOYEES IS

	PROCEDURE P_LISTEMPLOYEES (
	   i_EMPLOYEE_ID IN NUMBER,
	   i_COUNTRY_NAME IN VARCHAR2,
	   i_DEPARTMENT_NAME IN VARCHAR2,
	   o_EMPLOYEES OUT PKG_HR_EMPLOYEES_STATE.RETURNEMPLOYEEINFO); 

END PKG_HR_EMPLOYEES;


CREATE OR REPLACE PACKAGE BODY HR.PKG_HR_EMPLOYEES IS

	PROCEDURE P_LISTEMPLOYEES (
	   i_EMPLOYEE_ID IN NUMBER,
	   i_COUNTRY_NAME IN VARCHAR2,
	   i_DEPARTMENT_NAME IN VARCHAR2,
	   o_EMPLOYEES OUT PKG_HR_EMPLOYEES_STATE.RETURNEMPLOYEEINFO) 
	IS
  
	BEGIN

		OPEN o_EMPLOYEES FOR
			SELECT EMPLOYEE_ID
				,JOB_ID
				,MANAGER_ID
				,DEPARTMENT_ID
				,LOCATION_ID
				,COUNTRY_ID
				,FIRST_NAME
				,LAST_NAME
				,SALARY
				,COMMISSION_PCT
				,DEPARTMENT_NAME
				,JOB_TITLE
				,CITY
				,STATE_PROVINCE
				,COUNTRY_NAME
				,REGION_NAME 
			FROM HR.EMP_DETAILS_VIEW
			WHERE (i_EMPLOYEE_ID IS NULL OR EMPLOYEE_ID = i_EMPLOYEE_ID)
			AND  (i_COUNTRY_NAME IS NULL OR COUNTRY_NAME = i_COUNTRY_NAME)
			AND (i_DEPARTMENT_NAME IS NULL OR DEPARTMENT_NAME = i_DEPARTMENT_NAME) 
		;

	EXCEPTION
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20001, PKG_HR_EMPLOYEES_STATE.V_FILTERS_ERROR_MESSAGE);

	END P_LISTEMPLOYEES;
	
						   
END PKG_HR_EMPLOYEES;