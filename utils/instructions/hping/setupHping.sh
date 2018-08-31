CONFIG=$1
BACKENDADDR=$2

source $CONFIG

for i in "${pings[@]}"
do
	PROVIDER=$(echo $i | awk '{print $1}')
	KEY=$(echo $i | awk '{print $2}')
	FROMHOST=$(echo $i | awk '{print $3}')
	TOHOST=$(echo $i | awk '{print $4}')
	FROMZONE=$(echo $i | awk '{print $5}')
	TOZONE=$(echo $i | awk '{print $6}')
	SEQNUMBER=$(echo $i | awk '{print $7}') #Utilizzare un contatore incrementale?
	
	echo "Enable Hping for $PROVIDER from $FROMHOST($FROMZONE) to $TOHOST($TOZONE)"
	ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$FROMHOST bash -c "'
	mkdir -p ~/Modeling4Cloud/utils/
	sudo apt-get update -qq
	#sudo apt-get install expect -qq
	#sudo apt-get install hping3 -qq
	#sudo apt-get install git -qq'"
	scp -r -i $KEY ./hping/enableHping.sh ubuntu@$FROMHOST:~
	scp -r -i $KEY ./hping/registerHpingCsv.sh ubuntu@$FROMHOST:~/Modeling4Cloud/utils/
	scp -r -i $KEY ./curlCsv.sh ubuntu@$FROMHOST:~/Modeling4Cloud/utils/
	ssh -i $KEY ubuntu@$FROMHOST bash -c "'./enableHping.sh $PROVIDER $FROMZONE $TOZONE $TOHOST $SEQNUMBER $BACKENDADDR '"
	echo COMPLETE 
done



