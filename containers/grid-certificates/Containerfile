FROM docker.io/library/centos:7

WORKDIR grid-certificates
COPY ./grid-certificates/ .

RUN yum -y update && yum -y upgrade
RUN yum install -y bash bash-doc bash-completion
