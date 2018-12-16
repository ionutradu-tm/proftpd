# proftpd
Docker image for proftpd (HiddenStores on)

Create runtime FTP user
------------------------------

To create a user on the ftp container, use the following environment variables: `FTP_USER_NAME` and `FTP_USER_PASS. The home user will be in /home/ftpusers
Example:

FTP_USER_NAME=guest
FTP_USER_PASS=guest

Passive Ports
----------------------------
The default passive range ports is 31100 31139. Add the environment variable FTP_PASSIVE_PORTS to change it
Example:
FTP_PASSIVE_PORTS=31000:31019
or
FTP_PASSIVE_PORTS="31000 31019"


Max clients
----------------------------
By default we set 20 max clients, , but you can increase this by using the following environment variable FRP_MAX_CLIENTS
Example:
FTP_MAX_CONNECTIONS=10

ExternalIP
----------------------------
Set the external IP Address using the environment variable FTP_MasqueradeAddress
Example
FTP_MasqueradeAddress=yes        the environment varibale $HOST will be used
FTP_MasqueradeAddress=no         disable
FTP_MasqueradeAddress="1.1.1.1"  The IP Address 1.1.1.1 will be used (or anything that you typed)

