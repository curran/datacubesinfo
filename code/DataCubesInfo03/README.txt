To deploy in a remote server:

Server Setup:
Assuming a fresh install of Ubuntu Server, here's how to set it up to run datacubesinfo:

# log in
ssh root@your-server-ip

# to change the root password:
passwd

# install java, mysql, unzip
sudo apt-get install openjdk-6-jre mysql-server unzip -y

# download and unzip Tomcat
mkdir opt
cd opt
wget http://mirror.olnevhost.net/pub/apache/tomcat/tomcat-7/v7.0.6/bin/apache-tomcat-7.0.6.zip
unzip apache-tomcat-7.0.6.zip
apache-tomcat-7.0.6 tomcat
rm apache-tomcat-7.0.6.zip 

# set necessary environment variables
echo '
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
export CATALINA_HOME=/opt/tomcat' >> ~/.bashrc

# set executable permissions on Tomcat startup/shutdown scripts
cd tomcat/bin/
chmod +x startup.sh shutdown.sh

# create the database used by the application
mysql -u root -p
mysql> create database datacubes;
mysql> grant all on datacubes.* to grails identified by 'g123';

# logout and deploy the WAR file
logout
cd DataCubesInfo03
grails war
scp target/DataCubesInfo03-0.1.war root@your-server-ip:/root/opt/tomcat/webapps/datacubes.war

# login and start the server

