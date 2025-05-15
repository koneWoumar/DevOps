#!/bin/bash

# Programmation Bash


#echo "$(( "$1" + "$2" ))"


# ptr1=252
# ptr2=5
# ptr=5

# read -p "enter i : " data

# let i=$data

# while (( i < 1000 ))
# do
# echo "$i"
# i=$(( $i + 5 ))
# if test $i -eq 20 ; then
#     exit 0 ;
# fi
# done


# t=("je" "suis" "oumar" 25)
# t[0]="25"
# echo "${t[1]}"
# echo "${t[@]}"

# for i in {0..20}
# do
# t[$i]=$(( $i+5 ))
# done
# echo ${t[@]}


# apparteance à un ensemble
# if [[ " ${t[@]} " =~ " 25 " ]]; then
#     echo "yes"
# else
#     echo "non"
# fi
# chaine="jje suis kone et je suis"
# echo ${chaine// /}

# str="fichier.tar.gz"
# echo ${str#.*}    # → tar.gz (supprime le plus court préfixe avant le 1er .)
# echo ${str##.*}   # → gz (supprime le plus long préfixe jusqu’au dernier .)

# declare -a tab=(25 3 5 4)

# echo ${tab[@]}

# chaine='je suis'
# if [ "je" == ${chaine} ] ; then
#     echo "yes"
# fi

# let i=10
# while (( 1 )) ; do
#     if [ $i -gt 0 ] ; then
#         echo "${i}ème terme"
#         let i-=1
#     fi
#     break
# done

# for i in '1 2 3 4 5' ; do
#   echo "i = $i"
# done

# liste="janvier février mars"
# for mois in $liste; do
#   echo "Mois : $mois"
# done

fonction(){
    echo "num of arg :$#"
    echo "tab of args : $@"
    echo "concate of args : $*"
    echo "PID of this process : $$"
    echo "command started this process : $0"
    echo "arg1 : $1"
    if [ -z "$3" ] ; then
        echo "the first arg existe"
    fi
}

fonction $1 $2

# color 
# coulor
# culer
# hahaha 
# ha-ok-ha-yes-ha
# ha ha ha
# hacarhajesuishafor