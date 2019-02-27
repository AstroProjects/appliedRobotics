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
        conv2oven;
        home2conv;
    ENDPROC
	PROC home2conv()
	    MoveJ pHome,v1000,z100,tool0\WObj:=wobj0;
	    MoveJ conv1_10,v1000,z100,tool0\WObj:=wobj0;
	ENDPROC
	PROC conv2oven()
	    MoveJ conv1_10,v1000,fine,tool0\WObj:=wobj0;
	    MoveJ oven_10,v1000,fine,tool0\WObj:=wobj0;
	ENDPROC
ENDMODULE