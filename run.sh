#!/bin/bash

sleep 15
if [ -n "$FTP_USER_NAME" -a -n "$FTP_USER_PASS" ]; 
    then
	CRYPTED_PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $FTP_USER_PASS)
	mkdir -p /home/ftpusers/$FTP_USER_NAME
	useradd --shell /bin/sh -d /home/ftpusers/$FTP_USER_NAME --password $CRYPTED_PASSWORD $FTP_USER_NAME
	chown -R $FTP_USER_NAME:$FTP_USER_NAME /home/ftpusers/$FTP_USER_NAME
fi

echo "HiddenStores  on" >> /etc/proftpd/conf.d/custom.conf
echo "DefaultRoot ~" >> /etc/proftpd/conf.d/custom.conf


if [ -z "$FTP_PASSIVE_PORTS" ]
   then
      FTP_PASSIVE_PORTS="31100 31139"
fi
echo "PassivePorts  $FTP_PASSIVE_PORTS" |  sed -e  "s/:/ /g" >> /etc/proftpd/conf.d/custom.conf

if [ -z "$FTP_MAX_CONNECTIONS" ]
   then
      FTP_MAX_CONNECTIONS=20
fi
echo "MaxInstances  $FTP_MAX_CONNECTIONS" >> /etc/proftpd/conf.d/custom.conf

if [[ ${FTP_DISABLE_LOGS,,} == "yes" ]];
then
 echo "SystemLog none" >>  /etc/proftpd/conf.d/custom.conf
 echo "TransferLog none" >>  /etc/proftpd/conf.d/custom.conf
fi


#Obtain external IP
# for DC/OS
if [[ -z "$MY_IP" ]]; then
    export MY_IP=$HOST
    echo "My ip is: $MY_IP"
fi
# for AKS
if [[ -z "$MY_IP" ]]; then
    export MY_IP=$(getent hosts $(hostname)| cut -d\  -f1)
    echo "My ip is: $MY_IP"
fi


# FTP_MASQUERADEADDRESS="yes" --> autodetect IP address
# FTP_MASQUERADEADDRESS != "yes" --> use the IP address provided by this var

if [[ ${FTP_MASQUERADEADDRESS,,} == "yes" ]];
then
  echo "MasqueradeAddress $MY_IP" >> /etc/proftpd/conf.d/custom.conf
elif [[ ${FTP_MASQUERADEADDRESS,,} != "no" ]];
    then
    echo "MasqueradeAddress $FTP_MASQUERADEADDRESS" >> /etc/proftpd/conf.d/custom.conf
fi

if [[ -n $TIMEOUT_IDLE ]]; then
   echo "TimeoutIdle $TIMEOUT_IDLE" >> /etc/proftpd/conf.d/custom.conf
fi

echo "custom.conf:"
cat /etc/proftpd/conf.d/custom.conf


echo "Starting Proftpd: /usr/sbin/proftpd -nqc /etc/proftpd/proftpd.conf"
exec /usr/sbin/proftpd -nqc /etc/proftpd/proftpd.conf
