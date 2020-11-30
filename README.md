# LVS-DR模式

#### 介绍
使用脚本一键部署LVS-DR使用了两台centos7，一台作为Director Server同时也作为Real Server,一台作为Real Server

#### 软件架构
软件架构说明
所有集群节点RS和DS在相同的网段
在RS上的lo网卡上绑定VIP，同时在RS做ARP抑制
#### 安装教程

1.  前提安装了ipvsadm，这个是LVS的核心
2.  安装了net-tools这个网络工具


#### 使用说明

1.  在RS上执行lvs_DR_realserver.sh
2.  在DS上执行lvs_DR_dirserver.sh

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request



