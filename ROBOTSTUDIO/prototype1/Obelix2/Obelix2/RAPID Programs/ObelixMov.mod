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
    ! Version: 0.1.0
    !
    !***********************************************************
    
    CONST robtarget pHome    :=[[507.9,-6.43,715.02],[0.697685,-0.00154316,0.716328,-0.0103435],[-1,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pConvRef :=[[-109.516885301,-504.792720334,376.620999376],[0.243054291,0.717735721,0.578717345,-0.301440343],[-2,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget pManRef  :=[[580,42.299990184,552.739936658],[0.51893094,-0.131239024,0.843441139,-0.045760712],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pOvenRef :=[[-291.029880742,659.908842444,594.297264732],[0.363486279,-0.625201176,0.407577419,0.55756781],[1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST num convSecOffset{3} := [0, 0, -100];   !security offset [x, y, z]
    CONST num manSecOffset{3} := [0, 0, -100];    !security offset [x, y, z]
    CONST num ovenSecOffset{3} := [0, 100, 0];   !security offset [x, y, z]
    
    CONST num convOffset{3} := [0, -200, 0];        !offset between 2 conv [x, y, z]
    CONST num ovenMatOffset{3} := [100, 0, -100]; !offset between oven positions [x, y, z]
    
    
    ! Points variables preallocation
    VAR robtarget pConv{2,2};
    VAR robtarget pOven{2,3,3};
    VAR robtarget pMan{2};
    
    ! Flexpendant vars
    VAR num numChoc{2,2}; !{1,*} num produced; {2,*} Total to produce
    VAR num chocType;
    
    !Interrupts
    !VAR intnum pushBot;
    
    
    !***********************************************************
    !
    ! Procedure main
    !
    !   This is the entry point of your program
    !
    !***********************************************************
    PROC main()
        MoveJ pHome, v1000, fine, tool0;
        MoveJ pConvRef, v1000, fine, tool0;
        !-----------------------------------
        
        ! 0. Points definition
        pMan := [pManRef, Offs(pManRef, manSecOffset{1}, manSecOffset{2}, manSecOffset{3})];
        defineConvPts pConvRef, convOffset, convSecOffset, pConv;
        defineOvenPts pOvenRef, ovenMatOffset, ovenSecOffset, pOven;
        
        ! 1. Job Configuration
        !TPErase;
        !TPWrite "Welcome to the chocolate factory";
        !TPReadNum numChoc{2,1}, "How many chocolate 1 items will be produced?";
        !TPReadNum numChoc{2,2}, "How many chocolate 2 items will be produced?";
        !updateDisp numChoc;
        
        ! 2. Start the job
        !triggerSeq chocType, numChoc;
        
        ! 3. Connect interrupts
        !CONNECT pushBot WITH iMove;
        
        !WHILE n{2,1}+n{2,2}>n{1,1}+n{1,2} DO
            
        !ENDWHILE
        
        
        
        ! TEST. Movement Tests
        movTest pConv, pOven, pMan;
        
        !TODO: See if the mov. sequences can be extracted to a PROC (they are a sequence of MoveJ, MoveJ, MoveJ)
        
        !-----------------------------------
        MoveJ pHome, v1000, fine, tool0;
    ENDPROC
    
    !***********************************************************
    PROC defineOvenPts(robtarget orig, num matOffs{*}, num secOffs{*}, INOUT robtarget pts{*,*,*})
        
        !define the security points {1} and the inside oven points {2}
        FOR i FROM 1 TO 3 DO
            FOR j FROM 1 TO 3 DO
                pts{1,i,j} := Offs(orig, matOffs{1}*(i-1), matOffs{2}, matOffs{3}*(j-1));
                pts{2,i,j} := Offs(pts{1,i,j}, secOffs{1}, secOffs{2}, secOffs{3});
            ENDFOR
        ENDFOR
    ENDPROC
    
    !***********************************************************
    PROC defineConvPts(robtarget orig, num convOffs{*}, num secOffs{*}, INOUT robtarget pts{*,*})
        
        !define the security points {1} and the conv points {2}
        FOR i FROM 1 TO 2 DO
                pts{1,i} := Offs(orig, convOffs{1}*(i-1), convOffs{2}*(i-1), convOffs{3}*(i-1));
                pts{2,i} := Offs(pts{1,i}, secOffs{1}, secOffs{2}, secOffs{3});
        ENDFOR
    ENDPROC
    
    !***********************************************************
    PROC gotoOvenPts(robtarget pts{*,*,*})
        FOR i FROM 1 TO 3 DO
            FOR j FROM 1 TO 3 DO
                MoveJ pts{1,i,j}, v1000, fine, tool0;
                MoveJ pts{2,i,j}, v200, fine, tool0;
                MoveJ pts{1,i,j}, v200, fine, tool0;
            ENDFOR
        ENDFOR
    ENDPROC
    
    !***********************************************************
    PROC conv2oven(robtarget pConv{*,*}, robtarget pOven{*,*,*}, num iConv, num iOven, num jOven)
        
        MoveJ pConv{1, iConv}, v1000, fine, tool0;
        MoveJ pConv{2, iConv}, v200, fine, tool0;
        MoveJ pConv{1, iConv}, v200, fine, tool0;
        
        MoveJ pOven{1, iOven, jOven}, v1000, fine, tool0;
        MoveJ pOven{2, iOven, jOven}, v200, fine, tool0;
        MoveJ pOven{1, iOven, jOven}, v200, fine, tool0;
        
        !TODO: set timer taking into account iOven, jOven, chocoType
        !TODO: return to pHome?
          
    ENDPROC
    
    !***********************************************************
    PROC oven2man(robtarget pOven{*,*,*}, robtarget pMan{*}, num iOven, num jOven)
        
        MoveJ pOven{1, iOven, jOven}, v1000, fine, tool0;
        MoveJ pOven{2, iOven, jOven}, v200, fine, tool0;
        MoveJ pOven{1, iOven, jOven}, v200, fine, tool0;
        
        MoveJ pMan{1}, v1000, fine, tool0;
        MoveJ pMan{2}, v200, fine, tool0;
        MoveJ pMan{1}, v200, fine, tool0;
        
        !TODO: set timer for the dryer or wait 5 sections (Idle time)
        !TODO: return to pHome?
          
    ENDPROC
    
    !***********************************************************
    PROC man2conv(robtarget pMan{*}, robtarget pConv{*,*}, num iConv)
            
        !MoveJ pMan{1}, v1000, fine, tool0;
        !MoveJ pMan{2}, v200, fine, tool0;
        !MoveJ pMan{1}, v200, fine, tool0;
        MoveS pMan, v1000, v200, fine, tool0;
        
        !MoveJ pConv{1, iConv}, v1000, fine, tool0;
        !MoveJ pConv{2, iConv}, v200, fine, tool0;
        !MoveJ pConv{1, iConv}, v200, fine, tool0;
        MoveS [pConv{1,iConv}, pConv{2,iConv}], v1000, v200, fine, tool0;
        
        !TODO: set timer for the dryer or wait 5 sections (Idle time)
        !TODO: return to pHome?
          
    ENDPROC
    
    !***********************************************************
    PROC triggerSeq(INOUT num type, INOUT num n{*,*})
        TPReadFK type, "A chocolate figure has arrived to the station. Which type of chocolate is?", "TP1", "TP2", stEmpty,stEmpty,stEmpty;
        
        !Update chocolate counters
        TEST type
            CASE 1:
                n{1,1} := n{1,1} + 1;
                ! do more things?
            CASE 2:
                n{1,2} := n{1,2} + 1;
                ! do more things?
            DEFAULT:
                !do nothing
        ENDTEST
        
        !Erase the contents of the display and print the numbers of figures completed
        updateDisp n;
        
        !TODO: Trigger the program
    ENDPROC
    
    !***********************************************************
    PROC updateDisp(num n{*,*})
        TPErase;
        
        TPWrite "CHOCOLATE TYPE 1:";
        TPWrite "   Produced = ", \Num := n{1,1};
        TPWrite "   Total = ", \Num := n{2,1};
        TPWrite "CHOCOLATE TYPE 2:";
        TPWrite "   Produced = ", \Num := n{1,2};
        TPWrite "   Total = ", \Num := n{2,2};
    ENDPROC
    
    !***********************************************************
    PROC MoveS(robtarget p{*}, speeddata vFree, speeddata vSec, zonedata z, PERS tooldata t)
            
        MoveJ p{1}, vFree, z, t;
        MoveJ p{2}, vSec, z, t;
        MoveJ p{1}, vSec, z, t;
          
    ENDPROC
    
    !***********************************************************
    PROC movTest(robtarget pConv{*,*}, robtarget pOven{*,*,*}, robtarget pMan{*})
        ! Perform diferent movement tests
        !oven2oven
        gotoOvenPts pOven;
        
        !conv2oven
        FOR i FROM 1 TO 3 DO
            FOR j FROM 1 TO 3 DO
                conv2oven pConv, pOven, 1, i, j;
            ENDFOR
        ENDFOR
        
        !oven2man
        FOR i FROM 1 TO 3 DO
            FOR j FROM 1 TO 3 DO
                oven2man pOven, pMan, i, j;
            ENDFOR
        ENDFOR
        
        !man2conv
        man2conv pMan, pConv, 2;
        
        !oven2home
        FOR i FROM 1 TO 3 DO
            FOR j FROM 1 TO 3 DO
                MoveJ pOven{1, i, j}, v1000, fine, tool0;
                MoveJ pHome, v1000, fine, tool0;
            ENDFOR
        ENDFOR
        
        !conv2home
        FOR i FROM 1 TO 2 DO
            MoveJ pConv{1, i}, v1000, fine, tool0;
            MoveJ pHome, v1000, fine, tool0;
        ENDFOR
        
        !man2home
        MoveJ pMan{1}, v1000, fine, tool0;
        MoveJ pHome, v1000, fine, tool0;
    ENDPROC
    
ENDMODULE