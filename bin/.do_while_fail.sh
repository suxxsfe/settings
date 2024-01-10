if [ "$#" -ne 1 ]; then
	printf "need exactly 1 argument\n"
	exit 1
fi
eval $1
while [ "$?" -ne 0 ]; do
	printf "\n\nfail to execution, try agian...\n\n"
	eval $1
done
