#!/bin/bash

FTP_MasqueradeAddress="no"

if [[ ${FTP_MasqueradeAddress,,} == "yes" ]];
then
  echo "MasqueradeAddress $HOST"
elif [[ ${FTP_MasqueradeAddress,,} != "no" ]];
    then
    echo "MasqueradeAddress $FTP_MasqueradeAddress"
fi

