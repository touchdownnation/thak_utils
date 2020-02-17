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

#Upgrade setuptools if needed.

pip3.6 install — upgrade pip
pip install — upgrade setuptools

#Basics python packages for Apache Airflow

pip install -U pip setuptools wheel
pip install pytz
pip install pyOpenSSL
pip install ndg-httpsclient

#One of the dependencies of Apache Airflow by default pulls in a GPL library (‘unidecode’). In case this is a concern you can force a non GPL library by issuing export SLUGIFY_USES_TEXT_UNIDECODE=yes and then proceed with the normal installation
#https://airflow.apache.org/installation.html

export SLUGIFY_USES_TEXT_UNIDECODE=yes
#install Apache Airflow

pip install apache-airflow
#Intiating Airflow DB , by default Apache airflow use Sqllite

airflow initdb
Export Airflow_home to /root/airflow
export AIRFLOW_HOME=/root/airflow
#Start Apache Airflow webserver

airflow webserver -p 8080
#Set up Mysql as backend/Metadata DB for Apache Airflow

yum install mariadb-devel — skip-broken
pip install Apache-airflow[mysql]
#on Mysql server

##SET explicit_defaults_for_timestamp=1
##Edit airflow.cfg on /root/airflow/airflow.cfg
# The SqlAlchemy connection string to the metadata database.
# SqlAlchemy supports many different database engine, more information
# their website
#sql_alchemy_conn = sqlite:////root/airflow/airflow.db
##sql_alchemy_conn = mysql://<username>:<password>@<mysql-server>:3306/airflow
##Reset/ initiate DB on airlfow
##airflow initdb
##and start Airflow Server
##airflow webserver -p 8080
