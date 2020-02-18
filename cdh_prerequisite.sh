#!/bin/bash

## Table on content ##

yum groupinstall -y 'base'
yum groupinstall -y 'development tools'

##freeipa ##
##ipa config-mod --defaultshell=/bin/bash
##authconfig --enablemkhomedir --update

echo "umask 0022" >> /etc/profile

## Disable firewalld
systemctl stop firewalld
systemctl disable firewalld

setenforce 0
sed -i 's/\(^[^#]*\)SELINUX=enforcing/\1SELINUX=disabled/' /etc/selinux/config
sed -i 's/\(^[^#]*\)SELINUX=permissive/\1SELINUX=disabled/' /etc/selinux/config

## MIS
systemctl enable ntpd
systemctl stop chronyd.service
systemctl disable chronyd.service
ulimit -n 10000

sysctl -w vm.swappiness=0
cat > /etc/sysctl.d/50-swappiness.conf <<-'EOF'
## no more swapping
vm.swappiness=0
EOF





#JAVA 

wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip


cat <<EOF > /etc/profile.d/javajdk.sh
export PATH=$PATH:/usr/java/jdk1.8.0_241-amd64/bin
export JAVA_HOME=/usr/java/jdk1.8.0_241-amd64
export JRE_HOME=/usr/java/jdk1.8.0_241-amd64/jre/
export J2SDKDIR=/usr/java/jdk1.8.0_241-amd64
export J2REDIR=/usr/java/jdk1.8.0_241-amd64/jre
EOF

echo "source /etc/profile.d/javajdk.sh" >> ~/.bash_profile
