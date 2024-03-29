---EXCEPTION 50 - 60 USE DIALOG_DOESNT_EXISTS NO_PRIVILEGES USER_ALREADY_IN_DIALOG USER_DOESNT_IN_DIALOG

-- 50 create dialog error check the entered data
-- 51 delete dialog error check the entered data
-- 52 dialog with that id does not exist
-- 53 no plivileges
-- 54 user already in dialog
-- 55 invite user to dialog error 
-- 56 user not in dialog
-- 57 delete user of dialog error
-- 58 error when reading dialogs
-- 59 check user in dialog error
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM ADD_DIALOG FOR FISHY_ADMIN.ADD_DIALOG;
--DROP PUBLIC SYNONYM ADD_DIALOG;

--DROP PROCEDURE ADD_DIALOG;
CREATE OR REPLACE PROCEDURE ADD_DIALOG(
DIALOG_CREATOR_ID USERS.ID%TYPE,
DIALOG_TITLE DIALOGS.TITLE%TYPE)
IS
  DIALOG_ID DIALOGS.ID%TYPE;
BEGIN
  INSERT INTO DIALOGS(CREATOR_ID,TITLE,CREATED)
    VALUES(DIALOG_CREATOR_ID,DIALOG_TITLE,CURRENT_TIMESTAMP);
  SELECT MAX(ID) INTO DIALOG_ID FROM DIALOGS;
  INSERT INTO USERS_TO_DIALOGS 
    VALUES(DIALOG_CREATOR_ID,DIALOG_ID);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20050, 'create dialog error check the entered data');
END ADD_DIALOG;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM DELETE_DIALOG_BY_ID FOR FISHY_ADMIN.DELETE_DIALOG_BY_ID;
--DROP PUBLIC SYNONYM DELETE_DIALOG_BY_ID;

--DROP PROCEDURE DELETE_DIALOG_BY_ID;
CREATE OR REPLACE PROCEDURE DELETE_DIALOG_BY_ID(
USER_ID USERS.ID%TYPE,
DIALOG_ID DIALOGS.ID%TYPE)
IS
  TEMP_USER_ID DIALOGS.CREATOR_ID%TYPE;
BEGIN
  SELECT CREATOR_ID INTO TEMP_USER_ID
    FROM DIALOGS WHERE ID = DIALOG_ID;
  IF USER_ID = TEMP_USER_ID THEN
    DELETE DIALOGS WHERE ID = DIALOG_ID;
  ELSE
    RAISE EXCEPTION_PACKAGE.NO_PRIVILEGES;
  END IF;
  COMMIT;
EXCEPTION
  WHEN EXCEPTION_PACKAGE.NO_PRIVILEGES THEN
        RAISE_APPLICATION_ERROR(-20053, 'no plivileges');
        
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20052, 'dialog with that id does not exist');
        
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20051, 'delete dialog error check the entered data');
END DELETE_DIALOG_BY_ID;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM INVITE_USER_TO_DIALOG FOR FISHY_ADMIN.INVITE_USER_TO_DIALOG;
--DROP PUBLIC SYNONYM INVITE_USER_TO_DIALOG;

--DROP PROCEDURE INVITE_USER_TO_DIALOG;
CREATE OR REPLACE PROCEDURE INVITE_USER_TO_DIALOG(
U_ID USERS.ID%TYPE,
D_ID DIALOGS.ID%TYPE)
IS
BEGIN
  IF CHECK_USER_IN_DIALOG(U_ID,D_ID) = FALSE THEN
    INSERT INTO USERS_TO_DIALOGS 
      VALUES(U_ID,D_ID);
  ELSE
    RAISE EXCEPTION_PACKAGE.USER_ALREADY_IN_DIALOG;
  END IF;
  COMMIT;
EXCEPTION
  WHEN EXCEPTION_PACKAGE.USER_ALREADY_IN_DIALOG THEN
    RAISE_APPLICATION_ERROR(-20054, 'user already in dialog');
        
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20055, 'invite user to dialog error ');
END INVITE_USER_TO_DIALOG;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM REMOVE_USER_OF_DIALOG FOR FISHY_ADMIN.REMOVE_USER_OF_DIALOG;
--DROP PUBLIC SYNONYM REMOVE_USER_OF_DIALOG;

--DROP PROCEDURE REMOVE_USER_OF_DIALOG;
CREATE OR REPLACE PROCEDURE REMOVE_USER_OF_DIALOG(
U_ID USERS.ID%TYPE,
D_ID DIALOGS.ID%TYPE)
IS
BEGIN
  IF CHECK_USER_IN_DIALOG(U_ID,D_ID) = FALSE THEN
      RAISE EXCEPTION_PACKAGE.USER_DOESNT_IN_DIALOG;
  ELSE
    DELETE USERS_TO_DIALOGS 
      WHERE USER_ID = U_ID 
        AND DIALOG_ID = D_ID;
  END IF;
  COMMIT;
