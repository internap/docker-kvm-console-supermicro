#!/bin/bash	

export EXPRESSION="listener exit due to --idle-timeout"
export LOG_FILE="/var/log/supervisor/novnc.log"

_activity_watcher_main() {
	local status=0

	if [ -f "${LOG_FILE}" ] ; then
		local idle_count=$( grep -c "${EXPRESSION}" "${LOG_FILE}" ) || return ${?}
		if [ "0" = "${idle_count}" ] ; then
			_activity_watcher_out "novnc is running"
		else
			_activity_watcher_out "novnc idled out."
			status=${idle_count}
		fi
	else
		_activity_watcher_out "novnc log to watch"
	fi

	# may need see uptime or check the log...
	local java_count=$( ps -ef | grep -v grep | grep -c 'java ' )
	if [ "0" = "${java_count}" ] ; then
		_activity_watcher_out "java is not running"
		let status=${status}+1000
	else
		_activity_watcher_out "java is running...."
	fi

	return ${status}
}

_activity_watcher_out() {
	echo -n "${*} ; "
}

_activity_watcher_main ${*}
