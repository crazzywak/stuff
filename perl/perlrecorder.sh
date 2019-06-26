#!/bin/bash

if [[ $1 == '--on' ]]; then
	echo 1 > /etc/opt/perlrecorder/record
	exit
elif [[ $1 == '--off' ]]; then
	echo 0 > /etc/opt/perlrecorder/record
	exit
elif [[ $1 == '-r' ]]; then
	if [ -f "/usr/bin/perlo" ]; then
		rm -f /usr/bin/perl
		mv /usr/bin/perlo /usr/bin/perl
		echo "Reverted"
	else
		echo "Nothing to revert"
	fi

	exit
fi

# Copy original perl if it's not copied
[ -f "/usr/bin/perlo" ] || cp /usr/bin/perl /usr/bin/perlo 

if [[ $1 == '-c' ]] ; then

# Calls only
/bin/cat <<EOM >/usr/bin/perl
#!/bin/bash

[ \$(cat /etc/opt/perlrecorder/record) = 0 ] && exec /usr/bin/perlo "\$@"

echo "\$(date +"%D %T") \$@" >> /tmp/perlrecorder/log
exec /usr/bin/perlo "\$@"
EOM

chmod --reference=/usr/bin/perlo /usr/bin/perl

echo "Recording calls to /tmp/perlrecorder/log"

elif [[ $1 == '-f' ]]; then

/bin/cat <<EOM >/usr/bin/perl
#!/bin/bash

[ \$(cat /etc/opt/perlrecorder/record) = 0 ] && exec /usr/bin/perlo "\$@"

white=0
black=0

echo "\$@" | grep -qf /etc/opt/perlrecorder/white && white=1
echo "\$@" | grep -qf /etc/opt/perlrecorder/black && black=1

if [[ \$white == 1 && \$black == 0 ]]
then
	echo "\$(date +"%D %T") \$@" >> /tmp/perlrecorder/log
	exec /usr/bin/perlo -d:Trace "\$@"	
else
	echo "\$(date +"%D %T") Filtered \$@" >> /tmp/perlrecorder/log
	exec /usr/bin/perlo "\$@"
fi
EOM

chmod --reference=/usr/bin/perlo /usr/bin/perl

echo -e "Recording everything to /tmp/perlrecorder/output/\nlog file in /tmp/perlrecorder/log"

else
	echo -e "-c to record calls\n-f to record run\n-r to revert"
fi

