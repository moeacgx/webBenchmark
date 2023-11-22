#!/bin/bash

# 保存当前目录
current_dir=$(pwd)

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
            # 检查webBenchmark是否正在运行
            if pgrep -f "webBenchmark" > /dev/null
            then
                echo "webBenchmark is already running. Please stop it first."
                continue
            fi

            # 检查并安装 Git 和 Golang
            for pkg in git golang screen
            do
                if ! command -v $pkg &> /dev/null
                then
                    if [[ -x "$(command -v apt-get)" ]]; then
                        sudo apt-get install -y $pkg
                    elif [[ -x "$(command -v yum)" ]]; then
                        sudo yum install -y $pkg
                    elif [[ -x "$(command -v dnf)" ]]; then
                        sudo dnf install -y $pkg
                    elif [[ -x "$(command -v pkg)" ]]; then
                        sudo pkg install -y $pkg
                    else
                        echo "Unsupported package manager."
                        exit 1
                    fi
                fi
            done

            # 编译架构
            git clone https://github.com/maintell/webBenchmark.git
            cd webBenchmark
            if ! go build; then
                echo "Failed to build webBenchmark"
                exit 1
            fi

            # 赋予权限
            chmod +x webBenchmark

            # 提供一个用户键入 url 的界面
            read -p "请输入您要测试的 url：" url

            # 直接开搞
            screen -S webBenchmarkSession -dm bash -c "./webBenchmark -c 32 -s $url"

            echo "webBenchmark 已经开始运行，您可以按 Ctrl+A+D 退出 screen 窗口任务，或者输入 2 停止运行 webBenchmark"
            ;;
        2)
            # 检查webBenchmark是否正在运行
            if ! pgrep -f "webBenchmark" > /dev/null
            then
                echo "webBenchmark is not running."
                continue
            fi

            # 回到 screen 窗口任务
            screen -r webBenchmarkSession

            # 关闭当前 screen 窗口
            screen -X -S webBenchmarkSession quit

            # 获取所有名为"webBenchmark"的进程的PID，并逐个杀死
            pids=$(pgrep -f "webBenchmark")
            for pid in $pids
            do
                kill -9 $pid
            done

            echo "webBenchmark 已经停止运行，您可以输入 3 退出脚本"
            ;;
        3)
            # 退出脚本并回到root目录
            echo "感谢您使用一键命令脚本，再见！"
            running=false
            cd $current_dir
            break
            ;;
        *)
            # 输入错误
            echo "您输入的选择不正确，请重新输入"
            ;;
    esac
done
