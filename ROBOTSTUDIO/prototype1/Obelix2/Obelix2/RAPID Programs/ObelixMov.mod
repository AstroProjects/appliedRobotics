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
    
    ! Task variables
    ! +---------+------------------------------------------------+
    ! | Task ID |                Task Description                |
    ! +---------+------------------------------------------------+
    ! |       1 | pick choco from conveyor1 & bring to oven      |
    ! |       2 | take choco1 from oven & bring to man. station  |
    ! |       3 | take choco2 from oven & bring to man. station  |
    ! |       4 | take the mould from ms & throw it to conveyor2 |
    ! |       0 | no task                                        |
    ! +---------+------------------------------------------------+
    
    VAR num taskTimming{4} := [0+30, 60, 120, 5+30]; ! time in seconds for each task
    VAR num taskQueue{2,3}; ![Task id, completion time, opt_par]
    
    VAR bool occOven{9}; ! idx computed as (i-1)*3+j
    
    ! Points variables
    VAR robtarget pConv{2,2};
    VAR robtarget pOven{2,3,3};
    VAR robtarget pMan{2};
    
    ! Flexpendant vars
    VAR num numChoc{2,2}; !{1,*} num produced; {2,*} Total to produce
    VAR num chocType;
    
    !Interrupts
    VAR intnum pushInt;
    
    
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
        
        ! 0. Points definition
        pMan := [pManRef, Offs(pManRef, manSecOffset{1}, manSecOffset{2}, manSecOffset{3})];
        defineConvPts pConvRef, convOffset, convSecOffset, pConv;
        defineOvenPts pOvenRef, ovenMatOffset, ovenSecOffset, pOven;
        
        ! 1. Job Configuration
        TPErase;
        TPWrite "Welcome to the chocolate factory";
        TPReadNum numChoc{2,1}, "How many chocolate 1 items will be produced?";
        TPReadNum numChoc{2,2}, "How many chocolate 2 items will be produced?";
        updateDisp numChoc;
        
        
        !triggerSeq chocType, numChoc;
        
        ! 2. Connect interrupts
        CONNECT pushInt WITH iMove;
        ISignalDI di0,1,pushInt;
        
        
        ! 3. Start the job
        !while produced < total
        WHILE numChoc{1,1}+numChoc{1,2}<numChoc{2,1}+numChoc{2,2} DO
            performTask taskQueue, occOven, taskTimming, pConv, pOven, pMan;
        ENDWHILE
        
        
        ! TEST. Movement Tests
        movTest pConv, pOven, pMan;
        
        !-----------------------------------
        MoveJ pHome, v1000, fine, tool0;
    ENDPROC
    
    !***********************************************************
    TRAP iMove
        triggerSeq chocType, numChoc, taskQueue, taskTimming;
    ENDTRAP
    
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
                MoveS [pOven{1, i, j}, pOven{2, i, j}], v1000, v200, fine, tool0;
            ENDFOR
        ENDFOR
    ENDPROC
    
    !***********************************************************
    PROC conv2oven(robtarget pConv{*,*}, robtarget pOven{*,*,*}, num iConv, num iOven, num jOven)
        
        MoveS [pConv{1, iConv}, pConv{2, iConv}], v1000, v200, fine, tool0;
        
        MoveS [pOven{1, iOven, jOven}, pOven{2, iOven, jOven}], v1000, v200, fine, tool0;
          
    ENDPROC
    
    !***********************************************************
    PROC oven2man(robtarget pOven{*,*,*}, robtarget pMan{*}, num iOven, num jOven)
        
        MoveS [pOven{1, iOven, jOven}, pOven{2, iOven, jOven}], v1000, v200, fine, tool0;
        
        MoveS pMan, v1000, v200, fine, tool0;
          
    ENDPROC
    
    !***********************************************************
    PROC man2conv(robtarget pMan{*}, robtarget pConv{*,*}, num iConv)
            
        MoveS pMan, v1000, v200, fine, tool0;
        
        MoveS [pConv{1, iConv}, pConv{2, iConv}], v1000, v200, fine, tool0;
          
    ENDPROC
    
    !***********************************************************
    PROC triggerSeq(INOUT num type, INOUT num n{*,*}, INOUT num queue{*,*}, num time{*})
        
        VAR num newTask{3};
        VAR num auxTask{3};
		
		VAR num currTime;
        currTime := GetTime(\Hour)*3600 + GetTime(\Min)*60 + GetTime(\Sec);
        
        TPReadFK type, "A chocolate figure has arrived to the station. Which type of chocolate is?", "TP1", "TP2", stEmpty,stEmpty,stEmpty;
        
        !Update chocolate counters
        IF type = 1 THEN
            Incr n{1,1};
        ELSE
            Incr n{1,2};
        ENDIF
        
        !Erase the contents of the display and print the numbers of figures completed
        updateDisp n;
        
        !Add a task 1 to the queue
        newTask := [1, CurrTime+time{1}, 0];
        FOR i FROM 1 TO Dim(queue, 1) DO
            IF newTask{2} < queue{i,2} OR queue{i,1} = 0 THEN
                !backup newTask
                auxTask := newTask;
                
                newTask{1} := queue{i,1}; 
                newTask{2} := queue{i,2}; 
                newTask{3} := queue{i,3};
                
                queue{i,1} := auxTask{1}; 
                queue{i,2} := auxTask{2}; 
                queue{i,3} := auxTask{3};
            ENDIF
        ENDFOR
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
    PROC performTask(INOUT num queue{*,*}, INOUT bool occOven{*}, num time{*},
                     robtarget pConv{*,*}, robtarget pOven{*,*,*}, robtarget pMan{*})
                     
        VAR num iOven;
        VAR num jOven;
        VAR bool found := FALSE;
        VAR num newTask{3}; ![taskID, time, opt]
        
        VAR num currTime;
        currTime := GetTime(\Hour)*3600 + GetTime(\Min)*60 + GetTime(\Sec);
        
