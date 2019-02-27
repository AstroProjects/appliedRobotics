MODULE ObelixMov
    !***********************************************************
    !
    ! Module:  ObelixMov
    !
    ! Description:
    !   Move the robot
    !
    ! Author: pol & victor
    !
    ! Version: 0.0.1
    !
    !***********************************************************
    
    CONST robtarget pHome:=[[507.90,-6.43,715.02],[0.697685,-0.00154316,0.716328,-0.0103435],[-1,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pConv:=[[-49.18,-617.16,499.98],[0.309443,0.549198,0.646739,-0.429365],[-2,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pMan:=[[635.90,42.30,481.74],[0.518931,-0.131239,0.843441,-0.0457607],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pOven:=[[-400.60,632.71,501.69],[0.350259,-0.742904,0.298477,0.486132],[1,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST num ovenPosOffsetX := 100;
    CONST num ovenPosOffsetZ := 100;
    CONST num ovenInOffsetY := 100;
    
    ! Define the points
    VAR robtarget pOvenMatrix{3,3};
    
    
    
    !***********************************************************
    !
    ! Procedure main
    !
    !   This is the entry point of your program
    !
    !***********************************************************
    PROC main()
        MoveJ pHome, v1000, fine, tool0;
        !-----------------------------------
        defineOvenPts pOven, ovenPosOffsetX, ovenPosOffsetZ, pOvenMatrix;
        
        gotoOvenPts pOvenMatrix, ovenInOffsetY;
        
        
        !-----------------------------------
        MoveJ pHome, v1000, fine, tool0;
    ENDPROC
    
    PROC defineOvenPts(robtarget orig, num dx, num dz, INOUT robtarget pts{*,*})
        
        !define the points
        FOR i FROM 1 TO 3 DO
            FOR j FROM 1 TO 3 DO
                pts{i,j} := Offs(orig, dx*(i-1), 0, dz*(j-1));
            ENDFOR
        ENDFOR
    ENDPROC
    
    PROC gotoOvenPts(robtarget pts{*,*}, num dy)
        FOR i FROM 1 TO 3 DO
            FOR j FROM 1 TO 3 DO
                MoveJ pts{i,j}, v1000, fine, tool0;
                MoveL Offs(pts{i,j}, 0, dy, 0), v500, fine, tool0;
                MoveL pts{i,j}, v500, fine, tool0;
            ENDFOR
        ENDFOR
    ENDPROC
    
ENDMODULE