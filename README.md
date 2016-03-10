#Abby's Amazing GC Calculator
**A script to calculate GC content from a FASTA formatted sequencing file.**

###GENERAL USAGE INSTRUCTIONS
To calculate the GC content of sequences contained in an appropriate FASTA file, enter the following to the command line: <p>
  `./gccontent [FASTA FILENAME]` <p>
The output of the program will appear as follows: <p>
  `***` <br>
  `Calculating GC Content for [FASTA FILENAME] ...` <br>
  `Number of Sequences in File: [INTEGER]`<br>
  `GC Content for [FASTA FILENAME] ...`  <br>
  `***` <br>
  `>Sample Header 1`<br>
  `50 % GC CONTENT`<br>
  `***` <br>
  `>Sample Header 2`<br>
  `0 % GC CONTENT`<br>
  `***` <br>
  `>Sample Header 3`<br>
  `100 % GC CONTENT`<br>

###FASTA REQUIREMENTS
The formatting of the FASTA file should be standard to most simple sequencing outputs. Each individual sequence within the file should be formatted as follows: <p>
> \>Header <br>
> AGTCGTACGTAGCTAGCTAGCTACGTACGATCGATCGATCGATCGATCGATCGATCGATCGATCGAT <p>

Ensuring that the FASTA file is in the appropriate format will prevent errors when running of the program.

###SCRIPT WALKTHROUGH

The first command in the script specifies the programming language; in this case, it is a bash script. <p>
`#! /bin/sh` <p>

The next few lines assure the user that the program is running with a introductory message and check to ensure that an appropriate FASTA file has been designated for the program. <p> 

`echo "Calculating GC Content for $1 ..."`<br>

`if [ $# != 1 ]; then`<br>
`        echo "Please include a fasta input on the command line!"`<br>
`        exit`<br>
`fi`<p>

Next, the headers and sequences are seperated into two different arrays. This is done using a grep search for the ">" character that designates headers within FASTA formatted files. In this situation, the array number for each sequence corresponds to the array number for the header - in other words, Headers[N] corresponds to Sequences[N], where N is equal to some integer. <p>
`IFS=$'\n'`<br>
`Headers=($(grep ">" $1))`<br>
`Sequences=($(grep -v ">" $1))`<p>

Next, all the G's and C's within the sequence are obtained and the percentage GC when compared to the total is obtained. The command "expr" is used heavily in this section of code to perform the needed calculations. <p>

`NL=${#Sequences[@]}`<br>
`echo "Number of Sequences in File: $NL"
`let NL=$NL-1
`let X=0
`while test $X -le $NL
`do
`        TOT=`echo ${Sequences[$X]} | wc -m`
`        TOTFIX=`expr $TOT - 1`
`        G=`echo ${Sequences[$X]} | grep -roi "g" | wc -m`
`        C=`echo ${Sequences[$X]} | grep -roi "c" | wc -m`
`        GC=`expr $G + $C`
`        GCBIIG=`expr $GC \* 50`
`        Percent[$X]=`expr $GCBIIG / $TOTFIX`  
`        let X=$X+1` <br>
`done` <p>

#Get the file name

echo "Calculating GC Content for $1 ..."

if [ $# != 1 ]; then
        echo "Please include a fasta input on the command line!"
        exit
fi


#Find header and put in array

IFS=$'\n'
Headers=($(grep ">" $1))
Sequences=($(grep -v ">" $1))

#Find all G's and C's in sequence array and store to another array

NL=${#Sequences[@]}
echo "Number of Sequences in File: $NL"
let NL=$NL-1
let X=0
while test $X -le $NL
do
        TOT=`echo ${Sequences[$X]} | wc -m`
        TOTFIX=`expr $TOT - 1`
        G=`echo ${Sequences[$X]} | grep -roi "g" | wc -m`
        C=`echo ${Sequences[$X]} | grep -roi "c" | wc -m`
        GC=`expr $G + $C`
        GCBIIG=`expr $GC \* 50`
        Percent[$X]=`expr $GCBIIG / $TOTFIX`
        let X=$X+1
done


###TROUBLESHOOTING AND ERRORS
