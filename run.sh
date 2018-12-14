#!/bin/bash


if [ -n "$FTP_USER_NAME" -a -n "$FTP_USER_PASS" ]; 
    then
	CRYPTED_PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $FTP_USER_PASS)
	mkdir /home/ftpusers/$FTP_USER_NAME
	useradd --shell /bin/sh -d /home/ftpusers/$FTP_USER_NAME --password $CRYPTED_PASSWORD $FTP_USER_NAME
	chown -R $FTP_USER_NAME:$FTP_USER_NAME /home/ftpusers/$FTP_USER_NAME
fi

echo "HiddenStores  on" >> /etc/proftpd/conf.d/custom.conf


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



echo "Starting Proftpd:"
exec /usr/sbin/proftpd -nc /etc/proftpd/proftpd.conf
