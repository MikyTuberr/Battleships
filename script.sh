#!/bin/bash 

COUNTER=0
EMPTY_FIELD="O"
SELECT_SHIP="X"
SHIP="S"
COORDINATES_X=0
COORDINATES_Y=0
PREVIOUS_X=0
PREVIOUS_Y=0
TMP=0
SHIP_SIZE=0
SHIP_SIZE_COPY=0
CONTROLER=0
NUMBER_OF_SHIPS_4=0
NUMBER_OF_SHIPS_3=0
NUMBER_OF_SHIPS_2=0
NUMBER_OF_SHIPS_1=0

declare -A BOARD

initializeBoard() {
        for((i=0; i<10; i++))
        do
                for((j=0; j<10; j++))
                do
                        BOARD[$i,$j]=${EMPTY_FIELD}
                done
        done
        BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
}

printBoard() {
        echo "| CUROSR MOVEMENT -> W A S D | PLACE SHIP -> F | QUIT E | "
        echo -e "\033[0;36m    A   B   C   D   E   F   G   H   I   J \033[0m"  # cyan header row
        for((i=0; i<10; i++))
        do      
                echo -n -e "\033[0;33m$COUNTER   \033[0m"  # yellow row number
                for((j=0; j<10; j++))
                do
                        if [[ ${BOARD[$i,$j]} == ${EMPTY_FIELD} ]]; 
                        then
                                echo -ne "\033[0;0m${BOARD[$i,$j]}   \033[0m" # default white

                        elif [[ ${BOARD[$i,$j]} == ${SELECT_SHIP} ]]; 
                        then
                                echo -ne "\033[0;31m${BOARD[$i,$j]}\033[0m   " # red
                        else
                                echo -ne "\033[0;32m${BOARD[$i,$j]}   \033[0m" # green

                        fi
                done
                echo
                COUNTER=$(($COUNTER+1))
        done
        COUNTER=0
}

cursor() {
        clear
        BOARD[$PREVIOUS_Y,$PREVIOUS_X]=${EMPTY_FIELD}
        BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        printBoard
}

