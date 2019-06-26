#!/bin/bash

# Create directories
mkdir -p /etc/opt/perlrecorder/
mkdir -p /tmp/perlrecorder/output/
mkdir -p /opt/algosec/perl5/lib/perl5/Devel/

# Copy files
cp -f white /etc/opt/perlrecorder/
cp -f black /etc/opt/perlrecorder/
cp -f Trace.pm /opt/algosec/perl5/lib/perl5/Devel/
touch /etc/opt/perlrecorder/whitem

echo 1 > /etc/opt/perlrecorder/record

# Give permissions
chmod 777 /etc/opt/perlrecorder/black
chmod 777 /etc/opt/perlrecorder/white
chmod 777 /etc/opt/perlrecorder/whitem
chmod 777 /opt/algosec/perl5/lib/perl5/Devel/Trace.pm
chmod 777 /tmp/perlrecorder

echo "Installation finished"
