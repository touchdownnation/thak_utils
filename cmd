
ZK data dir
dataDir=/opt/data/zookeeper_data

log.dirs=/opt/data/kafka-logs

zookeeper.connect=172.26.60.45:2181,172.26.60.46:2181,172.26.60.47:2181





dataDir=/opt/data/zookeeper_data
clientPort=2181
maxClientCnxns=200
tickTime=2000
server.1=172.26.60.45:2888:3888
server.2=172.26.60.46:2888:3888
server.3=172.26.60.47:2888:3888

initLimit=20
syncLimit=10



##Zk start
/opt/apche_kafka/zookeeper/bin/zkServer.sh start /opt/apche_kafka/zookeeper/conf/zookeeper.properties
/opt/apche_kafka/zookeeper/bin/zkServer.sh status
##kafka start
/opt/apche_kafka/kafka/bin/kafka-server-start.sh  /opt/apche_kafka/kafka/config/server.properties

#create topic
/opt/apche_kafka/kafka/bin/kafka-topics.sh --create --zookeeper 172.26.60.45:2181,172.26.60.46:2181,172.26.60.47:2181 --replication-factor 3 --partitions 3 --topic test_replica3

#list topic
/opt/apche_kafka/kafka/bin/kafka-topics.sh --list --zookeeper 172.26.60.45:2181,172.26.60.46:2181,172.26.60.47:2181

#producer
/opt/apche_kafka/kafka/bin/kafka-console-producer.sh --broker-list 172.26.60.45:9092,172.26.60.46:9092,172.26.60.47:9092 --topic test_replica3

#Consumer
/opt/apche_kafka/kafka/bin/kafka-console-consumer.sh --bootstrap-server 172.26.60.45:9092,172.26.60.46:9092,172.26.60.47:9092 --topic test_replica3 --from-beginning


## Test import

# This code is made for Unix-based systems such as Linux and Mac OSX
# For Windows use bin\windows\ instead of bin/, and change the script extension
# to .bat

# Create a simple text file to work with that has 2 lines
> echo -e "foo\nbar" > test.txt

# Setup connector in standalone mode
# pass in connection properties config
# then file connection config
# then file sync config (serialization)
# all configs here ship w/ Kafka and act as templates
> bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties

# Once the above connector starts running, it will read test.txt
# and write to test.sink.txt
# We can see this by reading the contents of the file
> cat test.sink.txt
foo
bar

# To see the data in the consumer run the following
> bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning

# In a separate terminal window, add some lines to the file
echo "Another line" >> test.txt
