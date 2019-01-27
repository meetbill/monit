---
layout: post
title:
subtitle:
date: 2019-01-26 23:50:38
category:
author: meetbill
tags:
   -
---

## monit_control.sh

<!-- vim-markdown-toc GFM -->

* [1 需重写初始化配置](#1-需重写初始化配置)
* [2 使用](#2-使用)

<!-- vim-markdown-toc -->
## 1 需重写初始化配置
```
function init_config()
{
    # init_config
    bash ./scripts/init_config.sh
}
```
## 2 使用
```
Usage: monit_control.sh {start|stop|restart|status}
 init           Init monit configfile.
 start          Start monit processes.
 stop           Kill all monit processes.
 restart        Kill all monit processes and start again.
 status         Show monit processes status.
 monit action   exe monit action
 version        Show monit_control.sh script version.
```
> * bash monit_control.sh init         # 初始化 monit 配置
> * bash monit_control.sh start        # 启动 monit
> * bash monit_control.sh stop         # 关闭 monit
> * bash monit_control.sh restart      # 重启 monit
> * bash monit_control.sh status       # 查看 monit 运行状态
> * bash monit_control.sh version      # 查看 monit_control.sh 版本
> * bash monit_control.sh monit action # 执行 monit action,可以 bash monit_control.sh monit -h 查看帮助信息
