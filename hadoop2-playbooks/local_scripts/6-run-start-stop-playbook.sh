#!/bin/bash

# Purpose
# bash script to initiate the Ansible playbook to start or stop the cluster
# run as:  ./run-hadoop-1-start-stop-playbook.sh 1.2.1 start/stop


#########################################################################################################
# input testing
#########################################################################################################

# hadoop_ver parameter should be in the form a.b.c
# this will be used to create the installation directory, such as /opt/hadoop/a.b.c
# and a hadoop user for this specific version, such as hadoop_abc

# just basic sanity test to catch likely errors by say a tired user
# test for null
if [ -z "$1" ]; then
	echo "command line execution is mising hadoop version number"
	echo "eg. version 1.2.1 should be run as: ./<script-name>.sh 2.7.4"
	exit 1
fi

if [ -z "$2" ]; then
	echo "command line execution is missing a value of stop or start"
	echo "eg. version 2.7.4 should be run as: ./<script-name>.sh 2.7.4 start-or-stop-here"
	exit 1
fi

# get length of not null parameter
len=$(echo -n $1 | wc --chars)

# is it the correct length? eg. a.b.c
if [ $len -eq 5 ]; then
	# do nothing
	echo $0 > /dev/null
else
   	echo "hadoop_ver not of the form a.b.c"
	exit 1
fi

# okay, grab the vals and move on
a=$(echo -n $1 | cut -c1)
b=$(echo -n $1 | cut -c3)
c=$(echo -n $1 | cut -c5)

# test for proper stop/start value
if [[ "$2" != "start" && "$2" != "stop" ]]; then
	echo "invalid stop_start_cluster value"
	echo "stop_start_cluster=start or stop_start_cluster=stop"
	exit 1
fi

#########################################################################################################
# vars
#########################################################################################################

hadoop_ver="$a.$b.$c"
start_stop_cluster=$2
playbook_name=start-stop.yml
# default number of seconds to wait between starting daemons on each host
seconds_to_pause=5
extra_vars="hadoop_version=$hadoop_ver start_stop_cluster=$start_stop_cluster seconds_to_pause=$seconds_to_pause"

########################################################################################################
# code
########################################################################################################
ansible-playbook ../local_playbooks/$playbook_name --extra-vars "$extra_vars"
