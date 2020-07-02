# expects $KEY
cd ~opc

export JAVA_HOME=/usr
export SPARK_HOME=/opt/owl/spark
export PATH=$PATH:/opt/owl/spark/bin
export INSTALL_PATH=/opt/owl
export LOG_PATH=/opt/owl/log
export SPARK_HOME=/opt/owl/spark
export JAVA_HOME=/usr
export PATH=$PATH:/opt/owl/spark/bin

cat << EOF > startAll.sh
#!/usr/bin/env bash
export INSTALL_PATH=/opt/owl
export LOG_PATH=/opt/owl/log
export SPARK_HOME=/opt/owl/spark
export JAVA_HOME=/usr
export PATH=$PATH:/opt/owl/spark/bin
### Start Postgres Metastore
export PGDBPATH=/opt/owl/owl-postgres/bin/data
    if [ -f $INSTALL_PATH/owl-postgres/bin/pg_ctl ]; then
        #sh $INSTALL_PATH/orientdb/bin/server.sh >$LOG_PATH/orient-start.log 2>$LOG_PATH/orient-error.log &
        #sh $INSTALL_PATH/owl-postgres/bin/initdb >$LOG_PATH/postgres-init.log 2>$LOG_PATH/postgres-init-error.log & echo $! >/dev/null
        $INSTALL_PATH/owl-postgres/bin/pg_ctl -D $PGDBPATH start >$LOG_PATH/postgres-start.log 2>$LOG_PATH/postgres-start-error.log & echo $! >/dev/null
        #>$LOG_PATH/owl-web-app.log 2>$LOG_PATH/owl-web-app.error.log & echo $! >/dev/null
    else
       __die "Cannot find $INSTALL_PATH/owl-postgres/bin/pg_ctl"
    fi
sleep 3
### Start Owl spark master
$SPARK_HOME/sbin/start-master.sh
sleep 2
### Start Owl Spark workers
SPARK_WORKER_INSTANCES=4 SPARK_WORKER_CORES=2 $SPARK_HOME/sbin/start-slaves.sh
sleep 3
### Start Owl-Web
/opt/owl/bin/owlmanage.sh "start=owlweb"
sleep 2
###
EOF

cat << EOF > stopAll.sh
#!/usr/bin/env bash
/opt/owl/bin/owlmanage.sh "stop=owlweb"
/opt/owl/spark/sbin/stop-all.sh
/opt/owl/owl-postgres/bin/pg_ctl -D /opt/owl/owl-postgres/bin/data stop
EOF

chown opc:opc startAll.sh stopAll.sh
chmod 755 startAll.sh stopAll.sh

ssh-keygen -t rsa -N "" -f ~opc/.ssh/id_rsa
cat ~opc/.ssh/id_rsa.pub >> ~opc/.ssh/authorized_keys
chown opc:opc .ssh/id_rsa .ssh/id_rsa.pub

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
printf '\nowl123\nowl123\n' | sudo --preserve-env -u opc ./setup.sh -port=9000 -owlbase=/opt -owlpackage=/home/opc/build -options=postgres,spark,owlagent,orient,owlweb -pgpassword=owl123 -pgserver=localhost
sleep 2
echo "key=$KEY" >> /opt/owl/config/owl.properties
##
sudo -u opc /home/opc/stopAll.sh
sleep 3
sudo -u opc /home/opc/startAll.sh
sleep 2
