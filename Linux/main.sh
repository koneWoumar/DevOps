#!/bin/bash

# Programmation Bash


#echo "$(( "$1" + "$2" ))"


ptr1=252
ptr2=5
ptr=5

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

declare -A table=(["key1"]="value1" ["key2"]="val2" ["key3"]="5")
# for i in "${t[@]}"
# do
# echo "$i"
# done
echo ${table[@]}