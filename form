curl https://gist.githubusercontent.com/kuzoncby/0041f4640351660621f25c933bd2fdea/raw/afddd73825b86cc9a7ece5e6e05be999d6fc465f/airflow-install-centos-7.sh | bash 



create file install.sh and paste 

#!/usr/bin/env bash

# Setup Airflow for CentOS 7.6 with 'base' installation
# - Airflow 1.10
# - MariaDB 10 with PyMySQL driver
#

yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
yum install https://centos7.iuscommunity.org/ius-release.rpm -y
yum install gcc-c++ python36u-pip python36u-devel crudini centos-release-openstack-rocky nginx -y
# sed -i 's/mirror.centos.org/mirrors.ustc.edu.cn/g' /etc/yum.repos.d/*
yum install mariadb-server -y

cat <<EOF > /etc/my.cnf.d/airflow.cnf
[server]
explicit_defaults_for_timestamp = 1
EOF
systemctl start mariadb

cat <<EOF > /tmp/create-airflow.sql
DROP USER IF EXISTS 'airflow'@'localhost';
DROP USER IF EXISTS 'airflow'@'%';

CREATE DATABASE IF NOT EXISTS airflow;

CREATE USER 'airflow'@'localhost'
  IDENTIFIED BY 'airflow';
CREATE USER 'airflow'@'%'
  IDENTIFIED BY 'airflow';

GRANT ALL PRIVILEGES ON *.* TO 'airflow'@'localhost'
WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'airflow'@'%'
WITH GRANT OPTION;

FlUSH PRIVILEGES;
EOF

mysql -u root < /tmp/create-airflow.sql

# python3.6 -m pip install pip  --upgrade --index-url https://mirrors.ustc.edu.cn/pypi/web/simple
# SLUGIFY_USES_TEXT_UNIDECODE=yes pip3.6 install apache-airflow openshift mysqlclient \
#     --upgrade --index-url https://mirrors.ustc.edu.cn/pypi/web/simple
python3.6 -m pip install pip --upgrade
SLUGIFY_USES_TEXT_UNIDECODE=yes pip3.6 install apache-airflow openshift pymysql --upgrade

airflow initdb
crudini --set ~/airflow/airflow.cfg core sql_alchemy_conn 'mysql+pymysql://airflow:airflow@127.0.0.1/airflow'
crudini --set ~/airflow/airflow.cfg celery broker_url 'sqla+pymysql://airflow:airflow@127.0.0.1:3306/airflow'
crudini --set ~/airflow/airflow.cfg celery result_backend 'db+pymysql://airflow:airflow@127.0.0.1:3306/airflow'
mkdir ~/airflow/dags
airflow initdb

cat <<EOF > /usr/lib/systemd/system/airflow-webserver.service
[Unit]
Description=Airflow Web Server Daemon
After=network.target mariadb.service
Wants=mariadb.service

[Service]
User=root
Group=root
Type=simple
ExecStart=/bin/airflow webserver --pid /tmp/webserver.pid
Restart=on-failure
RestartSec=5s
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >  /usr/lib/systemd/system/airflow-scheduler.service
[Unit]
Description=Airflow Scheduler Daemon
After=network.target mariadb.service
Wants=mariadb.service

[Service]
User=vagrant
Group=vagrant
Type=simple
ExecStart=/bin/airflow scheduler
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

# Setup Airflow Rest API Plugin
#wget https://github.com/teamclairvoyant/airflow-rest-api-plugin/archive/v1.0.4.zip
#unzip airflow-rest-api-plugin-master.zip
#sudo mv airflow-rest-api-plugin-master/plugins /home/vagrant/airflow/

systemctl daemon-reload
systemctl start airflow-scheduler.service
systemctl start airflow-webserver.service

cat <<EOF > /etc/nginx/conf.d/airflow.conf
server {
    listen       80;
    server_name  airflow.example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host:\$server_port;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}

EOF
setsebool -P httpd_can_network_connect 1
systemctl start nginx.service
