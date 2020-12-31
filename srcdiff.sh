#!/bin/bash

errorCode=0
#########check whether there are two inputs and those two are a valid directory############
if [ $# -ne 2 ]; then #check 2 inputs
	echo Error: Expected two input parameters.
	echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
	exit 1
elif [ ! -d $1 ]; then #check the first input = directory
	echo "Error: Input parameter #1 '$1' is not a directory."
	echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
	exit 2
elif [ -f $1 ]; then #check the first input = file
	echo "Error: Input parameter #1 '$1' is a file instead of a directory."
	exit 2
elif [ ! -d $2 ]; then #check the second input = directory
	echo "Error: Input parameter #2 '$2' is not a directory"
	echo "Usage: ./srcdiff.sh <originaldirectory> <comparisondirectory>"
	exit 2
elif [ -f $2 ]; then #check the second input = file
	echo "Error: Input parameter #2 '$2' is a file instead of a directory"
	exit 2
else 
	dir1=$(cd $1; pwd) #change it to the absolute path regardless of the input
	dir2=$(cd $2; pwd)
	
	if [ $dir1 == $dir2 ];then
		echo "Error: '$1' and '$2' are the same directory"
		exit 2
	fi

	
	isSame=T
	files1=$(ls $dir1)
	files2=$(ls $dir2)
	
	#check same name files
	for file1 in $files1
	do
		if [ -f $dir1/$file1 ]; then #check if it is a file
			if [ -f $dir2/$file1 ]; then #check it exists in the second dir
				diff -s $dir1/$file1 $dir2/$file1 #if exist check they are different
				if [ $? -ne 0 ]; then #if different
					errorCode=3
					echo "$dir1/$file1 differs"
				fi
			fi
		fi
	done

	#check file1 exists in dir2
	for file1 in $files1 #iterate over the first dir
	do
		if [ -f $dir1/$file1 ]; then # check if it is a file
			if [ ! -f $dir2/$file1 ];then # if missing in dir2
				errorCode=3
				echo $dir2/$file1 is missing
			fi
		fi

	done

	#check file2 exists in dir1
	for file2 in $files2
	do
	       	if [ -f $dir2/$file2 ];then # check if it is a file in dir2
			if [ ! -f $dir1/$file2 ];then #if missing in dir1
				erroCode=3
				echo $dir1/$file2 is missing
			fi
		fi	
	done
exit $errorCode
fi