EXCEPTION
  WHEN EXCEPTION_PACKAGE.USER_DOESNT_IN_DIALOG THEN
    RAISE_APPLICATION_ERROR(-20056, 'user not in dialog');
        
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20057, 'delete user of dialog error ');
END REMOVE_USER_OF_DIALOG;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM CHECK_USER_IN_DIALOG FOR FISHY_ADMIN.CHECK_USER_IN_DIALOG;
--DROP PUBLIC SYNONYM CHECK_USER_IN_DIALOG;

--DROP FUNCTION CHECK_USER_IN_DIALOG;
CREATE OR REPLACE FUNCTION CHECK_USER_IN_DIALOG(
U_ID USERS.ID%TYPE,
D_ID DIALOGS.ID%TYPE) 
RETURN BOOLEAN
IS
  FLAG NUMBER;
BEGIN
    SELECT COUNT(*) INTO FLAG 
      FROM USERS_TO_DIALOGS 
        WHERE USER_ID = U_ID 
          AND DIALOG_ID = D_ID;
  IF FLAG = 0 THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
EXCEPTION 
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20059, 'check user in dialog error');
    RETURN NULL;
END CHECK_USER_IN_DIALOG;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM GET_DIALOG_BY_ID FOR FISHY_ADMIN.GET_DIALOG_BY_ID;
--DROP PUBLIC SYNONYM GET_DIALOG_BY_ID;

--DROP PROCEDURE GET_DIALOG_BY_ID;
CREATE OR REPLACE PROCEDURE GET_DIALOG_BY_ID(
RESULT_CURSOR OUT SYS_REFCURSOR,
U_ID IN DIALOGS_VIEW.USER_ID%TYPE,
D_ID IN DIALOGS_VIEW.DIALOG_ID%TYPE)
IS
BEGIN
  OPEN RESULT_CURSOR FOR 
    SELECT DIALOG_ID,DIALOG_TITLE,DIALOG_CREATED 
      FROM DIALOGS_VIEW 
        WHERE USER_ID = U_ID 
          AND DIALOG_ID = D_ID;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20058, 'error when reading dialogs');
END GET_DIALOG_BY_ID;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM GET_DIALOGS_BY_TITLE FOR FISHY_ADMIN.GET_DIALOGS_BY_TITLE;
--DROP PUBLIC SYNONYM GET_DIALOGS_BY_TITLE;

--DROP PROCEDURE GET_DIALOGS_BY_TITLE;
CREATE OR REPLACE PROCEDURE GET_DIALOGS_BY_TITLE(
RESULT_CURSOR OUT SYS_REFCURSOR,
U_ID IN DIALOGS_VIEW.USER_ID%TYPE,
D_TITLE IN DIALOGS_VIEW.DIALOG_TITLE%TYPE)
IS
BEGIN
  OPEN RESULT_CURSOR FOR 
    SELECT DIALOG_ID,DIALOG_TITLE,DIALOG_CREATED 
      FROM DIALOGS_VIEW 
        WHERE USER_ID = U_ID 
          AND UPPER(DIALOG_TITLE) LIKE UPPER('%'||D_TITLE||'%') 
            ORDER BY DIALOG_CREATED DESC;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20058, 'error when reading dialogs');
END GET_DIALOGS_BY_TITLE;
--------------------------------------------------------------------------------
CREATE PUBLIC SYNONYM GET_DIALOGS_BY_CREATOR_ID FOR FISHY_ADMIN.GET_DIALOGS_BY_CREATOR_ID;
--DROP PUBLIC SYNONYM GET_DIALOGS_BY_CREATOR_ID;

--DROP PROCEDURE GET_DIALOGS_BY_CREATOR_ID;
CREATE OR REPLACE PROCEDURE GET_DIALOGS_BY_CREATOR_ID(
RESULT_CURSOR OUT SYS_REFCURSOR,
C_ID IN DIALOGS_VIEW.CREATOR_ID%TYPE)
IS
BEGIN
  OPEN RESULT_CURSOR FOR 
    SELECT DIALOG_ID,DIALOG_TITLE,DIALOG_CREATED 
      FROM DIALOGS_VIEW
        WHERE CREATOR_ID = C_ID
          ORDER BY DIALOG_CREATED DESC;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20058, 'error when reading dialogs');
END GET_DIALOGS_BY_CREATOR_ID;
--------------------------------------------------------------------------------

