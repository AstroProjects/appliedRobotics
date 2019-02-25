MODULE Module1
    !***********************************************************
    !
    ! Module:  Module1
    !
    ! Description:
    !   <Insert description here>
    !
    ! Author: VICTOR & POL
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
    CONST robtarget pHOME:=[[0, 0, 0],[1, 0, 0,0],[1,0,0,0],[11,12.3,9E9,9E9,9E9,9E9]];
    CONST robtarget p10:=[[0, 0, 0],[10, 0, 0,0],[1,0,0,0],[11,12.3,9E9,9E9,9E9,9E9]];
    
    PROC main()
        !Add your code here
        MoveL pHOME,v1000,fine,tool0; !go to home
        MoveL p10,v1000,fine,tool0;   !go to p10
        MoveL pHOME,v1000,fine,tool0; !go to home
    ENDPROC
ENDMODULE