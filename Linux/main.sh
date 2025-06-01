#!/bin/bash

# Programmation Bash

# -------------------Exercices d'applications--------------------#

### -----Programme de surcharge de fichier .env-----#

#### Version avec sed
surchageConfigWithSed(){
    confile=$1
    overfile=$2
    # add an empty line if necessary
    [ "$(tail -c1 "$confile")" != "" ] && echo "" >> "$confile"
    # Read the overrider file line by line
    while read -r line
    do
        let nline=$(echo $line | grep -Ec "^#.*")
        if [ $nline -eq 0 ] ; then        
        # the line is not a commentary
            varname=$(echo $line | awk -F"=" '{print $1}')
            let nline=$(grep -Ec "^${varname}=.*" $confile)
            if [ $nline -gt 0 ] ; then
                # the  variable existe so replace it
                sed -i "s/^${varname}=.*/${line}/g" $confile
            else
                # the variable does not exist so add it
                echo "${line}" >> $confile
            fi
        fi
    done < "$overfile"
    cat $confile
}
#### Version avec tableau associatif
surchageConfigWithAssoTab(){
    # Associatif table to be use
    declare -A tab=()
    # Function to put config from file to tab
    fileTotab(){
        sfile=$1
        while read -r line ; do
            if [ $(echo $line | grep -Ec "^#.*") -eq 0 ] ; then
            # then the line is not a commentary
                varname=$(echo $line | cut -d "=" -f1)
                varvalue=$(echo $line | cut -d "=" -f2)
                tab["$varname"]="$varvalue"
            else
            # The line is a commentary
                continue
            fi
        done < $sfile
    }
    # Function that put the config from tab to a file
    tabTofile(){
        filedest=$1
        echo "# Configuration for production" > $filedest
        for key in "${!tab[@]}" ; do
            echo "${key}=${tab[$key]}" >> $filedest
        done
    }
    # 
    fileTotab $1
    fileTotab $2
    tabTofile $1
}
### -----Programme de trie de table------#

#### Programme de trie par selection

### -----Programme d'execution d'une suite de commande-----#

#### Les commandes issue d'un tableau

#### Les commandes issue d'un pile


# -------------------Exercice de perfectionnement--------------------#

#### voir exercice de confirmation bash sur internet/chat

#### voir les exercices de confirmation awk, cut, sed

# -------------------------------------------------------------------------------#
surchageConfig .env .env.file