!        FOR i FROM 1 TO Dim(queue, 1) DO
!            TPWrite "a = ", \Num:=queue{i,1};
!        ENDFOR
        
        !Switch TaskID
        TEST queue{1,1} 
            CASE 1:
                !check the 1st empty position on the oven
                FOR i FROM 1 TO 9 DO
                    IF (NOT occOven{i}) AND (NOT found) THEN
                        found := TRUE;
                        
                        iOven := i DIV 3;
                        jOven := i MOD 3;
                        occOven{i} := TRUE;
                        !hack: avoid 0s
                        IF iOven = 0 iOven := 1;
                        IF jOven = 0 jOven := 3;
                        !Break; there's no break :(
                    ENDIF
                ENDFOR
                
                !perform the task
                TPWrite "a = ", \Num:=iOven;
                TPWrite "a = ", \Num:=jOven;
                conv2oven pConv, pOven, 1, iOven, jOven;
                !generate a new task
                newTask := [3, currTime+time{queue{1,1}}, 3*(iOven-1)+jOven];
                
            CASE 2:
                !check the 1st empty position on the oven
                FOR i FROM 1 TO 9 DO
                    IF (NOT occOven{i}) AND (NOT found) THEN
                        found := TRUE;
                        
                        iOven := i DIV 3;
                        jOven := i MOD 3;
                        occOven{i} := TRUE;
                        !hack: avoid 0s
                        IF iOven = 0 iOven := 1;
                        IF jOven = 0 jOven := 3;
                        !Break; there's no break :(
                    ENDIF
                ENDFOR
                
                !perform the task
                conv2oven pConv, pOven, 1, iOven, jOven;
                !generate a new task
                newTask := [3, currTime+time{queue{1,1}}, 3*(iOven-1)+jOven];
                
            CASE 3:
                !get the oven position
                iOven := queue{1,3} DIV 3;
                jOven := queue{1,3} MOD 3;
                !hack: avoid 0s
                IF iOven = 0 iOven := 1;
                IF jOven = 0 jOven := 3;
                
                occOven{queue{1,3}} := FALSE;
                
                !perform the task
                oven2man pOven, pMan, iOven, jOven;
                !generate a new task
                newTask := [4, currTime+time{queue{1,1}}, 0];
                
            CASE 4:
                !perform the task
                man2conv pMan, pConv, 2;
                !generate a new task
                newTask := [0, 0, 0];
                
            CASE 0:
                !go to home
                MoveJ pHome, v1000, fine, tool0;
                RETURN;
    
            DEFAULT:
                !do nothing
        ENDTEST
        
        !update the queue list comparing the completion times
		FOR i FROM 2 TO Dim(queue, 1) DO
			IF (newTask{1} = 0 OR queue{i,2} < newTask{2}) AND queue{i,1} <> 0 THEN
				queue{i-1,1} := queue{i,1}; 
				queue{i-1,2} := queue{i,2}; 
				queue{i-1,3} := queue{i,3}; 
			ELSE
				!newTask completes before the queued task
				queue{i-1,1} := newTask{1}; 
				queue{i-1,2} := newTask{2}; 
				queue{i-1,3} := newTask{3};
				RETURN;!Break; There's no break :(
			ENDIF
		ENDFOR
		
        
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