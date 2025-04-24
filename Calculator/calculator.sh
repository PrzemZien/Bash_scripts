#!/bin/bash

if [ $# -lt 3 ]; then # liczba argument < 3
    echo "Powinines wpisac: $0 liczba operator liczba [operator liczba ...]"
    exit 1
fi

prev="" # zmienna przechowujaca pioprzedni argument
expr_input=() # tablica w ktorej beda znajdywaly sie kolejne argumenty
for arg in "$@"; do
        if [[ "$arg" == "+" || "$arg" == "-" || "$arg" == "*" || "$arg" == "/" ]]; then
            if [[ "$prev" == "+" || "$prev" == "-" || "$prev" == "*" ]]; then
                echo "Nie moze byc operatora po operatorze"
	        exit 2
            fi
            echo "Argument 2: $arg"
	elif [[ "$arg" =~ ^-?[0-9]+$ ]]; then
            if [[ "$prev" =~ ^-?[0-9]+$ ]]; then
                echo "Blad: liczba po liczbie"
                exit 2
            fi
            if [[ "$prev" == "/" ]] && [[ "$arg" == "0" ]]; then
                echo "Nie mozna dzielic przez 0"
                exit 2
            fi
            echo "Argument 2: $arg"
       	elif [[ "$prev" == ")" || "$prev" == "(" ]] && [[ "$arg" == "(" || "$arg" == ")" ]]; then
	    	echo "Blad: nawias po nawiasie"
	    	exit 2
        elif [[ "$arg" =~ ^[0-9]+\.[0-9]+$ ]]; then
        	echo "Liczby musza byc calkowite"
        	exit 2	    	
	elif [[ "$arg" == "(" || "$arg" == ")" ]]; then
            	echo "Argument 2: $arg"
       	else
            echo "Błąd nienznany obiekt"
            exit 2
        fi


    expr_input+=("$arg")
    prev="$arg"
done

wynik=$(expr "${expr_input[@]}" 2>/dev/null) # kazdy argument jest obliczany oddzielnie przez expr, czyli kazdy element jest wypisywany jako odzielny argument 
if [ $? -eq 2 ]; then # sprawdzam czy blad wyjscia jest rozny od 0, 0 to sukces
    echo "Błąd w obliczeniach - sprawdź składnię"
    exit 3
fi

echo "Wynik: $wynik"
