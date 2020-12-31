#!/bin/bash
 # $1:directory for tar file $2:file or directory
 
 timeline=$(date '+%Y%m%d')

if [ -d $1 ];then #change to the absolute path
	dirTar=$(cd $1; pwd)
fi

if [ -d $2 ];then #change to the absolute path
	dirOrFile=$(cd $2; pwd)
	fileName=$(basename $dirOrFile)
	curr=$(pwd)
	relativePath=$(realpath --relative-to=$curr $dirOrFile) #relative path to the current path 
	echo The second input is a directory
fi

if [ -f $2 ]; then 
	name=$(base name $2)
	fileName="${name%.*}" #without extension
	parent="${2%/*}"
	absParent=$(cd $parent; pwd)
	dirOrFile=$absParent/$name
	curr=$(pwd)
	relativePath=$(realpath --relative-to=$curr $dirOrFile)
	echo The second input is a file
fi


if [[ $# -ne 2 ]]; then #check two inputs
	echo "Error: Expected two input parameters."
	echo "Usage: ./backup.sh <backupdirectory> <fileordirtobackup>"
	exit 1

elif [ ! -d "$1" ]; then #check wheter $1 directory exits
	echo Error: The directory $1 does not exist.
	exit 2

elif [ ! -d "$2" ] && [ ! -f "$2" ]; then #check $2 file or directory exists
	echo Error: The directory/file $2 does not exist.
	exit 2

elif [ $dirTar == $dirOrFile ]; then #chec
	echo Error: Both arguments are the same directory.
	exit 2

elif [ -f $dirTar/$fileName$timeline.tar ];then #check already the same name file exist or not
	echo -n  "backup file '$fileName$fimeline.tar' alredy exists. Overwirte? (y/n)" 
	read yno 
	case $yno in #read the input of the user
		[y] )
			tar -cvf $dirTar/$fileName$timeline.tar $relativePath
			exit 0
			;;
		* )
			echo "File not overwritten."
			exit 3	
			;;
	esac
else

	tar -cvf $dirTar/$fileName$timeline.tar $relativePath  
	exit 0
fi

