MODULE Module1
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
        !Add your code here
        conv2oven;
        oven2man;
        man2conv;
    ENDPROC
	PROC conv2oven()
	    MoveL pHome,v1000,z100,tool0\WObj:=wobj0;
	    MoveL conveyor,v1000,z100,tool0\WObj:=wobj0;
	    MoveL Oven,v1000,z100,tool0\WObj:=wobj0;
	    MoveL pHome,v1000,z100,tool0\WObj:=wobj0;
	ENDPROC
	PROC oven2man()
	    MoveL pHome,v1000,z100,tool0\WObj:=wobj0;
	    MoveL Oven,v1000,z100,tool0\WObj:=wobj0;
	    MoveL manipulation,v1000,z100,tool0\WObj:=wobj0;
	    MoveL pHome,v1000,z100,tool0\WObj:=wobj0;
	ENDPROC
	PROC man2conv()
	    MoveL pHome,v1000,z100,tool0\WObj:=wobj0;
	    MoveL manipulation,v1000,z100,tool0\WObj:=wobj0;
	    MoveL conveyor,v1000,z100,tool0\WObj:=wobj0;
	    MoveL pHome,v1000,z100,tool0\WObj:=wobj0;
	ENDPROC
ENDMODULE