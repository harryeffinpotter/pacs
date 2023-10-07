#!/bin/sh

# INFO.

# chmod +x if you get permission denied error.
# --noconfirm is enabled with interactive package installer by default/.


# Syntax = ./pacs.sh <partial package name> <flags>
# E.G.: ./pacs.sh zsh -s, ./pacs.sh php -i, ./pacs.sh haste


# RECOMMENDED:
# Add this to pacs function below to ~/.zshrc for ez search.
# E.G.: pacs zsh -s, pacs php -i, pacs haste


#  pacs(){
#      # Whever you clones the pacs repo to.
#      # $0 = entire script path, $1 = first argument, $* = all arguments (does not include script path).
#      ~/pacs/pacs.sh "$*"
#  }


# pacs -h to show help.


startdir="$PWD"
cd ~
BLUE='\033[1;34m'
WHITE='\033[0;37m'
RED='\033[1;31m'
PURPLE='\033[1;35m'
GREEN='\033[1;32m'
GOLD='\033[1;31m'
choice=0
alternate=0
installmode=0
rm -rf paclist.tmp
rm -rf pacmansearch.tmp
searchterm="$(echo "$*" | sed "s/[[:space:]]-.*//g" )"
if [[ "$*" == *"-i"* ]]; then
    installmode=1
fi
if [[ "$*" == *"-s"* ]]; then
    pacman -Ss "$searchterm" | grep -i ".*/" | sed "s/.*\/\(.*\)[[:space:]].*$/\1/g" | sed "s/[[:space:]].*//g"
    yay -Ss "$searchterm" | grep -i ".*/" | sed "s/.*\/\(.*\)[[:space:]].*$/\1/g" | sed "s/[[:space:]].*//g"
    exit
fi
if [[ "$*" == *"-h"* ]]; then
echo -e "\n==========\npacs help:\n=========="
    echo -e "${BLUE}-s ${WHITE}Simple mode, return only matching packagenames."
    echo -e "${BLUE}-i${WHITE} Installer Mode, pacs will number the list of packages, allowing you to quickly install one or more packages. Under the hood this uses pacman -Sy --noconfirm --overwrite.\n"
    exit
fi
balls=""
both=0
pkg=""
desc=""
full=""
pacman -Ss "$searchterm" >> pacmansearch.tmp
yay -Ss "$searchterm" >> pacmansearch.tmp
while read -r line
do
    is_aur=0
    if (( $alternate == 0 )); then
        GREEN='\033[1;32m'
        alternate=1
    else
        GREEN='\033[1;35m'
        alternate=0
    fi
    if [[ "$line" == *"/"* ]]; then
        both=0
        if [[ "$line" == *"aur"* ]]; then
            is_aur=1
        fi
        pkg="$(echo -e "${BLUE}$line" | sed 's/.*\///g' | sed 's/[[:space:]].*$//g')"
    else
        both=1
        desc="$(echo -e "${WHITE}$line" | sed 's/\s*\(.*\)/\1/g')"
    fi
    if (( both == 1 )); then
        full="$GREEN$pkg - $WHITE$desc"
        if (( $installmode == 1)); then
            ((choice++))
            ballsnew="$BLUE$choice. $full"
            balls="$balls\n$ballsnew"
            if  (( $is_aur == 1 )); then
            echo -e "$choice. !$pkg" >> paclist.tmp
            else
            echo -e "$choice. $pkg" >> paclist.tmp
            fi
        else
            balls="$balls\n$full"
        fi
    fi
done < "pacmansearch.tmp"
echo -e "$balls" | column
if  (( $installmode == 1 )); then
    echo -e "\n$PURPLE\nEnter range or indvidual numbers.$BLUE"
    read -p "Choose package numbers (6-32, 4 6 25, [Q]uit): " installs
    echo -e "${WHITE}"
    if [ -n "$installs" ]; then
        if [[ "$installs" == *"Q" || "$installs" == *"q" ]];  then
            echo -e "Quitting...\n"
            exit
        fi
        numbers=$(echo "$installs" | sed 's/[a-zA-Z.]*//g')
        if [ -n "$numbers" ]; then
            if [[ "$numbers" == *"-"* ]]; then
                lownumber=$( echo "$numbers" | sed 's/-.*//g')
                highnumber=$( echo "$numbers" | sed 's/.*-//g')
                while (( $lownumber <= $highnumber )); do
                    package=$( cat paclist.tmp | grep -i "^$lownumber\." | sed "s/$lownumber\.//g" )
                    if echo $package | sed 's/!//g'; then
                        yay -S ${package} --noconfirm
                    else
                        sudo pacman -Sy ${package} --noconfirm --overwrite
                    fi
                    ((lownumber++))
                done
            else
                commagone=$( echo "$numbers" | sed 's/,//g' )
                arr=($commagone)
                for i in "${arr[@]}"; do
                    package=$( cat paclist.tmp | grep -i "^${i}\." | sed "s/${i}.//g" )
                    if echo $package | sed 's/!//g'; then
                        yay -S ${package} --noconfirm
                    else
                        sudo pacman -Sy ${package} --noconfirm --overwrite
                    fi
                done
            fi
        fi
    fi
    rm -rf paclist.tmp
fi

cd "$startdir"
 
