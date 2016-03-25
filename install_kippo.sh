#!/bin/bash
install_dir="/opt/"
kippo_port="22"
kippo_user="www-data"
mysql_user="kippo"
mysql_pass="kippo"
apache_web_dir="/var/www/html"
apache_user="www-data"

#Install Kippo
rm -rf /etc/authbind/byport/$kippo_port
rm -rf "$install_dir/kippo/"
rm -rf "$install_dir/kippo/start.sh"
apt-get update -y
apt-get install python-dev openssl python-openssl python-pyasn1 python-twisted subversion authbind -y
touch "/etc/authbind/byport/$kippo_port"
chmod 777 "/etc/authbind/byport/$kippo_port"
svn checkout http://kippo.googlecode.com/svn/trunk/ "$install_dir/kippo/"
cat "$install_dir/kippo/kippo.cfg.dist"|sed "s/ssh_port = 2222/ssh_port = $kippo_port/g">"$install_dir/kippo/kippo.cfg"
echo "#!/bin/bash" > "$install_dir/kippo/start.sh"
echo "echo -n 'Starting kippo in background...'" >> "$install_dir/kippo/start.sh"
echo "authbind --deep twistd -y $install_dir/kippo/kippo.tac -l $install_dir/kippo/log/kippo.log --pidfile $install_dir/kippo/kippo.pid" >> "$install_dir/kippo/start.sh"
chmod +x "$install_dir/kippo/start.sh"
chown $kippo_user:$kippo_user "/etc/authbind/byport/$kippo_port"
chown -R $kippo_user:$kippo_user "$install_dir/kippo/"

#Install Kippo Graph
rm -rf "$install_dir/kippo-graph/"
rm -rf "$install_dir/kippo-graph-master/"
rm -rf "$install_dir/kippo-graph.zip"
rm -rf "$install_dir/kippo-graph/config.php.tmp"
rm -rf "$apache_web_dir/kippo-graph"
apt-get install apache2 python-mysqldb mysql-server libapache2-mod-php5 php5-gd php5-mysql unzip -y
service apache2 restart
echo "Need MySQL root password."
mysql -u root -p -e "DROP DATABASE IF EXISTS kippo;CREATE DATABASE kippo;GRANT ALL ON kippo.* TO '$mysql_user'@'localhost' IDENTIFIED BY '$mysql_pass';"
echo "Need MySQL $mysql_pass password."
mysql -u"$mysql_user" -p"$mysql_pass" -e "USE kippo;source $install_dir/kippo/doc/sql/mysql.sql;"
cat "$install_dir/kippo/kippo.cfg"    |sed "s/\#\[database_mysql\]/\[database_mysql\]/g">"$install_dir/kippo/kippo.cfg.tmp"
cat "$install_dir/kippo/kippo.cfg.tmp"|sed "s/#host = localhost/host = localhost/g">"$install_dir/kippo/kippo.cfg"
cat "$install_dir/kippo/kippo.cfg"    |sed "s/#database = kippo/database = kippo/g">"$install_dir/kippo/kippo.cfg.tmp"
cat "$install_dir/kippo/kippo.cfg.tmp"|sed "s/#username = kippo/username = $mysql_user/g">"$install_dir/kippo/kippo.cfg"
cat "$install_dir/kippo/kippo.cfg"    |sed "s/#password = secret/password = $mysql_pass/g">"$install_dir/kippo/kippo.cfg.tmp"
cat "$install_dir/kippo/kippo.cfg.tmp"|sed "s/#port = 3306/port = 3306/g">"$install_dir/kippo/kippo.cfg"
rm "$install_dir/kippo/kippo.cfg.tmp"
wget https://github.com/ikoniaris/kippo-graph/archive/master.zip -O "$install_dir/kippo-graph.zip"
unzip "$install_dir/kippo-graph.zip" -d "$install_dir/"
mv "$install_dir/kippo-graph-master/" "$install_dir/kippo-graph"
cat "$install_dir/kippo-graph/config.php.dist"|sed "s/define('DB_USER', 'username');/define('DB_USER', '$mysql_user');/g">"$install_dir/kippo-graph/config.php"
cat "$install_dir/kippo-graph/config.php"     |sed "s/define('DB_PASS', 'password');/define('DB_PASS', '$mysql_pass');/g">"$install_dir/kippo-graph/config.php.tmp"
cat "$install_dir/kippo-graph/config.php.tmp" |sed "s/define('DB_NAME', 'database');/define('DB_NAME', 'kippo');/g">"$install_dir/kippo-graph/config.php"
rm -rf "$install_dir/kippo-graph/config.php.tmp"
rm -rf "$install_dir/kippo-graph.zip"
chown -R $apache_user:$apache_user "$install_dir/kippo-graph"
ln -s "$install_dir/kippo-graph" "$apache_web_dir/kippo-graph"

#Start Kippo
cd "$install_dir/kippo/" && sudo -u $kippo_user "./start.sh"