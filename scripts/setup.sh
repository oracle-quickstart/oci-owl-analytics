# expects $KEY
cd ~opc

export JAVA_HOME=/usr
export SPARK_HOME=/opt/owl/spark
export PATH=$PATH:/opt/owl/spark/bin
ssh-keygen -t rsa -N "" -f ~opc/.ssh/id_rsa
cat ~opc/.ssh/id_rsa.pub >> ~opc/.ssh/authorized_keys
## Install Java 1.8
yum install -y java-1.8.0-openjdk
##
mkdir /opt/owl/
chmod -R 777 /opt
mkdir build
## Get Owl Packages, spark.
cd build
wget --quiet https://owl-packages.s3.amazonaws.com/owl-2.9.0-package-rhel7-base.tar.gz
tar -xvf owl-2.9.0-package-rhel7-base.tar.gz
wget --quiet https://downloads.apache.org/spark/spark-2.3.4/spark-2.3.4-bin-hadoop2.6.tgz
wget --quiet https://owl-packages.s3.amazonaws.com/additional/orientdb.tar.gz
mv spark-2.3.4-bin-hadoop2.6.tgz spark-2.3.2-bin-hadoop2.6.tgz
sed -i 's/com.owl.org.postgresql.Driver/org.postgresql.Driver/g' setup.sh
##
sudo -u opc ./setup.sh -port=9000 -owlbase=/opt -owlpackage=/home/opc/build -options=postgres,spark,owlagent,orient,owlweb -pgpassword=owl123 -pgserver=localhost
sleep 2
echo "key=$KEY" >> /opt/owl/config/owl.properties
##
/home/opc/stopAll.sh
sleep 3
/home/opc/startAll.sh
sleep 2
