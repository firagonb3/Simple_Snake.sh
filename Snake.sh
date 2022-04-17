#!bin/bash
x=15;y=10;movre=-;
tiempo=9000;puntos=0;cont=0;on=true
snake=*;snake2=@

function debug {
    clear
#    tput cup $y $x;echo -n "$snake"
    echo -n $caveza
    echo -n $mas
    tput cup 21
    tput setaf 7
    echo "Posicion y:" $y "Posicion x:" $x "Movimiento en:" $mov "Codigo de error" $?
    echo "Contador de ciclos:" $cont "Velocidad de tiempo:" $tiempo "Puntuacion:" $puntos
    echo "Cordenadas:" $cor
}

function tabledo {
    clear
    for (( z=0; z <= 30; z++ )); do
        echo -n "-"
    done
    echo ""
    for (( z=1; z <= 20; z++ )); do
        echo "|"
        tput cup "$z" 30;echo "|"
    done
    for (( z=0; z <= 30; z++ )); do
        echo -n "-"
    done
    echo -n $caveza
    echo -n $mas
    tput cup 21
    tput setaf 7
    tput cup 21 10;echo "Puntos:" $puntos
}

function gameover {
    tput cup 10 7;echo -n "!!! Perdiste !!!"
    tput cup 22
    exit
}

function comida {
    y2=$((($RANDOM%19)+1))
    x2=$((($RANDOM%29)+1))
    mas=$(tput cup $y2 $x2;tput setaf 3;echo "+")
}

function serpiente {
    cor="$y $x,$cor"
    cor=$(echo $cor | cut -d "," -f "1"-"$(($puntos+1))" )

    cuearpo="";color=0
    for (( z=2; z <= $puntos; z++ )); do
        color=$(($color+1))
        proc=$(echo $cor | cut -d "," -f $z)
        i=$(echo $proc | cut -d " " -f 1)
        j=$(echo $proc | cut -d " " -f 2)
        case $color in
            1)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 46;echo -n "$snake")
            ;;
            2)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 47;echo -n "$snake")
            ;;
            3)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 48;echo -n "$snake")
            ;;
            4)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 49;echo -n "$snake")
            ;;
            5)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 50;echo -n "$snake")
            ;;
            6)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 51;echo -n "$snake")
            ;;
            7)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 50;echo -n "$snake")
            ;;
            8)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 49;echo -n "$snake")
            ;;
            9)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 48;echo -n "$snake")
            ;;
            10)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 47;echo -n "$snake")
            ;;
            11)
                cuearpo=${cuearpo}$(tput cup $i $j;tput setaf 46;echo -n "$snake")
                color=0
            ;;
        esac
    done

    if [[ puntos -gt 0 ]]; then
    
        proc=$(echo $cor | cut -d "," -f $(($puntos + 1)) )
        i=$(echo $proc | cut -d " " -f 1)
        j=$(echo $proc | cut -d " " -f 2)
        
        proc=$(echo $cor | cut -d "," -f $puntos)
        i2=$(echo $proc | cut -d " " -f 1)
        j2=$(echo $proc | cut -d " " -f 2)

        if [[ $(($i+1)) -eq $i2 || $(($i-1)) -eq $i2 ]]; then
            cola2="|"
        elif [[ $(($j+1)) -eq $j2 || $(($j-1)) -eq $j2 ]]; then
            cola2="-"
        fi

        cola=$(tput cup $i $j;echo -n $cola2)
    fi
    
    if [[ $y -eq $y2 && $x -eq $x2 ]];then
        puntos=$(($puntos+1))
        if [[ $on == true ]]; then
            if [[ $(($puntos%2)) -eq 1 ]]; then
                if [[ $puntos -lt 30 ]]; then
                    tiempo=$(($tiempo-100))
                elif [[ $puntos -gt 30 ]]; then
                    tiempo=$(($tiempo-500))
                fi

                if [[ $tiempo -lt 0001 ]]; then
                    tiempo=0001
                    on=false
                fi
            fi
        fi
        comida
    fi

    caveza=$(tput cup $y $x;tput setaf 190;echo -n "$snake2")${cuearpo}${cola}
}

function mover {
    cont=$(($cont+1))
    if [[ $movre == "-" ]]; then
        read -n1 -s movselc
    else
        read -t0.0$tiempo -n1 -s movselc
    fi

    if [ ! -z $movselc ]; then
        mov=$movselc
    fi

    if [[ $mov == "q" || $mov == "Q" ]];then
        exit
    elif [[ $mov == "w" && $movre != "s" ]]; then
        y=$((y-1))
        movre=$mov
    elif [[ $mov == "s" && $movre != "w" ]]; then
        y=$((y+1))
        movre=$mov
    elif [[ $mov == "a" && $movre != "d" ]]; then
        x=$((x-1))
        movre=$mov
    elif [[ $mov == "d" && $movre != "a" ]]; then
        x=$((x+1))
        movre=$mov
    elif [[ $mov == "W" && $movre != "S" ]]; then
        y=$((y-1))
        movre=$mov
    elif [[ $mov == "S" && $movre != "W" ]]; then
        y=$((y+1))
        movre=$mov
    elif [[ $mov == "A" && $movre != "D" ]]; then
        x=$((x-1))
        movre=$mov
    elif [[ $mov == "D" && $movre != "A" ]]; then
        x=$((x+1))
        movre=$mov
    else
        mov=$movre
    fi

    if [[ $y -lt 1 ]]; then
        gameover
    elif [[ $y -gt 20 ]]; then
        gameover
    fi

    if [[ $x -lt 1 ]]; then
        gameover
    elif [[ $x -gt 29 ]]; then
        gameover
    fi

    echo $cor | egrep ",$y $x">/dev/null
    if [[ $? -eq 0 && $mov != "-" ]]; then
        gameover
    fi
    
}

caveza=$(tput cup $y $x;tput setaf 190;echo -n "$snake2")
comida
while true; do
#    debug
    tabledo
    mover
    serpiente
done