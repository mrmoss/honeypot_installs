Some scripts to install on a VPS to make a honeypot.

	You probably want to edit /etc/ssh/sshd_config and change the port from 22 to something like 60022.
	You should do this BEFORE you run this script.

	You also probably want to change your apache config and site entry from :80 to :60080.
	Probably :443 to :60443 as well.
	You probably want to do this BEFORE you install dionaea.

	If you take the suggestions above, you should probably firewall the above ports off.
	Ports should probably only be accessable via another machine.

	The dionaea script is completly automated.
	The kippo requires 1 bit of user information, 3 times.
	This bit is the mysql root password (to create the kippo database).

	I recommend installing kippo BEFORE dionaea.

	If you want the honeypots to start at boot,
	chmod +x /etc/rc.local and add the following to /etc/rc.local:
		cd /opt/DionaeaFR && ./start.sh 2>&1 > /dev/null &
		cd /opt/kippo/ && sudo -u www-data ./start.sh 2>&1 > /dev/null &

	WOF Firewall Rules (http://nullify.cc/wof):
		default <> pass
		tcp any:58080<HP_IP pass
		tcp any:58080<any deny
		tcp any:60022<HP_IP pass
		tcp any:60022<any deny
		tcp any:60080<HP_IP pass
		tcp any:60080<any deny
