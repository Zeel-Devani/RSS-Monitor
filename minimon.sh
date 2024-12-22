#!/bin/bash

get_rss_usage()
{
	local username=$1
	
	# Find List of all processes
	local ps_output=$(ps aux)

	# Filter the lines for the given username
	local user_process=$(echo "$ps_output" | awk -v user="$username" '$1 == user')

	# Extract the RSS values from column 6
	local rss_values=$(echo "$user_process" | awk '{print $6}')

	# Filter for numeric RSS values
	local numeric_rss=$(echo "$rss_values" | grep -E '^[0-9]+$')
	
	# Echo the final RSS values
	echo "$numeric_rss"
}


combine_rss_usage()
{
	local username=$1
	
	# Get RSS values using get_rss_usage
	local rss_values=$(get_rss_usage "$username")	

	local total=0

	if [ -z "$rss_values" ]; then
		echo "ERROR: No RSS values found for user $username."
		exit 1
	fi

	# Loop through each RSS value
	for rss in $rss_values; do
		total=$((total + rss))
	done
	
	# Echo the total sum
	echo "$total"
}


find_largest_rss()
{
	local username=$1

	# Get RSS values for the user using get_rss_usage
	local rss_values=$(get_rss_usage "$username")

	if [ -z "$rss_values" ]; then
		echo "ERROR: No RSS values found for user $username"
		exit 1
	fi

	local largest=0

	# Loop through each rss value and compare each
	for rss in $rss_values; do
		if [ "$rss" -gt "$largest" ]; then
			largest=$rss
		fi
	done
	
	# Echo largest value
	echo "$largest"
}

main()
{
	# Main function
	local username=$1
	local threshold=$2

	# Checks if username is provided
	if [ -z "$username" ]; then
		echo "ERROR: username is required"
		exit 1
	fi

	# Checks if threshold is provided
	if [ -z "$threshold" ]; then
		echo "ERROR: threshold is required."
		exit 1
	fi
	
	# Get total RSS and largest RSS
	rss_values=$(get_rss_usage "$username")

	if [ -z "$rss_values" ]; then
		echo "ERROR: Failed to get RSS usage for user $username."
		exit 1
	fi
	
	total_rss=$(combine_rss_usage "$username")
	peak_rss=$(find_largest_rss "$username")

	# Echo total RSS
	echo "$username: $total_rss $peak_rss"

	# Alert for Total and Peak
	if [ "$total_rss" -gt "$threshold" ]; then
		echo "ALERT: $username: exceeded RSS threshold ($total_rss total)" 1>&2
	fi

	# Check if peak exceeds the threshold
	if [ "$peak_rss" -gt "$threshold" ]; then
		echo "ALERT: $username: exceeded RSS threshold ($peak_rss peak)" 1>&2
	fi	
}

# Call the main function with the arguments
main "$@"

