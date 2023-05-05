#!/bin/bash 

COUNTER=0
SYMBOL=X

printBoard() {
        echo "  A B C D E F G H I J"
        while [[ $COUNTER -le 9 ]]
        do
                echo "$COUNTER O O O O O O O O O O"
                COUNTER=$(($COUNTER+1))
        done
}      

placeShips() {
        echo "cos"              
}

printBoard

read -rsn1 key  # Read a single key from user input
case "$key" in
  # Check if the key is an arrow key
        $'\x1b[A') echo "Up arrow pressed";;
        $'\x1b[B') echo "Down arrow pressed";;
        $'\x1b[C') echo "Right arrow pressed";;
        $'\x1b[D') echo "Left arrow pressed";;
        *) echo "Invalid input";;
esac