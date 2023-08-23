
#!/bin/sh
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
searchterm="$(echo "$*" | sed "s/[[:space:]]*-.*//g" )"
if [[ "$*" == *"-i"* ]]; then
    installmode=1
fi

pacman -Ss "$searchterm" >> pacmansearch.tmp
while read -r line
do
    if (( $alternate == 0 )); then
        GREEN='\033[1;32m'
        alternate=1
    else
        GREEN='\033[1;35m'
        alternate=0
    fi
    if [[ "$line" == *"/"* ]]; then
        pkg="$(echo -e "${BLUE}$line" | sed 's/.*\///g' | sed 's/[[:space:]].*$//g')"
    else
        desc="$(echo -e "${WHITE}$line" | sed 's/\s*\(.*\)/\1/g')"
    fi
    if (( $installmode == 1)); then
        ((choice++))
        echo -e "${BLUE}${choice}.${GREEN} ${pkg} - ${WHITE}${desc}"
        echo -e "${choice}.${pkg}" >> paclist.tmp
    else
        echo -e "${GREEN}${pkg} - ${WHITE}${desc}"
    fi
done < "pacmansearch.tmp"
rm -rf pacmansearch.tmp


if  (( $installmode == 1 )); then

    echo -e "\n${PURPLE}============\n${PURPLE}Install mode\n${PURPLE}============${WHITE}"
    echo -e "You can install from the list using one of the 2 supported methods below."
    echo -e "NOTE: Using multiple ranges or using method 1 and 2 at the same time is not yet supported.\n"
    echo -e "You can enter multiple numbers separated by spaces or commas, like this-"
    echo -e "${RED}1, 5, 6"
    echo -e "2 45 1"
    echo -e "34"
    echo -e "\n${WHITE}Or you can enter a range, like this-\n${RED}12-26\n1-45\n${BLUE}"
read -p "Choose package numbers[(Q)uit]: " installs
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
                    echo -e  "$package"
                    sudo pacman -Sy ${package} --noconfirm
                    ((lownumber++))
                done
            else
                commagone=$( echo "$numbers" | sed 's/,//g' )
                arr=($commagone)
                for i in "${arr[@]}"; do
                     package=$( cat paclist.tmp | grep -i "^${i}\." | sed "s/${i}.//g" )
                     echo -e "WILL BE INSTALLING - $package"
                     sudo pacman -Sy ${package} --noconfirm
                done
            fi
        fi
    fi
    rm -rf paclist.tmp
fi

cd "$startdir"
