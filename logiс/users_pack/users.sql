--EXCEPTION 0 - 10 USE INCORRECTLY_EMAIL EMAIL_ALREADY_EXISTS

--0 email address entered incorrectly
--1 user with this email address already exists
--2 registration error
--3 failed to change age
--4 failed to change user info
--5 failed to change user avatar
--6 login error 
--7 error when reading users
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM REGISTRATION FOR FISHY_ADMIN.REGISTRATION;
DROP PUBLIC SYNONYM REGISTRATION;

DROP PROCEDURE REGISTRATION;
CREATE OR REPLACE PROCEDURE REGISTRATION(
U_FIRST_NAME IN USERS.FIRST_NAME%TYPE,
U_LAST_NAME IN USERS.LAST_NAME%TYPE,
U_EMAIL IN USERS.EMAIL%TYPE,
U_PASS IN USERS.PASS%TYPE)
IS
  USER_COUNTER NUMBER;
BEGIN
  IF VALIDATION_PACKAGE.CHECK_EMAIL(U_EMAIL) = TRUE THEN
    SELECT COUNT(*) INTO USER_COUNTER FROM USERS_VIEW
      WHERE USERS_VIEW.EMAIL = U_EMAIL;
    IF USER_COUNTER = 0 THEN
      INSERT INTO USERS(FIRST_NAME,LAST_NAME,EMAIL,PASS)
         VALUES(U_FIRST_NAME,U_LAST_NAME,U_EMAIL,U_PASS);
    ELSE
      RAISE EXCEPTION_PACKAGE.EMAIL_ALREADY_EXISTS;
    END IF;
  ELSE
    RAISE EXCEPTION_PACKAGE.INCORRECTLY_EMAIL;
  END IF;
  COMMIT;
EXCEPTION 
  WHEN EXCEPTION_PACKAGE.INCORRECTLY_EMAIL THEN
    RAISE_APPLICATION_ERROR(-20000, 'email address entered incorrectly');
    
  WHEN EXCEPTION_PACKAGE.EMAIL_ALREADY_EXISTS THEN
    RAISE_APPLICATION_ERROR(-20001, 'user with this email address already exists');
      
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20002, 'registration error check the entered data');
END REGISTRATION;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM CHANGE_AGE FOR FISHY_ADMIN.CHANGE_AGE;
DROP PUBLIC SYNONYM CHANGE_AGE;

DROP PROCEDURE CHANGE_AGE;
CREATE OR REPLACE PROCEDURE CHANGE_AGE(
USER_ID IN USERS.ID%TYPE,
USER_AGE IN USERS.AGE%TYPE)
IS
BEGIN
  UPDATE USERS SET AGE = USER_AGE WHERE ID = USER_ID;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'failed to change age');
END CHANGE_AGE;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM CHANGE_INFO FOR FISHY_ADMIN.CHANGE_INFO;
DROP PUBLIC SYNONYM CHANGE_INFO;

DROP PROCEDURE CHANGE_INFO;
CREATE OR REPLACE PROCEDURE CHANGE_INFO(
USER_ID IN USERS.ID%TYPE,
USER_INFO IN USERS.INFO%TYPE)
IS
BEGIN
  UPDATE USERS SET INFO = USER_INFO WHERE ID = USER_ID;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20004, 'failed to change user info');
END CHANGE_INFO;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM CHANGE_AVATAR FOR FISHY_ADMIN.CHANGE_AVATAR;
DROP PUBLIC SYNONYM CHANGE_AVATAR;

DROP PROCEDURE CHANGE_AVATAR;
CREATE OR REPLACE PROCEDURE CHANGE_AVATAR(
USER_ID IN USERS.ID%TYPE,
USER_AVATAR IN USERS.AVATAR%TYPE)
IS
BEGIN
  UPDATE USERS SET AVATAR = USER_AVATAR WHERE ID = USER_ID;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20005, 'failed to change user avatar');
END CHANGE_AVATAR;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM LOGIN FOR FISHY_ADMIN.LOGIN;
DROP PUBLIC SYNONYM LOGIN;

DROP FUNCTION LOGIN;
CREATE OR REPLACE FUNCTION LOGIN(
USER_EMAIL IN USERS.EMAIL%TYPE,
USER_PASS IN USERS.PASS%TYPE) 
RETURN USERS.ID%TYPE
IS
  USER_ID USERS.ID%TYPE;
