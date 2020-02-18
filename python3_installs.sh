#!/bin/bash

##upgrade centos OS on Docker

yum install epel-release -y
yum install gcc-c++ -y
yum install -y mysql-devel python-devel python-setuptools

##install Python3.6

yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yum -y install python36u

##Install PIP for Python 3.6

yum -y install python36u-pip

#Update Python development tools

yum -y install python36u-devel
python3 -m pip install --upgrade pip setuptools wheel

ln -s /usr/local/bin/pip3 pip
