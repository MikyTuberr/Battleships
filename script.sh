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
        echo -e "\033[0;36m    A   B   C   D   E   F   G   H   I   J \033[0m"  # cyan header row
        for((i=0; i<10; i++))
        do      
                echo -n -e "\033[0;33m$COUNTER   \033[0m"  # yellow row number
                for((j=0; j<10; j++))
                do
                        if [[ ${BOARD[$i,$j]} == ${EMPTY_FIELD} ]]; 
                        then
                                echo -ne "\033[0;0m${BOARD[$i,$j]}   \033[0m" # default white

                        elif [[ ${BOARD[$i,$j]} == ${SHIP} ]] 
                        then 
                                echo -ne "\033[0;32m${BOARD[$i,$j]}   \033[0m" # green

                        elif [[ ${BOARD[$i,$j]} == ${SELECT_SHIP} ]]; 
                        then
                                echo -ne "\033[0;31m${BOARD[$i,$j]}\033[0m   " # red
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

placeShips() {
        BOARD[$COORDINATES_Y,$COORDINATES_X]=${SHIP}
        TMP=$((COORDINATES_Y-1))
        if [[ ${COORDINATES_Y} -gt 0 && ${BOARD[$TMP,$COORDINATES_X]} != ${SHIP} ]]    
        then
                COORDINATES_Y=$(($COORDINATES_Y-1))
                BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        

        TMP=$((COORDINATES_Y+1))

        elif [[ ${COORDINATES_Y} -lt 9 && ${BOARD[$TMP,$COORDINATES_X]} != ${SHIP} ]]
        then
                COORDINATES_Y=$(($COORDINATES_Y+1))
                BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        

        TMP=$((COORDINATES_X+1))

        elif [[ ${COORDINATES_X} -lt 9 && ${BOARD[$COORDINATES_Y,$TMP]} != ${SHIP} ]]
        then
                COORDINATES_X=$(($COORDINATES_X+1))
                BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        

        TMP=$((COORDINATES_X-1))

        elif [[ ${COORDINATES_X} -gt 0 && ${BOARD[$COORDINATES_Y,$TMP]} != ${SHIP} ]]
        then
                COORDINATES_X=$(($COORDINATES_X-1))
                BOARD[$COORDINATES_Y,$COORDINATES_X]=${SELECT_SHIP}
        fi
        clear
        printBoard     
}

readKeys() {
        while true   # Read a single key from user input
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
                                if [[ ${COORDINATES_Y} -gt 0 && ${BOARD[$TMP,$COORDINATES_X]} != ${SHIP} ]];
                                then
                                        COORDINATES_Y=$(($COORDINATES_Y-1)) 
                                        cursor
                                fi
                                continue
                        ;;

                        $'s') 
                                TMP=$((COORDINATES_Y+1))
                                if [[ ${COORDINATES_Y} -lt 9 && ${BOARD[$TMP,$COORDINATES_X]} != ${SHIP} ]];
                                then
                                        COORDINATES_Y=$(($COORDINATES_Y+1))
                                        cursor
                                fi
                                continue
                        ;;

                        $'d') 
                                TMP=$((COORDINATES_X+1))
                                if [[ ${COORDINATES_X} -lt 9 && ${BOARD[$COORDINATES_Y,$TMP]} != ${SHIP} ]];
                                then
                                        COORDINATES_X=$(($COORDINATES_X+1))
                                        cursor
                                fi
                                continue
                        ;;

                        $'a') 
                                TMP=$((COORDINATES_X-1))
                                if [[ ${COORDINATES_X} -gt 0 && ${BOARD[$COORDINATES_Y,$TMP]} != ${SHIP} ]];
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