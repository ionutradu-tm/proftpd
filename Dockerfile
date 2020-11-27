FROM debian:stretch

RUN  apt-get -y update && \
     apt-get -y install proftpd
RUN apt-get clean

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 20-21 41200-41239

CMD /run.sh

 
 
