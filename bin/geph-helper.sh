#!/bin/sh

# geph-help  
#
# Data 2023-09-18
# Help to connect to geph servers
#
#
# -h = help
# -u = username
# -p = password
# -f = free
# -p = p

find_username=""
find_password=""
find_help=0
error_code=0
mode=0                              # 1 for free, 2 for plus
error_argv_name=""

while getopts ':hu:p:fp' OPT; do
	case $OPT in
		h)
			find_help=1;;
		u)
			find_username="$OPTARG";;
		p)
			find_password="$OPTARG";;
		f)
			mode=1;;
		p)
			mode=2;;
		?)
			error_argv_name="\"$OPTARG\""
			error_code=1;;
	esac
done

if [ $find_help -eq 1 ]; then
	echo ""
	echo "USAGE:"
	echo "	geph-helper [options]"
	echo ""
	echo "options:"
	echo "	-h              show help"
	echo "	-u username     username"
	echo "	-p password     password"
	echo "	-f              only connect to servers for free account"
	echo "	-p              only connect to servers for plus account"
	echo ""
	echo ""

	exit 0
fi

if [ -z $find_username ] && [ $find_help -ne 1 ] && [ $error_code -eq 0 ]; then
	error_code=2;
fi
if [ -z $find_password ] && [ $find_help -ne 1 ] && [ $error_code -eq 0 ]; then
	error_code=3;
fi
if [ $error_code -ne 0 ]; then
	if [ $error_code -eq 1 ]; then
		echo "error: unexpected agrument $error_argv_name"
	fi
	if [ $error_code -eq 2 ]; then
		echo "error: need username"
	fi
	if [ $error_code -eq 3 ]; then
		echo "error: need password"
	fi

	echo ""
	echo ""
	echo "For more information try -h"
	echo ""
	echo ""
	exit 2
fi


server_name=""
if [ $mode -eq 0 ]; then
server_name=`geph4-client sync auth-password --username "$find_username" --password "$find_password" | \
	sed -E --posix "s/[^\.]*?hostname\":\"([0-9a-z\.-]*?)\"[^\.]*?allowed_levels\":\[([a-z\",]*?)\][^\.]*?load\":([0-9\.]*?)/\1 \2 \3\n/g" | \
	grep plus | sort -k3 | head -n1 | awk '{print($1)}'`
fi
if [ $mode -eq 1 ]; then      # free mode
server_name=`geph4-client sync auth-password --username "$find_username" --password "$find_password" | \
	sed -E --posix "s/[^\.]*?hostname\":\"([0-9a-z\.-]*?)\"[^\.]*?allowed_levels\":\[([a-z\",]*?)\][^\.]*?load\":([0-9\.]*?)/\1 \2 \3\n/g" | \
	grep plus | sort -k3 | grep free | head -n1 | awk '{print($1)}' `
fi
if [ $mode -eq 2 ]; then      # plus mode
server_name=`geph4-client sync auth-password --username "$find_username" --password "$find_password" | \
	sed -E --posix "s/[^\.]*?hostname\":\"([0-9a-z\.-]*?)\"[^\.]*?allowed_levels\":\[([a-z\",]*?)\][^\.]*?load\":([0-9\.]*?)/\1 \2 \3\n/g" | \
	grep plus | sort -k3 | grep -v free head -n1 | awk '{print($1)}'`
fi

if [ -z $server_name ]; then
	echo ""
	echo "error: could not get servers list"
	echo ""
	echo ""

	exit 1
fi

geph4-client connect --exit-server "$server_name" auth-password --username "$find_username" --password "$find_password"


