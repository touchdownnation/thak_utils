#!/bin/bash

yum groupinstall -y "Development tools"
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel python-devel wget cyrus-sasl-devel.x86_64
yum install -y mysql-devel python-devel python-setuptools 




yum install epel-release -y
yum install gcc-c++ -y
yum install -y mysql-devel python-devel python-setuptools