findPositionOfCursor() {
        #BOARD[$COORDINATES_Y,$COORDINATES_X]=${SHIP}   #finding empty field for cursor
        if [[ ${COORDINATES_Y} -gt 0 && ${BOARD[$(($COORDINATES_Y-1)),$COORDINATES_X]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_Y=$(($COORDINATES_Y-1))                                                                                     
                
        elif [[ ${COORDINATES_Y} -lt 9 && ${BOARD[$(($COORDINATES_Y+1)),$COORDINATES_X]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_Y=$(($COORDINATES_Y+1))

        elif [[ ${COORDINATES_X} -lt 9 && ${BOARD[$COORDINATES_Y,$(($COORDINATES_X+1))]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_X=$(($COORDINATES_X+1))

        elif [[ ${COORDINATES_X} -gt 0 && ${BOARD[$COORDINATES_Y,$(($COORDINATES_X-1))]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_X=$(($COORDINATES_X-1))
        fi
        
        BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        clear
        printBoard     
}

placeShips() {
        read -rsn2 -t 0.1 # consume any remaining input

        echo "| CHOOSE SIZE OF SHIP -> 1, 2, 3 or 4 | "
        while true 
        do
                read -rsn1 key2 #choosing the size of ship to place
                case "$key2" in
                                $'4')
                                        if [[ ${NUMBER_OF_SHIPS_4} -ne 1 ]];
                                        then 
                                                SHIP_SIZE=4
                                                SHIP="4"
                                                NUMBER_OF_SHIPS_4=1
                                                break;
                                        else 
                                                echo "U CAN PLACE ONLY 1 SHIP OF THIS KIND"
                                        fi
                                ;;

                                $'3') 
                                        if [[ ${NUMBER_OF_SHIPS_3} -ne 2 ]];
                                        then 
                                                SHIP_SIZE=3
                                                SHIP="3"
                                                NUMBER_OF_SHIPS_3=$(($NUMBER_OF_SHIPS_3+1))
                                                break;
                                        else 
                                                echo "U CAN PLACE ONLY 2 SHIPS OF THIS KIND"
                                        fi
                                ;;

                                $'2') 
                                        if [[ ${NUMBER_OF_SHIPS_2} -ne 3 ]];
                                        then 
                                                SHIP_SIZE=2
                                                SHIP="2"
                                                NUMBER_OF_SHIPS_2=$(($NUMBER_OF_SHIPS_2+1))
                                                break;
                                        else 
                                                echo "U CAN PLACE ONLY 3 SHIPS OF THIS KIND"
                                        fi
                                ;;

                                $'1') 
                                        if [[ ${NUMBER_OF_SHIPS_1} -ne 4 ]];
                                        then 
                                                SHIP_SIZE=1
                                                SHIP="1"
                                                NUMBER_OF_SHIPS_1=$(($NUMBER_OF_SHIPS_1+1))
                                                break;
                                        else 
                                                echo "U CAN PLACE ONLY 4 SHIPS OF THIS KIND"
                                        fi
                                ;;

                                *) 
                                        echo "INVALID KEY"
                                ;;
                esac
        done    

        read -rsn2 -t 0.1 # consume any remaining input
        
        CONTROLER=0
        while true
        do
                        echo "| CHOOSE DIRECTION OF SHIP -> W A S D | "
                        read -rsn1 DIRECTION 
                                case "$DIRECTION" in                    #choosing the direction, to print rest of ship
                                        $'w')   
                                                if [[ $(($COORDINATES_Y-$SHIP_SIZE+1)) -gt -1 ]];
                                                then
                                                        SHIP_SIZE_COPY=$SHIP_SIZE
                                                        TMP_COORDINATES_Y=$COORDINATES_Y
                                                        TMP_COORDINATES_X=$COORDINATES_X
                                                        while [[ $SHIP_SIZE_COPY -ne 0 ]]
                                                        do
                                                                TMP_COORDINATES_Y=$(($TMP_COORDINATES_Y-1))
                                                                SHIP_SIZE_COPY=$(($SHIP_SIZE_COPY-1))
                                                                if [[ ${BOARD[$TMP_COORDINATES_Y,$TMP_COORDINATES_X]} != ${EMPTY_FIELD} ]];
                                                                then
                                                                        echo "CANNOT OVERLAP"
                                                                        CONTROLER=1
                                                                fi
                                                                
                                                        done

                                                        TMP_COORDINATES_Y=$COORDINATES_Y
                                                        TMP_COORDINATES_X=$COORDINATES_X

                                                        if [[ $CONTROLER -eq 0 ]];
                                                        then
                                                                while [[ $SHIP_SIZE -ne 0 ]] 
                                                                do
                                                                        BOARD[$TMP_COORDINATES_Y,$TMP_COORDINATES_X]=${SHIP}
                                                                        TMP_COORDINATES_Y=$(($TMP_COORDINATES_Y-1))
                                                                        SHIP_SIZE=$(($SHIP_SIZE-1))
                        
                                                                done
                                                                CONTROLER=2
                                                        fi

                                                        if [[ $CONTROLER -eq 2 ]]; 
                                                        then
                                                                CONTROLER=0
                                                                break 3
                                                        fi
                                                        CONTROLER=0
                                                else 
                                                        echo "CANNOT PLACE SHIP OUT OF THE BOARD"
                                                fi
                                        ;;
                                        $'a')
                                                if [[ $(($COORDINATES_X-$SHIP_SIZE+1)) -gt -1 ]];
                                                then
                                                        SHIP_SIZE_COPY=$SHIP_SIZE
                                                        TMP_COORDINATES_Y=$COORDINATES_Y
                                                        TMP_COORDINATES_X=$COORDINATES_X
                                                        while [[ $SHIP_SIZE_COPY -ne 0 ]]
                                                        do
                                                                TMP_COORDINATES_X=$(($TMP_COORDINATES_X-1))
                                                                SHIP_SIZE_COPY=$(($SHIP_SIZE_COPY-1))
                                                                if [[ ${BOARD[$TMP_COORDINATES_Y,$TMP_COORDINATES_X]} != ${EMPTY_FIELD} ]];
                                                                then
                                                                        echo "CANNOT OVERLAP"
                                                                        CONTROLER=1
                                                                fi
                                                                
                                                        done

                                                        TMP_COORDINATES_Y=$COORDINATES_Y
                                                        TMP_COORDINATES_X=$COORDINATES_X

                                                        if [[ $CONTROLER -eq 0 ]];
                                                        then
                                                                while [[ $SHIP_SIZE -ne 0 ]] 
                                                                do
                                                                        BOARD[$TMP_COORDINATES_Y,$TMP_COORDINATES_X]=${SHIP}
                                                                        TMP_COORDINATES_X=$(($TMP_COORDINATES_X-1))
                                                                        SHIP_SIZE=$(($SHIP_SIZE-1))
                                                                done
                                                                CONTROLER=2
                                                        fi
                                                        
                                                        if [[ $CONTROLER -eq 2 ]]; 
                                                        then
                                                                CONTROLER=0
                                                                break 3
                                                        fi
                                                        CONTROLER=0
                                                else 
                                                        echo "CANNOT PLACE SHIP OUT OF THE BOARD"
                                                fi
                                        ;;
                                        $'s')
                                                if [[ $(($COORDINATES_Y+$SHIP_SIZE-1)) -lt 10 ]];
                                                then
                                                        SHIP_SIZE_COPY=$SHIP_SIZE
                                                        TMP_COORDINATES_Y=$COORDINATES_Y
                                                        TMP_COORDINATES_X=$COORDINATES_X
                                                        while [[ $SHIP_SIZE_COPY -ne 0 ]]
                                                        do
                                                                TMP_COORDINATES_Y=$(($TMP_COORDINATES_Y+1))
                                                                SHIP_SIZE_COPY=$(($SHIP_SIZE_COPY-1))
                                                                if [[ ${BOARD[$TMP_COORDINATES_Y,$TMP_COORDINATES_X]} != ${EMPTY_FIELD} ]];
                                                                then
                                                                        echo "CANNOT OVERLAP"
                                                                        CONTROLER=1
                                                                fi
                                        
                                                        done

                                                        TMP_COORDINATES_Y=$COORDINATES_Y
                                                        TMP_COORDINATES_X=$COORDINATES_X

                                                        if [[ $CONTROLER -eq 0 ]];
                                                        then
                                                                while [[ $SHIP_SIZE -ne 0 ]] 
                                                                do
                                                                        BOARD[$TMP_COORDINATES_Y,$TMP_COORDINATES_X]=${SHIP}
                                                                        TMP_COORDINATES_Y=$(($TMP_COORDINATES_Y+1))
                                                                        SHIP_SIZE=$(($SHIP_SIZE-1))
                                                                done
                                                                CONTROLER=2
                                                        fi

                                                        if [[ $CONTROLER -eq 2 ]]; 
                                                        then
                                                                CONTROLER=0
                                                                break 3
                                                        fi
                                                        CONTROLER=0
                                                else 
                                                        echo "CANNOT PLACE SHIP OUT OF THE BOARD"
                                                fi
                                        ;;
                                        $'d')
                                                if [[ $(($COORDINATES_X+$SHIP_SIZE-1)) -lt 10 ]];
                                                then
                                                        SHIP_SIZE_COPY=$SHIP_SIZE
                                                        TMP_COORDINATES_Y=$COORDINATES_Y
                                                        TMP_COORDINATES_X=$COORDINATES_X
                                                        while [[ $SHIP_SIZE_COPY -ne 0 ]]
                                                        do
                                                                TMP_COORDINATES_X=$(($TMP_COORDINATES_X+1))
                                                                SHIP_SIZE_COPY=$(($SHIP_SIZE_COPY-1))
                                                                if [[ ${BOARD[$TMP_COORDINATES_Y,$TMP_COORDINATES_X]} != ${EMPTY_FIELD} ]];
                                                                then
                                                                        echo "CANNOT OVERLAP"
                                                                        CONTROLER=1
                                                                fi
                                                                
                                                        done

                                                        TMP_COORDINATES_Y=$COORDINATES_Y
                                                        TMP_COORDINATES_X=$COORDINATES_X
                                                        
                                                        if [[ $CONTROLER -eq 0 ]];
                                                        then
                                                                while [[ $SHIP_SIZE -ne 0 ]] 
                                                                do
                                                                        BOARD[$TMP_COORDINATES_Y,$TMP_COORDINATES_X]=${SHIP}
                                                                        TMP_COORDINATES_X=$(($TMP_COORDINATES_X+1))
                                                                        SHIP_SIZE=$(($SHIP_SIZE-1))
                                                                done
                                                                CONTROLER=2
                                                        fi

                                                        if [[ $CONTROLER -eq 2 ]]; 
                                                        then
                                                                CONTROLER=0
                                                                break 3
                                                        fi

                                                        CONTROLER=0
                                                else 
                                                        echo "CANNOT PLACE SHIP OUT OF THE BOARD"
                                                fi
                                        ;;
                                        *)
                                                echo "INVALID KEY"
                                        ;;
                                esac
        done
        
        findPositionOfCursor
        clear 
        printBoard
}

readKeys() {
        while (( NUMBER_OF_SHIPS_1 + NUMBER_OF_SHIPS_2 + NUMBER_OF_SHIPS_3 + NUMBER_OF_SHIPS_4 != 10 ))   # Read a single key from user input
        do
                PREVIOUS_X=${COORDINATES_X}
                PREVIOUS_Y=${COORDINATES_Y}
                read -rsn1 key 
                case "$key" in
                        $'f')
                                placeShips
                                continue
                        ;;

                        $'w') 
                                TMP=$((COORDINATES_Y-1))
                                if [[ ${COORDINATES_Y} -gt 0 && ${BOARD[$TMP,$COORDINATES_X]} == ${EMPTY_FIELD} ]];
                                then
                                        COORDINATES_Y=$(($COORDINATES_Y-1)) 
                                        cursor
                                fi
                                continue
                        ;;

                        $'s') 
                                TMP=$((COORDINATES_Y+1))
                                if [[ ${COORDINATES_Y} -lt 9 && ${BOARD[$TMP,$COORDINATES_X]} == ${EMPTY_FIELD} ]];
                                then
                                        COORDINATES_Y=$(($COORDINATES_Y+1))
                                        cursor
                                fi
                                continue
                        ;;

                        $'d') 
                                TMP=$((COORDINATES_X+1))
                                if [[ ${COORDINATES_X} -lt 9 && ${BOARD[$COORDINATES_Y,$TMP]} == ${EMPTY_FIELD} ]];
                                then
                                        COORDINATES_X=$(($COORDINATES_X+1))
                                        cursor
                                fi
                                continue
                        ;;

                        $'a') 
                                TMP=$((COORDINATES_X-1))
                                if [[ ${COORDINATES_X} -gt 0 && ${BOARD[$COORDINATES_Y,$TMP]} == ${EMPTY_FIELD} ]];
                                then
                                        COORDINATES_X=$(($COORDINATES_X-1))
                                        cursor
                                fi
                                continue
                        ;;

                        $'e') 
                                break
                        ;;

                        *) 
                                echo "INVALID KEY"
                        ;;
                esac
        done
}

clear

initializeBoard

printBoard

readKeys