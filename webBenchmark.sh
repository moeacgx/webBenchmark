#!/bin/bash

function install() {
    echo "正在安装Git、Golang和screen..."
    apt-get update
    apt-get install -y git golang screen
    echo "安装完成"
}

function start() {
    echo "请输入目标URL:"
    read url
    git clone https://github.com/maintell/webBenchmark.git
    cd webBenchmark
    go build
    chmod +x webBenchmark
    ./webBenchmark -c 32 -s $url &
    echo "webBenchmark已开始运行，目标URL为：$url"
}

function stop() {
    screen -r webBenchmark
    screen -d webBenchmark
    pid=$(ps aux | grep webBenchmark | grep -v grep | awk '{print $2}')
    if [ -n "$pid" ]; then
        kill -9 $pid
        echo "已停止webBenchmark进程，PID为：$pid"
    else
        echo "未找到webBenchmark进程"
    fi
}

install

echo "请选择操作："
echo "1. 开始运行"
echo "2. 停止运行"
read -p "请输入选项（1或2）：" option

case $option in
    1)
        start
        ;;
    2)
        stop
        ;;
    *)
        echo "无效的选项"
        ;;
esac
