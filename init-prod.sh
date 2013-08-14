# chkconfig: 2345 95 20
# description: statsd
# processname: node

NODE_PATH='/usr/lib/node_modules'
export NODE_PATH

# Establish our log and run files for the app.
logfile=/var/log/statsd.log
pidfile=/var/run/statsd.pid
name="StatsD"

# Check to see if the run file already exists.  If it does, check to see if the PID in the
# file is an actual running process.  Otherwise, don't set anything.
if [ -f "$pidfile" ]; then
    pid=`cat $pidfile`
    running=`ps p $pid | wc -l`
    if [ $running -eq 1 ]; then
        pid=
    fi
else
    pid=
fi

case $1 in
    start)
        if [ "$pid" = "" ]; then
            echo "Starting $name..."
            nohup /usr/bin/node /usr/local/statsd/stats.js /etc/statsd.conf 2>&1 1>>$logfile &
            echo $! > $pidfile
        fi
        $0 status
        ;;
    stop)
        if [ "$pid" = "" ]; then
            echo "Service not running"
            exit 7
        else
            echo "Stopping $name..."
            kill $pid
        fi
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    status)
        if [ "$pid" = "" ]; then
            echo "Stopped"
            exit 3
        else
            echo "Running with PID $pid"
            exit 0
        fi
        ;;
    *)
        echo $0 "stop|start|restart|status"
        ;;
esac
