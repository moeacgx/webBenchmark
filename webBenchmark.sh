#!/bin/bash

# 切换到root目录
cd

echo "欢迎使用一键命令脚本，您可以选择以下操作："

running=true

while $running
do
    echo "1. 开始运行 webBenchmark"
    echo "2. 停止运行 webBenchmark"
    echo "3. 退出脚本"
    
    read -p "请输入您的选择（1/2/3）：" choice
    
    case $choice in
        1)
            # 安装 Git 和 Golang
            yum install git golang || apt install git golang || dnf install screen || pkg install git golang
            # 安装 screen 避免任务被系统杀死
            apt-get install screen || yum install screen || dnf install screen || pkg install screen
            # 编译架构
            git clone https://github.com/maintell/webBenchmark.git
            cd webBenchmark
            go build
            # 赋予权限
            chmod +x webBenchmark
            # 提供一个用户键入 url 的界面
            read -p "请输入您要测试的 url：" url
            # 直接开搞
            screen -S webBenchmarkSession -dm bash -c "./webBenchmark -c 32 -s $url"
            echo "webBenchmark 已经开始运行，您可以按 Ctrl+A+D 退出 screen 窗口任务，或者输入 2 停止运行 webBenchmark"
            ;;
        2)
            # 回到 screen 窗口任务
            screen -r webBenchmarkSession
            # 获取所有名为"webBenchmark"的进程的PID，并逐个杀死
            pids=$(pgrep -f "webBenchmark")
            for pid in $pids
            do
                killall -9 webBenchmark
            done
            echo "webBenchmark 已经停止运行，您可以输入 3 退出脚本"
            ;;
        3)
            # 退出脚本并回到root目录
            echo "感谢您使用一键命令脚本，再见！"
            running=false
            cd
            break
            ;;
        *)
            # 输入错误
            echo "您输入的选择不正确，请重新输入"
            ;;
    esac
done
