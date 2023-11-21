# webBenchmark
webBenchmark网络基准测试，网站性能测试，网站测压，剑皇


webBenchmark 是一个用于测试网页服务器性能的工具，启用其他用途，后果自负。
原作者的一键脚本支持的系统、架构有限，为了让所有的系统、架构都支持 webBenchmark ，所以本文采用编译的方法，直接编译到你自己的系统、架构里面，做到让所有系统、架构均可以进行 webBenchmark 测试。

一键脚本执行：

手动执行：

第一步：安装 Git 和 Golang


yum install git golang  #CentOS

apt install git golang  #Debian/Ubuntu

pkg install git golang  #Termux

第二步：安装 screen 避免任务被系统杀死


apt-get install screen #安装screen

screen -S webBenchmark #创建一个名为 webBenchmark 的窗口任务，命名可以自定义


第三步：编译架构

git clone https://github.com/maintell/webBenchmark.git

cd webBenchmark

go build


第四步：赋予权限，直接开搞（注意替换 url，线程数可根据 vps 性能替换）

chmod +x webBenchmark

./webBenchmark -c 32 -s https://target.url &


第五步：如果不想刷了如何取消

方法一：没有安装 screen：
首先列出该进程，执行：

ps aux | grep webBenchmark

然后找出进程的 pid，执行：

kill -9 pid

方法二：安装了 screen 并且在 screen 窗口任务中运行

screen -ls #获取当前任务

screen -r webBenchmark #回到这个任务

screen -d webBenchmark #关闭这个任务

注意，此时只是关闭了 screen 窗口任务，并没有停止咱们的 webBenchmark 任务
列出该进程，执行：

ps aux | grep webBenchmark

然后找出进程的 pid，执行：

kill -9 pid

