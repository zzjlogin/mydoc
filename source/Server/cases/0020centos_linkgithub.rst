.. _linkgithub_centos:

======================================================================================================================================================
CentOS系统文件推送到github指定库中
======================================================================================================================================================

:Date: 2019-03

.. contents::


问题描述
======================================================================================================================================================

1. 阿里云香港节点的云主机，突然IP被封。国内不能直接ssh连接。
2. CentOS7系统，云主机可以访问国内网站，且可以访问github。
3. 云主机运行了很长时间。里面有数据。且云主机没有高效云盘，只有系统盘。
4. 云主机数据需要临时导出到本地使用。


问题分析
======================================================================================================================================================


这个情况解决方法很多，例如：
    - 如果有阿里云国内的云主机。可以把数据推送到国内阿里云(其他云提供商可以测试)主机。然后通过国内云主机为跳板然后下载数据。
    - 通过一些其他平台，然后把数据推送到这个平台，然后再下载到本地。

经过考虑经济费用。所以选择把数据推送到github，然后下载下来。


CentOS系统数据文件推送github配置
======================================================================================================================================================

方法说明：
    - 本地需要有centos虚拟机
    - 









