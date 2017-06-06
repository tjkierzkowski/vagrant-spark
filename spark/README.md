Quick HDP Setup
=======

## Get started.

The software below is required to deploy and provision the clusters detailed in this document

Vagrant
https://www.vagrantup.com/

Vagrant-hostmanager
vagrant plugin install vagrant-hostmanager

VirtualBox
https://www.virtualbox.org/wiki/VirtualBox
Git
https://git-scm.com/book/en/v2/Getting-Started-Installing-Git


```
# Install VirtualBox 5 or later.
# Install Vagrant 1.8.1 or later.
git clone https://github.com/iandr413/vagrant-spark
cd spark
ln -sf profiles/spark-lab.profile current.profile
vagrant up
# When that finishes, open http://192.168.59.11:8080 or vagrant ssh ambari-server
```

## Some details.

The currently running OS:
* CentOS 6


The currently supported projects:
* Ambari
* Ambari Views
* Flume
* HBase
* HDFS
* Hive
* Hive 2
* Hive ODBC Client
* HiveServer 2
* Kafka
* MapReduce
* Oozie
* Pig
* Postgres
* Slider
* Spark
* Tez
* Wildfly (known better as JBoss)
* Yarn
* Zookeeper

## Modify the cluster

Structor supports profiles that control the configuration of the
virtual cluster.  

Some profile details:
* 3node-spark - a three node Hadoop cluster deployed via Ambari Blueprint
* Includes Kerberos,Hive,Spark


## Bring up the cluster

Use `vagrant up` to bring up the cluster. This will take 30 to 40 minutes for 
a 3 node cluster depending on your hardware and network connection.

Use `vagrant ssh server`` to login to the server machine. If you configured 
security, you'll need to kinit before you run any hadoop commands.

## Set up on Mac

### Add host names

in /etc/hosts:
```
192.168.59.11 server.example.com
192.168.59.12 slave1.example.com
192.168.59.13 slave2.example.com
```


### Set up Kerberos (for security)

in /etc/krb5.conf:
```
[logging]
  default = FILE:/var/log/krb5libs.log
  kdc = FILE:/var/log/krb5kdc.log
  admin_server = FILE:/var/log/kadmind.log

[libdefaults]
  default_realm = EXAMPLE.COM
  dns_lookup_realm = false
  dns_lookup_kdc = false
  ticket_lifetime = 24h
  renew_lifetime = 7d
  forwardable = true
  udp_preference_limit = 1

[realms]
  EXAMPLE.COM = {
    kdc = server.example.com
    admin_server = server.example.com
  }

[domain_realm]
  .example.com = EXAMPLE.COM
  example.com = EXAMPLE.COM
```

You should be able to kinit to your new domain (user: vagrant and 
password: vagrant):

```
% kinit vagrant@EXAMPLE.COM
```
### Set up KDC and KDC Admin to enable Kerberos in Ambari

-Create the Kerberos Database

Use the utility kdb5_util to create the Kerberos database.

RHEL/CentOS/Oracle Linux

kdb5_util create -s


-Start the KDC

Start the KDC server and the KDC admin server.

RHEL/CentOS/Oracle Linux 6

/etc/rc.d/init.d/krb5kdc start

/etc/rc.d/init.d/kadmin start


***[Important]	Important
When installing and managing your own MIT KDC, it is very important to set up the KDC server to auto-start on boot. For example:

RHEL/CentOS/Oracle Linux 6

chkconfig krb5kdc on

chkconfig kadmin on


-Create a Kerberos Admin

Kerberos principals can be created either on the KDC machine itself or through the network, using an “admin” principal. The following instructions assume you are using the KDC machine and using the kadmin.local command line administration utility. Using kadmin.local on the KDC machine allows you to create principals without needing to create a separate "admin" principal before you start.

***[Note]	Note
You will need to provide these admin account credentials to Ambari when enabling Kerberos. This allows Ambari to connect to the KDC, create the cluster principals and generate the keytabs.

Create a KDC admin by creating an admin principal.

kadmin.local -q "addprinc admin/admin"

-Confirm that this admin principal has permissions in the KDC ACL. Using a text editor, open the KDC ACL file:

RHEL/CentOS/Oracle Linux

vi /var/kerberos/krb5kdc/kadm5.acl


-Ensure that the KDC ACL file includes an entry so to allow the admin principal to administer the KDC for your specific realm. When using a realm that is different than EXAMPLE.COM, be sure there is an entry for the realm you are using. If not present, principal creation will fail. For example, for an admin/admin@HADOOP.COM principal, you should have an entry:

*/admin@HADOOP.COM *

After editing and saving the kadm5.acl file, you must restart the kadmin process.

RHEL/CentOS/Oracle Linux 6

/etc/rc.d/init.d/kadmin restart




### Set up browser (for security)

Do a `/usr/bin/kinit vagrant` in a terminal. I've found that the browsers
won't use the credentials from MacPorts' kinit. 

Safari should just work.

Firefox go to "about:config" and set "network.negotiate-auth.trusted-uris" to 
".example.com".

Chrome needs command line parameters on every start and is not recommended.
