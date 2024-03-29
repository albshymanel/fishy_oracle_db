---------------------------------ROLE-------------------------------------------
DROP ROLE RL_FISHY_USER;
CREATE ROLE RL_FISHY_USER;

GRANT CREATE SESSION TO RL_FISHY_USER;
GRANT RESTRICTED SESSION TO RL_FISHY_USER;

GRANT EXECUTE ON REGISTRATION TO RL_FISHY_USER;
GRANT EXECUTE ON CHANGE_AGE  TO RL_FISHY_USER;
GRANT EXECUTE ON CHANGE_INFO TO RL_FISHY_USER;
GRANT EXECUTE ON CHANGE_AVATAR TO RL_FISHY_USER;
GRANT EXECUTE ON LOGIN TO RL_FISHY_USER;
GRANT EXECUTE ON GET_USER_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_USERS_BY_NAME TO RL_FISHY_USER;
GRANT EXECUTE ON GET_USER_BY_EMAIL TO RL_FISHY_USER;

GRANT EXECUTE ON ADD_FRIEND TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_FRIEND_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_FRIEND_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_FRIEND_BY_EMAIL TO RL_FISHY_USER;

GRANT EXECUTE ON ADD_ALBUM TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_ALBUM_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_ALBUM_BY_USER_ID TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_ALBUM_BY_TITLE TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_ALBUM_BY_DATE TO RL_FISHY_USER;
GRANT EXECUTE ON UPDATE_ALBUM TO RL_FISHY_USER;
GRANT EXECUTE ON GET_ALBUM_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_ALBUMS_BY_USER_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_ALBUMS_BY_TITLE TO RL_FISHY_USER;
GRANT EXECUTE ON GET_ALBUMS_BY_DATE TO RL_FISHY_USER;

GRANT EXECUTE ON ADD_PHOTO TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_PHOTO_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_PHOTO_BY_ALBUM_ID TO RL_FISHY_USER;
GRANT EXECUTE ON UPDATE_PHOTO_COORDS TO RL_FISHY_USER;
GRANT EXECUTE ON GET_PHOTOS_BY_ALBUM_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_PHOTO_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_PHOTO_BY_USER_ID TO RL_FISHY_USER;

GRANT EXECUTE ON ADD_COMMENT TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_COMMENT_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_COMMENT_BY_PHOTO_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_COMMENTS_BY_PHOTO_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_COMMENT_BY_ID TO RL_FISHY_USER;

GRANT EXECUTE ON ADD_DIALOG TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_DIALOG_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON INVITE_USER_TO_DIALOG TO RL_FISHY_USER;
GRANT EXECUTE ON REMOVE_USER_OF_DIALOG TO RL_FISHY_USER;
GRANT EXECUTE ON CHECK_USER_IN_DIALOG TO RL_FISHY_USER;
GRANT EXECUTE ON GET_DIALOG_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_DIALOGS_BY_TITLE TO RL_FISHY_USER;
GRANT EXECUTE ON GET_DIALOGS_BY_CREATOR_ID TO RL_FISHY_USER;

GRANT EXECUTE ON ADD_MESSAGE TO RL_FISHY_USER;
GRANT EXECUTE ON DELETE_MESSAGE TO RL_FISHY_USER;
GRANT EXECUTE ON CHECK_MESSAGE_SENDER TO RL_FISHY_USER;
GRANT EXECUTE ON GET_MESSAGE_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_MESSAGES_BY_DIALOG_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_MESSAGES_BY_SENDER_ID TO RL_FISHY_USER;

GRANT EXECUTE ON GET_FISHES TO RL_FISHY_USER;
GRANT EXECUTE ON GET_FISH_BY_NAME TO RL_FISHY_USER;
GRANT EXECUTE ON GET_FISH_BY_ID TO RL_FISHY_USER;

GRANT EXECUTE ON GET_NEWS TO RL_FISHY_USER;
GRANT EXECUTE ON GET_NEWS_BY_ID TO RL_FISHY_USER;
GRANT EXECUTE ON GET_NEWS_BY_TITLE TO RL_FISHY_USER;

GRANT EXECUTE ON VALIDATION_PACKAGE TO RL_FISHY_USER;
GRANT EXECUTE ON EXCEPTION_PACKAGE TO RL_FISHY_USER;

--------------------------------USER--------------------------------------------
DROP USER FISHY_USER;
CREATE USER FISHY_USER IDENTIFIED BY Root12345
    ACCOUNT UNLOCK;
    GRANT RL_FISHY_USER TO FISHY_USER;

SELECT * FROM USER_SYS_PRIVS; 
SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;
--------------------------------------------------------------------------------