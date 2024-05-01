# title: Introduction to Bash
# author: Briana Barajas
# date: 2024-05-01

## =============================================================
##                   Tips for Getting Started
## =============================================================
# Enter Week3 folder in eds-213-class-data
# No longer using DuckDB, run following just in the terminal 
# Bash is sensitive to spacing
# Must use double quotes, single quotes prints wrong name
# Run #!/bin/bash before stardting commands

## =============================================================
##                         Basic Commands
## =============================================================
# list all csv files in the folder
wc -l *.csv

# view all filepath options
$PATH

# view all paths to python (include hidden using -a)
which -a python -- a includes 

# view all shell paths
which -a $shell

# print date
date

# set date as a variable and print
today=$(date)
echo $today

# clear terminal
clear

# basic math
echo $((2*4))

## =============================================================
##                         Bash Shell Scripts
## =============================================================
# EXAMPLE: Create a for-loop to print the number of rows for each files
#!/bin/bash 

for file in *.csv; do
    echo "$file has $(wc -l < $file) lines"
done

# EXAMPLE: Compute the sum of two numbers 

#!/bin/bash
first=$1
second=$2

echo "The sum for $first and $second is $(($first+$second))"