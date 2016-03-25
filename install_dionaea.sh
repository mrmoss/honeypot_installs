#!/bin/bash
install_dir="/opt/"
run_user="www-data"

#Install Dionaea
add-apt-repository ppa:honeynet/nightly -y
apt-get update -y
apt-get install software-properties-common python-software-properties dionaea-phibo -y
service dionaea-phibo start
service rsyslog stop
sed -i -e 's/^\$ModLoad imklog/#\$ModLoad imklog/g' /etc/rsyslog.conf
service rsyslog start

#Install DionaeaFR
rm -rf "$install_dir/DionaeaFR/"
apt-get install python-pip python-netaddr build-essential python-dev git unzip -y
pip install Django==1.4.2
pip install pygeoip
pip install django-pagination==1.0.7
pip install django-tables2==0.15.0
pip install django-compressor==1.4
pip install django-htmlmin==0.7.0
pip install django-filter==0.7
rm -rf "$install_dir/django-tables2-simplefilter-master"
rm -rf "$install_dir/django-tables2-simplefilter"
rm -rf "$install_dir/django-tables2-simplefilter.zip"
wget https://github.com/benjiec/django-tables2-simplefilter/archive/master.zip -O "$install_dir/django-tables2-simplefilter.zip"
unzip "$install_dir/django-tables2-simplefilter.zip" -d "$install_dir"
mv "$install_dir/django-tables2-simplefilter-master" "$install_dir/django-tables2-simplefilter"
rm -rf "$install_dir/django-tables2-simplefilter.zip"
cd "$install_dir/django-tables2-simplefilter" && python setup.py install
rm -rf "$install_dir/pysubnettree-master"
rm -rf "$install_dir/pysubnettree"
rm -rf "$install_dir/pysubnettree.zip"
wget https://github.com/bro/pysubnettree/archive/master.zip -O "$install_dir/pysubnettree.zip"
unzip "$install_dir/pysubnettree.zip" -d "$install_dir"
mv "$install_dir/pysubnettree-master" "$install_dir/pysubnettree"
rm -rf "$install_dir/pysubnettree.zip"
cd "$install_dir/pysubnettree" && python setup.py install
rm -rf "$install_dir/node-v0.10.33"
rm -rf "$install_dir/node.tar.gz"
wget http://nodejs.org/dist/v0.10.33/node-v0.10.33.tar.gz -O "$install_dir/node.tar.gz"
tar xzvf "$install_dir/node.tar.gz" -C "$install_dir"
rm -rf "$install_dir/node.tar.gz"
cd "$install_dir/node-v0.10.33" && ./configure && make && make install
npm install -g less
rm -rf "$install_dir/DionaeaFR-master"
rm -rf "$install_dir/DionaeaFR"
rm -rf "$install_dir/DionaeaFR.zip"
wget https://github.com/RootingPuntoEs/DionaeaFR/archive/master.zip -O "$install_dir/DionaeaFR.zip"
unzip "$install_dir/DionaeaFR.zip" -d "$install_dir"
mv "$install_dir/DionaeaFR-master" "$install_dir/DionaeaFR"
rm -rf "$install_dir/DionaeaFR.zip"
rm -rf "$install_dir/GeoLiteCity.dat.gz"
rm -rf "$install_dir/GeoIP.dat.gz"
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -O "$install_dir/GeoLiteCity.dat.gz"
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz -O "$install_dir/GeoIP.dat.gz"
gunzip -c "$install_dir/GeoLiteCity.dat.gz" > "$install_dir/DionaeaFR/DionaeaFR/static/GeoLiteCity.dat"
gunzip -c "$install_dir/GeoIP.dat.gz" > "$install_dir/DionaeaFR/DionaeaFR/static/GeoIP.dat"
rm -rf "$install_dir/GeoLiteCity.dat.gz"
rm -rf "$install_dir/GeoIP.dat.gz"
rm -rf "$install_dir/DionaeaFR/manage.py.tmp"
cat "$install_dir/DionaeaFR/manage.py" | sed "s/pidfile = \"\/var\/run\/dionaeafr\/dionaeafr.pid\"/pidfile = \"\/opt\/DionaeaFR\/dionaeafr.pid\"/g;" > "$install_dir/DionaeaFR/manage.py.tmp"
mv "$install_dir/DionaeaFR/manage.py.tmp" "$install_dir/DionaeaFR/manage.py"
cp "$install_dir/DionaeaFR/DionaeaFR/settings.py.dist" "$install_dir/DionaeaFR/DionaeaFR/settings.py"
echo "#!/bin/bash" > "$install_dir/DionaeaFR/start.sh"
echo "python manage.py collectstatic --noinput" >> "$install_dir/DionaeaFR/start.sh"
echo "python manage.py runserver 0.0.0.0:58080" >> "$install_dir/DionaeaFR/start.sh"
chmod +x "$install_dir/DionaeaFR/start.sh"
chown -R $run_user:$run_user "$install_dir/DionaeaFR/"

#Start Dionaea
cd "$install_dir/DionaeaFR" && "./start.sh" 2>&1 > /dev/null &
