#!/bin/bash 
# Autor: Piotr Lachowicz, may 2023

COUNTER=0
EMPTY_FIELD="O"
SELECT_SHIP="X"
BAD_SHOOT="M"
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
PREVIOUS_SYMBOL="O"
SINK_COUNTER_PLAYER=0
SINK_COUNTER_AI=0

declare -A BOARD

declare -A AI_BOARD

declare -A SHOOTING_BOARD

declare -A AI_SHOOTING_BOARD

#intialize ai board
function initializeAiBoard() {
        for (( i=0; i<10; i++ )); do
                for (( j=0; j<10; j++ )); do
                        AI_BOARD[$i,$j]=${EMPTY_FIELD}
                done
        done
}

#intialize players board
function initializeBoard() {
        for((i=0; i<10; i++))
        do
                for((j=0; j<10; j++))
                do
                        BOARD[$i,$j]=${EMPTY_FIELD}
                done
        done
        BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
}

#intialize shooting board
function initializeShootingBoard() {
        for((i=0; i<10; i++))
        do
                for((j=0; j<10; j++))
                do
                        SHOOTING_BOARD[$i,$j]=${EMPTY_FIELD}
                done
        done
        SHOOTING_BOARD[0,0]=${SELECT_SHIP}
}

#simply print the board made by player
function printBoard() {
        echo "| CUROSR MOVEMENT -> W A S D | PLACE SHIP -> F | QUIT E | "
        echo -e "\033[0;36m    A   B   C   D   E   F   G   H   I   J \033[0m"  # cyan header ROW
        for((i=0; i<10; i++))
        do      
                echo -n -e "\033[0;33m$COUNTER   \033[0m"  # yellow ROW number
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

#simply print shooting board
function printShootingBoard() {
        echo "| CUROSR MOVEMENT -> W A S D | SHOOT SHIP -> F | QUIT E | "
        echo -e "\033[0;36m    A   B   C   D   E   F   G   H   I   J \033[0m"  # cyan header ROW
        for((i=0; i<10; i++))
        do      
                echo -n -e "\033[0;33m$COUNTER   \033[0m"  # yellow ROW number
                for((j=0; j<10; j++))
                do
                        if [[ ${SHOOTING_BOARD[$i,$j]} == ${EMPTY_FIELD} ]]; 
                        then
                                echo -ne "\033[0;0m${SHOOTING_BOARD[$i,$j]}   \033[0m" # default white

                        elif [[ ${SHOOTING_BOARD[$i,$j]} == ${SELECT_SHIP} ]]; 
                        then
                                echo -ne "\033[0;31m${SHOOTING_BOARD[$i,$j]}\033[0m   " # red

                        elif [[ ${SHOOTING_BOARD[$i,$j]} == ${BAD_SHOOT} ]];
                        then
                                echo -ne "\033[0;35m${SHOOTING_BOARD[$i,$j]}   \033[0m" # magneta

                        else 
                                echo -ne "\033[0;32m${SHOOTING_BOARD[$i,$j]}   \033[0m" # green

                        
                        fi
                done
                echo
                COUNTER=$(($COUNTER+1))
        done
        COUNTER=0
}

#cursor movement
function cursor() {
        clear
        BOARD[$PREVIOUS_Y,$PREVIOUS_X]=${PREVIOUS_SYMBOL}
        PREVIOUS_SYMBOL=${BOARD[$COORDINATES_Y,$COORDINATES_X]}
        BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        printBoard
}

#find the position of cursor after action 
function findPositionOfCursor() {
     
        if [[ ${COORDINATES_Y} -gt 0 && ${BOARD[$(($COORDINATES_Y-1)),$COORDINATES_X]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_Y=$(($COORDINATES_Y-1))                                                                                     
                
        elif [[ ${COORDINATES_Y} -lt 9 && ${BOARD[$(($COORDINATES_Y+1)),$COORDINATES_X]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_Y=$(($COORDINATES_Y+1))

        elif [[ ${COORDINATES_X} -lt 9 && ${BOARD[$COORDINATES_Y,$(($COORDINATES_X+1))]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_X=$(($COORDINATES_X+1))

        elif [[ ${COORDINATES_X} -gt 0 && ${BOARD[$COORDINATES_Y,$(($COORDINATES_X-1))]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_X=$(($COORDINATES_X-1))
        else 
                while true
                do
                        for((i=0; i<10; i++))
                        do      
                                for((j=0; j<10; j++))
                                do
                                        if [[ ${BOARD[$i,$j]} == ${EMPTY_FIELD} ]];
                                        then
                                                COORDINATES_X=$j
                                                COORDINATES_Y=$i
                                        fi
                                done
                        done
                done

        fi
        
        BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        clear
        printBoard     
}

#place the ships
function placeShips() {
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

                                
                                $'e') 
                                        break
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

                                        $'e') 
                                                break
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

#read keys from keyboard and do the actions
function readKeysToPlaceShips() {
        while (( NUMBER_OF_SHIPS_1 + NUMBER_OF_SHIPS_2 + NUMBER_OF_SHIPS_3 + NUMBER_OF_SHIPS_4 != 10 ))   # Read a single key from user input
        do
                read -rsn1 key 
                case "$key" in
                        $'f')
                                if [[ ${PREVIOUS_SYMBOL} == ${EMPTY_FIELD} ]];
                                then
                                        placeShips
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
                                        continue
                                fi
                        ;;

                        $'w') 
                                if [[ ${COORDINATES_Y} -gt 0 ]];
                                then
                                        COORDINATES_Y=$(($COORDINATES_Y-1)) 
                                        cursor
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
                                fi
                                continue
                        ;;

                        $'s') 
                                if [[ ${COORDINATES_Y} -lt 9 ]];
                                then
                                        COORDINATES_Y=$(($COORDINATES_Y+1))
                                        cursor
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
                                fi
                                continue
                        ;;

                        $'d') 
                                if [[ ${COORDINATES_X} -lt 9 ]];
                                then
                                        COORDINATES_X=$(($COORDINATES_X+1))
                                        cursor
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
                                fi
                                continue
                        ;;

                        $'a') 
                               if [[ ${COORDINATES_X} -gt 0 ]];
                                then
                                        COORDINATES_X=$(($COORDINATES_X-1))
                                        cursor
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
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

#generate random coordinates
function generateCoordinates() {
        ROW=$((RANDOM % 10))
        COL=$((RANDOM % 10))
        echo "$ROW $COL"
}

#check if a ship can be placed at a given coordinate (AI function)
function canPlaceShip() {
        local ROW=$1    #initialize passed variables
        local COL=$2 
        local LENGTH=$3    
        local DIRECTION=$4

        if [ " DIRECTION" == "horizontal" ]; 
        then
                end_COL=$((COL + LENGTH - 1))

                if [[ $end_COL -ge 10 ]]; 
                then
                        return 1
                fi

                for (( i=COL; i<=end_COL; i++ )); 
                do
                        if [[ ${AI_BOARD[$ROW,$i]} -ne 0 ]]; 
                        then
                                return 1
                        fi
                done

                else
                        end_ROW=$((ROW + LENGTH - 1))

                if [ $end_ROW -ge 10 ]; 
                then
                        return 1
                fi

                for (( i=ROW; i<=end_ROW; i++ )); 
                do
                        if [[ ${AI_BOARD[$i,$COL]} -ne 0 ]]; then
                                return 1
                        fi
                done
        fi

        return 0
}

#place a ship at a given coordinate (AI function)
function placeShip() {
        local ROW=$1    #initialize passed variables
        local COL=$2
        local LENGTH=$3
        local DIRECTION=$4

        if [ " DIRECTION" == "horizontal" ]; 
        then
                end_COL=$((COL + LENGTH - 1))
                for (( i=COL; i<=end_COL; i++ )); 
                do
                        AI_BOARD[$ROW,$i]=$LENGTH
                done
        else
        end_ROW=$((ROW + LENGTH - 1))
                for (( i=ROW; i<=end_ROW; i++ )); 
                do
                        AI_BOARD[$i,$COL]=$LENGTH
                done
        fi
}

#place ships on AI board
function placeAiShips() {
        SHIPS=(4 3 3 2 2 2 1 1 1 1)
        for SHIP in ${SHIPS[@]}; #expand to all elements of SHIPS array
        do
                while true; 
                do
                        coords=$(generateCoordinates)
                        ROW=${coords%% *} #remove everything after the first space in coords, to extract the row coordinate
                        COL=${coords##* } #remove everything before the last space in the coords, to extract that column coordinate
                        DIRECTION=$((RANDOM % 2))
                        if [[  DIRECTION -eq 0 ]]; 
                        then
                                DIRECTION="horizontal"

                        else
                                DIRECTION="vertical"
                        fi

                        if canPlaceShip $ROW $COL $SHIP  DIRECTION; 
                        then
                                placeShip $ROW $COL $SHIP  DIRECTION
                                break
                        fi
                done
        done
}

#shooting of player cursor movement
function shootingCursor() {
        clear
        SHOOTING_BOARD[$PREVIOUS_Y,$PREVIOUS_X]=${PREVIOUS_SYMBOL}
        PREVIOUS_SYMBOL=${SHOOTING_BOARD[$COORDINATES_Y,$COORDINATES_X]}
        SHOOTING_BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        printShootingBoard
}

#find cursor after shoot
function findPositionOfShootingCursor() {
        if [[ ${COORDINATES_Y} -gt 0 && ${SHOOTING_BOARD[$(($COORDINATES_Y-1)),$COORDINATES_X]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_Y=$(($COORDINATES_Y-1))                                                                                     
                
        elif [[ ${COORDINATES_Y} -lt 9 && ${SHOOTING_BOARD[$(($COORDINATES_Y+1)),$COORDINATES_X]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_Y=$(($COORDINATES_Y+1))

        elif [[ ${COORDINATES_X} -lt 9 && ${SHOOTING_BOARD[$COORDINATES_Y,$(($COORDINATES_X+1))]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_X=$(($COORDINATES_X+1))

        elif [[ ${COORDINATES_X} -gt 0 && ${SHOOTING_BOARD[$COORDINATES_Y,$(($COORDINATES_X-1))]} == ${EMPTY_FIELD} ]]; then
                COORDINATES_X=$(($COORDINATES_X-1))
        else 
                while true
                do
                        for((i=0; i<10; i++))
                        do      
                                for((j=0; j<10; j++))
                                do
                                        if [[ ${SHOOTING_BOARD[$i,$j]} == ${EMPTY_FIELD} ]];
                                        then
                                                COORDINATES_X=$j
                                                COORDINATES_Y=$i
                                                break 4;
                                        fi
                                done
                        done
                done

        fi
        
        SHOOTING_BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        clear
        printShootingBoard 
}

#shooting
function shoot() {
        if [[ ${AI_BOARD[$COORDINATES_Y,$COORDINATES_X]} != ${EMPTY_FIELD} ]];
        then 
                SHOOTING_BOARD[$COORDINATES_Y,$COORDINATES_X]=${AI_BOARD[$COORDINATES_Y,$COORDINATES_X]} 
                SINK_COUNTER_PLAYER=$(($SINK_COUNTER_PLAYER+1))
                
        else
                SHOOTING_BOARD[$COORDINATES_Y,$COORDINATES_X]=${BAD_SHOOT}
                echo "bad shoot"
        fi
        clear
        findPositionOfShootingCursor
}

function aiShoot() {
        local ROW
        local COL

        while true; 
        do
                ROW=$((RANDOM % 10))
                COL=$((RANDOM % 10))
                if [[ ${BOARD[$ROW,$COL]} != ${SELECT_SHIP} && ${BOARD[$ROW,$COL]} != ${BAD_SHOOT} ]]; 
                then
                        if [[ ${BOARD[$ROW,$COL]} != ${EMPTY_FIELD} ]]; 
                        then
                                BOARD[$ROW,$COL]=${SELECT_SHIP}
                                SINK_COUNTER_AI=$(($SINK_COUNTER_AI+1))
                                echo "The computer hit your ship at row $ROW, column $COL!"
                                break
                        elif [[ ${BOARD[$ROW,$COL]} == ${EMPTY_FIELD} ]]; 
                        then
                                BOARD[$ROW,$COL]=${BAD_SHOOT}
                                echo "The computer missed at row $ROW, column $COL."
                                break
                        fi
                fi
        done
}

#tour of shooting
function readKeysToShootShips() {
        COORDINATES_X=0
        COORDINATES_Y=0
        PREVIOUS_X=0
        PREVIOUS_Y=0
        PREVIOUS_SYMBOL="O"
        while [[ ${SINK_COUNTER_PLAYER} != 20 && ${SINK_COUNTER_AI} != 20 ]]
        do
                read -rsn1 key 
                case "$key" in
                        $'f')
                                if [[ ${PREVIOUS_SYMBOL} == ${EMPTY_FIELD} ]];
                                then
                                        shoot
                                        aiShoot
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
                                        continue
                                fi
                        ;;

                        $'w') 
                                if [[ ${COORDINATES_Y} -gt 0 ]];
                                then
                                        COORDINATES_Y=$(($COORDINATES_Y-1)) 
                                        shootingCursor
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
                                fi
                                continue
                        ;;

                        $'s') 
                                if [[ ${COORDINATES_Y} -lt 9 ]];
                                then
                                        COORDINATES_Y=$(($COORDINATES_Y+1))
                                        shootingCursor
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
                                fi
                                continue
                        ;;

                        $'d') 
                                if [[ ${COORDINATES_X} -lt 9 ]];
                                then
                                        COORDINATES_X=$(($COORDINATES_X+1))
                                        shootingCursor
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
                                fi
                                continue
                        ;;

                        $'a') 
                                if [[ ${COORDINATES_X} -gt 0 ]];
                                then
                                        COORDINATES_X=$(($COORDINATES_X-1))
                                        shootingCursor
                                        PREVIOUS_X=${COORDINATES_X}
                                        PREVIOUS_Y=${COORDINATES_Y}
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

while getopts "hap" option; do
        case "${option}" in
                a):
                        echo "AUTHOR: PIOTR LACHOWICZ, 193630, INFROMATYKA, GR. 7"
                ;;
                h):
                        echo "Battleships game"
                        echo "To win you need to elimnate all opponents ships."
                        echo "Instructions of how to play, are given during the game."
                        echo "If you want to start the game, use -p option, if you want to see information about the author use -a option"
                        exit 0
                ;;
                p):
                        clear

                        initializeBoard

                        printBoard

                        readKeysToPlaceShips

                        initializeAiBoard

                        placeAiShips

                        initializeShootingBoard

                        printShootingBoard

                        readKeysToShootShips

                        echo "END OF GAME"
                ;;
                *)
                        echo "Invalid option: -$OPTARG" >&2
                        exit 1
                ;;
        esac
done


