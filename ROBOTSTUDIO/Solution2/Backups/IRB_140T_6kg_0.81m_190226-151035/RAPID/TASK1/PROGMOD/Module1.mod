MODULE Module1
	CONST robtarget pHome:=[[506.291650772,0,679.49999918],[0.499999994,0,0.866025407,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Target_20:=[[673.072517146,0,679.499956874],[0.499999981,0,0.866025415,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Target_30:=[[673.07251534,0,448.238585921],[0.499999997,0,0.866025406,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Target_40:=[[673.07251325,362.252706489,448.238608816],[0.500000007,0.000000031,0.8660254,0.000000015],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Target_50:=[[673.072508851,362.252704069,634.404616382],[0.500000027,0.000000026,0.866025388,0.000000022],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget Target_60:=[[91.080765758,-501.618917637,634.40447117],[0.500000031,-0.000000102,0.866025386,0.000000049],[-1,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !***********************************************************
    !
    ! Module:  Module1
    !
    ! Description:
    !   <Insert description here>
    !
    ! Author: pol_4
    !
    ! Version: 1.0
    !
    !***********************************************************
    
    
    !***********************************************************
    !
    ! Procedure main
    !
    !   This is the entry point of your program
    !
    !***********************************************************
    PROC main()
		MoveL pHome,v1000,z100,tool0\WObj:=wobj0;
		MoveL Target_20,v1000,z100,tool0\WObj:=wobj0;
		MoveL Target_30,v1000,z100,tool0\WObj:=wobj0;
		MoveL Target_40,v1000,z100,tool0\WObj:=wobj0;
		MoveL Target_50,v1000,z100,tool0\WObj:=wobj0;
		MoveL Target_60,v1000,z100,tool0\WObj:=wobj0;
		MoveL pHome,v1000,z100,tool0\WObj:=wobj0;
        !Add your code here
    ENDPROC
ENDMODULE