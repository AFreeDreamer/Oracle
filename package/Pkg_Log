CREATE OR REPLACE Package Body Pkg_Log As

    /*
    Create Table t_log(
           log_id Integer primary key,
           object_name Varchar2(100),
           start_time Date,
           end_time Date,
           err_code Number,
           err_text Varchar2(1000),
           err_time date,
           error_backtrace Varchar2(200)
    );
    Create Sequence seq_log_id
    Start With 1
    Maxvalue 9999999999
    Increment By 1
    Cache 50;
	Version：v1.0
    */
    Function Log_Start
    (
        In_Object_Name Varchar2
       ,In_Start_Time  Date Default Sysdate
    ) Return Integer As
        v_Log_Id Integer;
    Begin
        v_Log_Id := Seq_Log_Id.Nextval;
        Execute Immediate 'insert into t_log(log_id,object_name,start_time) values(:1,:2,:3)'
            Using v_Log_Id, In_Object_Name, In_Start_Time;
        Commit;
        Return v_Log_Id;
    End Log_Start;

    Procedure Log_End
    (
        In_Log_Id   Integer
       ,In_End_Time Date Default Sysdate
    ) As
    Begin
        Execute Immediate 'update t_log set end_time=:1 where log_id=:2'
            Using In_End_Time, In_Log_Id;
        Commit;
    End Log_End;

    Procedure Log_Err
    (
        In_Log_Id   Integer
       ,In_Err_Code Number
       ,In_Err_Text Varchar2
       ,In_Err_Time Date Default Sysdate
       ,in_error_backtrace Varchar2 Default dbms_utility.format_error_backtrace
    ) As
        v_err_code Number;
        v_Err_Text Varchar2(200);
        v_error_backtrace Varchar2(200);
    Begin
        v_err_code := In_Err_Code;
        v_Err_Text := Substr(In_Err_Text, 1, 200);
        v_error_backtrace := Substr(in_error_backtrace, 1, 200);
        Execute Immediate 'update t_log set err_code=:1,err_text=:2,err_time=:3,error_backtrace=:4 where log_id=:5'
            Using v_err_code, v_Err_Text, In_Err_Time,v_error_backtrace,In_Log_Id;
        Commit;
    End Log_Err;

End Pkg_Log;
