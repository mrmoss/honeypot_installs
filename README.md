Some scripts to install on a VPS to make a honeypot.

	You probably want to edit /etc/ssh/sshd_config and change the port from 22 to something like 60022.
	You should do this BEFORE you run this script.

	You also probably want to change your apache site entry from :80 to :60080.
	You probably want to do this BEFORE you install dionaea.

	If you take the suggestions above, you should probably firewall the above ports off.
	Ports should probably only be accessable via another machine.

	The dionaea script is completly automated.
	The kippo requires 1 bit of user information, 3 times.
	This bit is the mysql root password (to create the kippo database).

	I recommend installed kippo BEFORE dionaea.
