#!/bin/bash

START_PORT=11093

daemon_name=daemon
path=$0
if [ -L $path ]; then
    path=`readlink $path`
fi
work_dir=`dirname $path`

_do_check_port() {
    if [[ -z $START_PORT ]]; then
        echo "服务端口不能为空"
        exit 1
    fi
    local start_proc_pid=$(lsof -i:$START_PORT|awk '$10 ~/LISTEN/{print $2}')
    if [[ ! -z ${start_proc_pid} ]]; then
	echo "服务端口 [${START_PORT}] 被进程 [${start_proc_pid}] 占用"
	exit 1
    fi
}

_do_start() {
    _do_check_port
    
    deps_lib_classpath=""
    deps=$work_dir/lib/*.jar;
    for dep in $deps; do
	deps_lib_classpath=$deps_lib_classpath:$dep;
    done
    export CLASSPATH=$CLASSPATH:$deps_lib_classpath;
    
    if [[ -z $JAVA_HOME ]]; then
	echo "JAVA_HOME 为空, 设置环境变量: export JAVA_HOME=java安装目录"
    fi
    nohup $JAVA_HOME/bin/java hello.Application $START_PORT 2>$work_dir/logs/$daemon_name.err 1>/dev/null &
    echo $! > $work_dir/$daemon_name.pid
    echo "服务启动 pid: $!"
    local start_time=`date "+%Y-%m-%d %H:%M:%S"`
    echo "启动时间为:$start_time" >> $work_dir/$daemon_name.history
}

_do_rm_pid() {
    rm -rf $work_dir/$daemon_name.pid	
}

_do_status() {
    if [[ -f $work_dir/$daemon_name.pid ]]; then
        local stop_pid=`cat $work_dir/$daemon_name.pid`
        local not_stoped=$(ps aux|grep -v "grep"|grep $stop_pid)
        if [[ $not_stoped ]]; then
            echo "服务正在运行"
        else
            echo "服务已经关闭"
        fi
    else
        echo "服务未运行"
    fi
}

_do_stop() {
    local stop_pid=`cat $work_dir/$daemon_name.pid`
    echo "关闭服务 "
    kill $stop_pid
    local not_stoped=$(ps aux|grep -v "grep"|grep $stop_pid)
    if [[ $not_stoped ]]; then
        sleep 10
    fi
    not_stoped=$(ps aux|grep -v "grep"|grep $stop_pid)
    if [[ $not_stoped ]]; then
        echo "未关闭成功, 强制关闭"
        kill -9 $stop_pid 
        sleep 10
        not_stoped=$(ps aux|grep -v "grep"|grep $stop_pid)
        if [[ $not_stoped ]]; then
            echo "强制关闭失败，请手动解决 pid: $stop_pid"
        else
            _do_rm_pid	
        fi
    else
    	_do_rm_pid
    fi
}

case $1 in
    start)
	_do_start
	;;
    restart)
	_do_stop
        _do_start    
	;;
    stop)
        _do_stop
	;;
    *)
	echo "Usage: $0 [start|restart|stop]"
	;;
esac
