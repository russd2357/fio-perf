FROM ubuntu:20.04
RUN apt-get -y update
RUN apt-get -y install fio wget
# Check ENV vars
ADD run.sh /opt/run.sh
RUN chmod +x /opt/run.sh
# create 
VOLUME /mnt/azurefiles
WORKDIR /mnt/azurefiles
CMD ["/opt/run.sh"] 