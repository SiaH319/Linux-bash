#!/bin/bash

inputFile=$1
Usage(){
echo " Usage: ./webmetrics.sh <logfile>"
}

#no argument passed

if [[ $# == 0 ]]
then 
	echo "Error: No log file given"
	Usage
	exit 1

#no such file exist
elif [[ ! -f $inputFile ]]
then 	
	echo "Error: File '$inputFile' does not exist"
	Usage
	exit 2
else
	
	#Number of requests per web browser
	#Fine the number of occureces of such word in the file
	Safari=$(grep -o 'Safari' $inputFile | wc -l)
	Firefox=$(grep -o 'Firefox' $inputFile | wc -l)
	Chrome=$(grep -o 'Chrome' $inputFile | wc -l)

	echo "Number of requests per web browser"
	echo "Safari, $Safari"
	echo "Firefox, $Firefox"
	echo "Chrome, $Chrome"
	printf "\n"
	#####============================================================================================================================================####
	#Number of disgtinct users perday
	dates=()
	tmpDates=()
	findDate=$(awk '{print $4}' $inputFile) #fourth word of a file indicates dates
	for i in $findDate
	do  
		tmpDates+=("${i:1:11}") #extrac DD/MMM/YYYY
	done

	dates=($(echo "${tmpDates[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')) #remove duplicates

	echo "Number of distinct users per day"
	for i in "${dates[@]}" #iterate each date
	do
 		grepping=$(grep -n $i $inputFile | cut -f1 -d:) #get line numbers of a certain date
		gr=$(echo $grepping)
		startingLine=$(echo $gr | awk '{print $1}') #first line where a certain date appear
		endingLine=$(echo $gr | awk '{print $NF}') #last line where a certain date appear

		ips=$(awk 'NR>='$startingLine' && NR<='$endingLine' {print $1}' < $inputFile) 
		#get ips of a range of lines
		users=()
		for ip in $ips #iterate over ips
		do
			users+=("$ip") #add to an array
		done

		distinct=($(echo "${users[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ' )) #remove duplicates
		distinctNum=$(echo "${#distinct[@]}") #number of elements (distinct ips) in array
		echo $i,$distinctNum
	done
	printf "\n"
####==============================================================================================================================================####
	#Top 20 popular product requests
	echo "Top 20 popular product requests"
	grep -Po '(?<=GET /product/)[0-9]+(?=/)' $inputFile > products.txt
	#find product number and store it in the temporary text file
	sort products.txt | uniq -c | sort -nr -k 1,1 -k 2,2 > sorted.txt 
	#sort file like in order of the number of product and id 
	#display them like this in every line: # of product product id
	cat sorted.txt | awk '{print $2","$1; if (NR == 20) exit}'
	#now only display top 20 popular products
	#display them like this in every line: product id,#of products	
	rm products.txt #remove the temporary file
	rm sorted.txt
	printf "\n"
	printf "\n"

	exit 0
fi
