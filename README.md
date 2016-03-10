#Abby's Amazing GC Calculator
**A script to calculate GC content from a FASTA formatted sequencing file! Amazing for all your sequencing needs!**

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
  `100 % GC CONTENT`<p>
  
The program will also output the results to a txt file called [FILENAME].gcoutput.txt. For example, if you entered the file "coolfasta.fa," the output .txt file would be named "coolfasta.fa.gcoutput.txt." This allows you to run multiple GC content calculations and save the results to use later.<br>

###FASTA REQUIREMENTS
The formatting of the FASTA file should be standard to most simple sequencing outputs. Each individual sequence within the file should be formatted as follows: <p>
> \>Header <br>
> AGTCGTACGTAGCTAGCTAGCTACGTACGATCGATCGATCGATCGATCGATCGATCGATCGATCGAT <p>

Ensuring that the FASTA file is in the appropriate format will prevent errors when running of the program.
_To learn more about FASTA file formatting, please visit [this link](http://zhanglab.ccmb.med.umich.edu/FASTA/)._

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
`echo "Number of Sequences in File: $NL"`<br>
`let NL=$NL-1`<br>
`let X=0`<br>
`while test $X -le $NL`<br>
`do`<br>
`        TOT='echo ${Sequences[$X]} | wc -m'`<br>
`        TOTFIX='expr $TOT - 1'`<br>
`        G='echo ${Sequences[$X]} | grep -roi "g" | wc -m`<br>
`        C='echo ${Sequences[$X]} | grep -roi "c" | wc -m`<br>
`        GC='expr $G + $C`<br>
`        GCBIIG='expr $GC \* 50`<br>
`        Percent[$X]='expr $GCBIIG / $TOTFIX'`<br>  
`        let X=$X+1` <br>
`done` <p>

Finally, the header and GC content percentage are printed to a txt output. The filename of this output depends on the name of the FASTA file entered into the command line. <p>

`echo "GC Content for $1 ...  " > $1.gcoutput.txt` <br>
`NX=${#Headers[@]}` <br>
`let NX=$NX-1`<br>
`N=0`<br>
`H=0`<br>
`while test $N -le $NX`<br>
`do`<br>
`        echo "*** " >> $1.gcoutput.txt` <br>
`        echo ${Headers[$N]} >> $1.gcoutput.txt` <br>
`        echo "${Percent[$H]} % GC CONTENT" >> $1.gcoutput.txt` <br>
`        H='expr $H + 1'`<br>
`        N='expr $N + 1'`<br>
`done`<br>

`cat $1.gcoutput.txt`<p>

###ALTERNATE SCRIPT FOR BATCH FILE PROCESSING
####AKA "THE ELIGIBLE BATCH-ELOR"

In addition to the single-input version of the GC Calculator, there is another version which has the ability to process more than one file at once. The command line input for this script is as follows: <p>
`./gccontentbatch.sh [FILE1].fa [FILE2].fa [FILE3].fa ... `<p>
The script for this calculator functions much like the single-input version; however, there are two important caveats.<p>
- This script should only be used to process multiple inputs. Specifying only one FASTA input may lead to an error message.
- The outputs of the batch processing will be sent to file and will **NOT** be displayed on the screen! You'll need to open the .txt outputs for each calculation to see the findings. The reason for this is to avoid clogging the terminal with large amounts of information.<p>

At any rate, the ability to process more than one fasta file at once is important in many applications and makes life much simpler.<p>

###TROUBLESHOOTING AND ERRORS

> Q: When I run the program, it outputs the message "Please include a fasta input on the command line!"<br>
> A: You need to specify a FASTA-formatted file on the command line when you run the script.<p>

> Q: All the spaces where the percentage GC content should be are blank.<br>
> A: Your sequences has no GC content or may be formatted improperly.<p>

> Q: The program doesn't seem to distinguish headers from the sequence data.<br>
> A: Make sure that the headers begin with > as in a standard FASTA format.<p>

###
