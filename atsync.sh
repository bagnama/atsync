#!/bin/bash

IFS="=" read -r var1 profile_name < config.txt

cd profiles
paths=()
if test -d $profile_name.txt; then
   
while IFS= read -r line; do
	 paths+=("$line")
done < $profile_name.txt
fi
cd ..

# FLAGS
# - AUTORECURSION : when autorecursion flag is on, atsync adds automatically the -r (--recursive) option to rsync 
# ATTENTION : it adds the option -r only when rsync get executed, and not in the file paths.txt
IFS=' ' read -r autorecursion < ./var/autorecursion.txt
if [ "$1" = "autorecursion" ]; then
    if [ "$2" = "on" ]; then
	rm -r ./var/autorecursion.txt
	echo "on" > ./var/autorecursion.txt
	IFS=' ' read -r autorecursion < ./var/autorecursion.txt
	echo "Autorecrusion is ON"
    elif [ "$2" = "off" ]; then
	rm -r ./var/autorecursion.txt
	echo "off" > ./var/autorecursion.txt
	IFS=' ' read -r autorecursion < ./var/autorecursion.txt
	echo "Autorecrusion is OFF"
    elif [ "$2" = "chk" ]; then
	echo $autorecursion	
    fi
fi

if [ "$1" = "profile" -a ! -z "$2" ]; then

    # add profile
    if [ "$2" = "add" ]; then
	if [ ! -z "$3" ]; then
	    echo "$3" >> profiles.txt
	    cd ./profiles
	    touch "$3".txt
	fi
    fi

    # select profile
    if [ "$2" = "select" ]; then
	if [ ! -z "$3" ]; then
	    rm -r ./config.txt
	    touch ./config.txt
	    echo "selected_profile=$3" >> config.txt
	fi
    fi

    # remove profile
    if [ "$2" = "remove" ]; then
	if [ ! -z "$3" ]; then
	    sed -i "/$3/d" profiles.txt
	    cd profiles
	    rm -r "$3".txt
	fi
    fi

    # prit profiles list
    if [ "$2" = "print" ]; then
	while read -r line; do
	    echo $line
	done < profiles.txt
    fi

    # show the selected profile
    if [ "$2" = "chk" ]; then
	echo $profile_name
    fi
fi

# adding paths to the selected profile
if [ "$1" = "add" -a ! -z "$2" -a ! -z "$3" ] ; then
    farg="$2"
    sarg="$3"
    if [ ! -z "$4" ]; then
	shift 1
	shift 2
	shift 3
	cd profiles
	#maximum two optin for rsync, don't know why
	echo "$farg ---> $sarg | $*" >> $profile_name.txt
    else
	echo "$farg ---> $sarg" >> $profile_name.txt
    fi
fi

# start the syncing process
i=0
if [ "$1" = "sync" -a ! -z "$2"  ]; then
    if [ "$2" = "all" ]; then
	len=${#paths[@]}
	while [ $i -le $((len-1)) ]; do
	    IFS=" " read -r fpath var2 spath var4 options <<< ${paths[$i]}
	    i=$((i+1))
	    if [ $autorecursion = "on" ]; then options+=" -r"; fi
	    echo "rsync $fpath $spath $options"
	done
    else
	IFS=" " read -r fpath var2 spath var4 options <<< ${paths[$2]}
	if [ autorecursion = "on" ]; then options+=" -r"; fi
	echo "rsync $fpath $spath $options"
    fi
fi

# print the paths in the selected profile
i=0
if [ "$1" = "print" ]; then
    cd profiles
    while IFS= read -r line; do
	echo "($i) $line"
	i=$((i+1))
    done < $profile_name.txt
fi

# add a reset function
