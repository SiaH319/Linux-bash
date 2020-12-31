#!/bin/bash

SCRIPT_PATH="./webmetrics.sh"
echo "Web metrics for log file weblog1.txt"
echo "===================="
"$SCRIPT_PATH" weblog1.txt
echo "Web metrics for log file weblog2.txt"
echo "===================="   
"$SCRIPT_PATH" weblog2.txt
echo "Web metrics for log file weblog3.txt"
echo "===================="
"$SCRIPT_PATH" weblog3.txt
printf "\n"