BEGIN
  IF VALIDATION_PACKAGE.CHECK_EMAIL(USER_EMAIL) = TRUE THEN
    SELECT ID INTO USER_ID FROM USERS
      WHERE EMAIL = USER_EMAIL AND PASS = USER_PASS;
  ELSE
    RAISE EXCEPTION_PACKAGE.INCORRECTLY_EMAIL;
  END IF;
  RETURN USER_ID;
EXCEPTION 
  WHEN EXCEPTION_PACKAGE.INCORRECTLY_EMAIL THEN
    RAISE_APPLICATION_ERROR(-20000, 'Email address entered incorrectly');
    RETURN NULL;
    
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20006, 'login error check the entered data');
    RETURN NULL;
END LOGIN;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM GET_USER_BY_ID FOR FISHY_ADMIN.GET_USER_BY_ID;
DROP PUBLIC SYNONYM GET_USER_BY_ID;

DROP PROCEDURE GET_USER_BY_ID;
CREATE OR REPLACE PROCEDURE GET_USER_BY_ID(
RESULT_CURSOR OUT SYS_REFCURSOR,
U_ID IN USERS_VIEW.USER_ID%TYPE)
IS
BEGIN
  OPEN RESULT_CURSOR FOR 
    SELECT USER_ID,FIRST_NAME,LAST_NAME,AGE,EMAIL,INFO,AVATAR 
      FROM USERS_VIEW WHERE USER_ID = U_ID;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20007, 'error when reading users');
END GET_USER_BY_ID;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM GET_USERS_BY_NAME FOR FISHY_ADMIN.GET_USERS_BY_NAME;
DROP PUBLIC SYNONYM GET_USERS_BY_NAME;

DROP PROCEDURE GET_USERS_BY_NAME;
CREATE OR REPLACE PROCEDURE GET_USERS_BY_NAME(
RESULT_CURSOR OUT SYS_REFCURSOR,
U_FIRST_NAME IN USERS_VIEW.FIRST_NAME%TYPE := NULL,
U_LAST_NAME IN USERS_VIEW.LAST_NAME%TYPE := NULL)
IS
BEGIN
  IF U_FIRST_NAME IS NULL AND U_LAST_NAME IS NULL THEN
    OPEN RESULT_CURSOR FOR
      SELECT USER_ID,FIRST_NAME,LAST_NAME,AGE,EMAIL,INFO,AVATAR 
        FROM USERS_VIEW;
  ELSIF U_FIRST_NAME IS NULL THEN
    OPEN RESULT_CURSOR FOR 
      SELECT USER_ID,FIRST_NAME,LAST_NAME,AGE,EMAIL,INFO,AVATAR 
        FROM USERS_VIEW 
          WHERE UPPER(LAST_NAME) LIKE UPPER('%'||U_LAST_NAME||'%');
  ELSIF U_LAST_NAME IS NULL THEN
    OPEN RESULT_CURSOR FOR
      SELECT USER_ID,FIRST_NAME,LAST_NAME,AGE,EMAIL,INFO,AVATAR 
        FROM USERS_VIEW 
          WHERE UPPER(FIRST_NAME) LIKE UPPER('%'||U_FIRST_NAME||'%');
  ELSE
    OPEN RESULT_CURSOR FOR 
      SELECT USER_ID,FIRST_NAME,LAST_NAME,AGE,EMAIL,INFO,AVATAR 
        FROM USERS_VIEW 
          WHERE UPPER(FIRST_NAME) LIKE UPPER('%'||U_FIRST_NAME||'%')
            AND UPPER(LAST_NAME) LIKE UPPER('%'||U_LAST_NAME||'%');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20007, 'error when reading users');
END GET_USERS_BY_NAME;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM GET_USER_BY_EMAIL FOR FISHY_ADMIN.GET_USER_BY_EMAIL;
DROP PUBLIC SYNONYM GET_USER_BY_EMAIL;

DROP PROCEDURE GET_USER_BY_EMAIL;
CREATE OR REPLACE PROCEDURE GET_USER_BY_EMAIL(
RESULT_CURSOR OUT SYS_REFCURSOR,
U_EMAIL IN USERS_VIEW.EMAIL%TYPE := NULL)
IS
BEGIN
    OPEN RESULT_CURSOR FOR
      SELECT USER_ID,FIRST_NAME,LAST_NAME,AGE,EMAIL,INFO,AVATAR 
        FROM USERS_VIEW 
          WHERE EMAIL = U_EMAIL;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20007, 'error when reading users');
END GET_USER_BY_EMAIL;
--------------------------------------------------------------------------------