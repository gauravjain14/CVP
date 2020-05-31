#!/bin/bash

usage() { echo "Usage: $0 [-f <comma-separated fetch-widths>] [-t <trace_file_name>] [-o <redirect-output>]" 1>&2; exit 1;}

while getopts ":f:t:o:d:" o; do
	case "${o}" in
		f)
			f=${OPTARG}
			IFS="," read -ra fetch_array <<< "$f"
			;;
		t)
			trace=${OPTARG}
			;;
		o)
			trace_out=${OPTARG}
			;;
		d)
			if [ ${OPTARG} -eq 1 ]; then
				perfect_cache="-d"
			fi
			;;
		*)
			usage
			;;
	esac
done

for w in "${fetch_array[@]}"
do
	echo "running cvp with fetch-width: ${w}"
	set -x
	./cvp -F ${w},0,0,0,0 ${perfect_cache} ${trace} >> ${trace_out}"_"${w}
	set +x
done

