


#!/bin/bash

#This script will generate 15 random character lines and append them to a temp file.  Once file reached 1MB, it will stop


#Create temp file for storing the random characters
TEMP=$(mktemp /tmp/tempfile.XXXXXXX)

#this is used to covert the random number to its asii character
chr() {
	#using printf was too slow so the case statement method was used instead
	#randomchar=$(printf \\$(printf '%03o' $num))
        case $1 in
                48) randomchar=0;;
                49) randomchar=1;;
		50) randomchar=2;;
		51) randomchar=3;;
		52) randomchar=4;;
		53) randomchar=5;;
		54) randomchar=6;;
		55) randomchar=7;;
		56) randomchar=8;;
		57) randomchar=9;;
		65) randomchar=A;;
		66) randomchar=B;;
		67) randomchar=C;;
		68) randomchar=D;;
		69) randomchar=E;;
		70) randomchar=F;;
		71) randomchar=G;;
		72) randomchar=H;;
		73) randomchar=I;;
		74) randomchar=J;;
		75) randomchar=K;;
		76) randomchar=L;;
		77) randomchar=M;;
		78) randomchar=N;;
		79) randomchar=O;;
		80) randomchar=P;;
		81) randomchar=Q;;
		82) randomchar=R;;
		83) randomchar=S;;
		84) randomchar=T;;
		85) randomchar=U;;
		86) randomchar=V;;
		87) randomchar=W;;
		88) randomchar=X;;
		89) randomchar=Y;;
		90) randomchar=Z;;
		97) randomchar=a;;
		98) randomchar=b;;
		99) randomchar=c;;
		100) randomchar=d;;
		101) randomchar=e;;
		102) randomchar=f;;
		103) randomchar=g;;
		104) randomchar=h;;
		105) randomchar=i;;
		106) randomchar=j;;
		107) randomchar=k;;
		108) randomchar=l;;
		109) randomchar=m;;
		110) randomchar=n;;
		111) randomchar=o;;
		112) randomchar=p;;
		113) randomchar=q;;
		114) randomchar=r;;
		115) randomchar=s;;
		116) randomchar=t;;
		117) randomchar=u;;
		118) randomchar=v;;
		119) randomchar=w;;
		120) randomchar=x;;
		121) randomchar=y;;
		122) randomchar=z;;
        *) ;;
esac
}


#There are 2 checks to stop this script once 1MB is reached.
#1 checks using 'wc' and sets $limitReached to True once the limit is reached
#The other counts the number of loops and exits once $loopCount >= 1000000

sizelimit=1000000   #1MB
loopCount=0


limitReached="False"
while [ $limitReached == "False" ]
do
	#Increment loop count by 1 for each loop.  Once 1000000 is reached, must exit
	loopCount=$((loopCount + 1 ))
	if [ $loopCount -ge $sizelimit  ] ;then
		echo loopcountsize limit reached $TEMP
		break
	fi


	#Generate 15 character string by looping until 15 characters are appended to the charstring variable
	charstring=""

	while [ ${#charstring} -lt 15 ]
	do

		#get random number which will be converted to ascii character
		num=$(( $RANDOM % 129 ))
		while :
		do	
			#Only except random numbers that are for [a-z][A-Z][0-9]
			if [[ $num -ge 48  &&  $num -le 57 ]] ;then break; fi
			if [[ $num -ge 65  &&  $num -le 90 ]] ;then break; fi
			if [[ $num -ge 97  &&  $num -le 122 ]] ;then break; fi

			num=$(( $RANDOM % 129 ))
		done

		#convert random number to ascii character
		chr $num
		#verify the ascii character is a letter or number; if it is, append it to $charstring
		if [[ $randomchar =~ [0-9] || $randomchar =~ [a-z] || $randomchar =~ [A-Z] ]]  ;then
			charstring=$charstring$randomchar 
		fi
	done

	#append the 15 character string to the $TEMP file
	echo $charstring >> $TEMP
	
	#This is the 2nd check to check the 1MB size limit has been reached. wc -c returns the number of bytes of the file
	filesize1=$(wc -c $TEMP | awk '{print $1}')
	if [ $filesize1 -ge $sizelimit ] ;then
		limitReached="True"
		echo size limit reached: $TEMP
	fi
done


#Create temp file for storing the sorted file
TEMP2=$(mktemp /tmp/tempfile.XXXXXXX)

#sort file and then send to sed to remove the a and then store file in the $TEMP2 file
sort $TEMP | sed '/^a/d' | sed '/^A/d' >  $TEMP2

lineCountFile1=$(wc -l $TEMP | awk '{print $1}')
lineCountFile2=$(wc -l $TEMP2 | awk '{print $1}')


LinesRemoved=$(( lineCountFile1 - lineCountFile2 ))
echo $LinesRemoved lines removed


