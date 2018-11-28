/*	版本日志
	  Version：v.1.1.o
	  Date：2018-04-24
	  Author：zhengli
	  Release Notes：
		1、log_id修改为Rawtohex(sys_guid()),数据类型varchar2(32)
		2、err_text、error_backtrace修改为500
		3、删除序列seq_log_id
*/

--创建日志表
CREATE TABLE T_LOG(
	   LOG_ID VARCHAR2(32) PRIMARY KEY,
	   OBJECT_NAME VARCHAR2(100),
	   START_TIME DATE,
	   END_TIME DATE,
	   ERR_TIME DATE,
	   ERR_CODE NUMBER,
	   ERR_TEXT VARCHAR2(500),
	   ERROR_BACKTRACE VARCHAR2(500)
);

--创建程序包头
CREATE OR REPLACE Package Pkg_Log As

    Function Log_Start
    (
        In_Object_Name Varchar2
       ,In_Start_Time  Date Default Sysdate
    ) Return Varchar2;

    Procedure Log_End
    (
        In_Log_Id   Varchar2
       ,In_End_Time Date Default Sysdate
    );

    Procedure Log_Err
    (
        In_Log_Id   Varchar2
       ,In_Err_Code Number Default Sqlcode
       ,In_Err_Text Varchar2 Default Substr(Sqlerrm, 1, 500)
       ,In_Err_Time Date Default Sysdate
       ,in_error_backtrace Varchar2 Default substr(dbms_utility.format_error_backtrace,1,500)
    );

End Pkg_Log;

--创建程序包体
CREATE OR REPLACE Package Body Pkg_Log As
    Function Log_Start
    (
        In_Object_Name Varchar2
       ,In_Start_Time  Date Default Sysdate
    ) Return Varchar2 As
        v_Log_Id Varchar2(32);
    Begin
        v_Log_Id := Rawtohex(sys_guid());
        Execute Immediate 'insert into t_log(log_id,object_name,start_time) values(:1,:2,:3)'
            Using v_Log_Id, In_Object_Name, In_Start_Time;
        Commit;
        Return v_Log_Id;
    End Log_Start;

    Procedure Log_End
    (
        In_Log_Id   Varchar2
       ,In_End_Time Date Default Sysdate
    ) As
    Begin
        Execute Immediate 'update t_log set end_time=:1 where log_id=:2'
            Using In_End_Time, In_Log_Id;
        Commit;
    End Log_End;

    Procedure Log_Err
    (
        In_Log_Id   Varchar2
       ,In_Err_Code Number Default Sqlcode
       ,In_Err_Text Varchar2 Default Substr(Sqlerrm, 1, 500)
       ,In_Err_Time Date Default Sysdate
       ,in_error_backtrace Varchar2 Default substr(dbms_utility.format_error_backtrace,1,500)
    ) As
        --v_err_code Number;
        --v_Err_Text Varchar2(200);
        --v_error_backtrace Varchar2(200);
    Begin
        --v_err_code := In_Err_Code;
        --v_Err_Text := Substr(In_Err_Text, 1, 200);
        --v_error_backtrace := Substr(in_error_backtrace, 1, 200);
        Execute Immediate 'update t_log set err_code=:1,err_text=:2,err_time=:3,error_backtrace=:4 where log_id=:5'
            Using In_Err_Code, In_Err_Text, In_Err_Time,in_error_backtrace,In_Log_Id;
        Commit;
    End Log_Err;

End Pkg_Log;




