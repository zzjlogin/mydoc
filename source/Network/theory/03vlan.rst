
=====================================================
vlan学习
=====================================================




`vlan百度百科 <https://baike.baidu.com/item/%E8%99%9A%E6%8B%9F%E5%B1%80%E5%9F%9F%E7%BD%91/419962?fromtitle=VLAN&fromid=320429&fr=aladdin>`_
`vlan维基百科 <https://zh.wikipedia.org/zh/%E8%99%9A%E6%8B%9F%E5%B1%80%E5%9F%9F%E7%BD%91>`_


参考的RFC文档：
    `rfc3069`_ ：vlan聚合相关
    `rfc6329`_ :
    `rfc2922`_ :
    `wireshark-vlan`_ :用wireshark分析vlan

.. _wireshark-vlan :https://wiki.wireshark.org/VLAN

.. _rfc3069 :https://www.rfc-editor.org/rfc/rfc3069.txt
.. _rfc6329 :https://www.rfc-editor.org/rfc/rfc6329.txt

.. rfc2922 :https://www.rfc-editor.org/rfc/rfc2922.txt


802.1Q文档: http://w3.tmit.bme.hu/courses/onlab/library/standards/802-1Q-2003.pdf


vlan的作用是分割广播域。但是vlan是二层协议。在设备配置vlan以后，在数据进行二层转发时需要匹配mac地址的时候需要先匹配对应vlan的mac地址表项。

不同的vlan有不同的mac地址表，所以完成了数据的二层隔离。

vlan是在介入层接收数据后在数据前面添加vlan标签。


Access端口：
    交换机上连接用户主机的端口，只能连接接入链路。Access端口只属于一个Vlan，且仅向该Vlan转发数据帧。该Vlan的Vid = 端口PVid，故Vlan内所有端口都处于untagged状态。Access端口在从主机接收帧时，给帧加上Tag标签；在向主机发送帧时，将帧中的Tag标签剥掉。
Trunk端口：
    交换机上与其他交换机或路由器连接的端口，只能连接汇聚链路。Trunk端口允许多个Vlan的带标签帧通过，在收发帧时保留Tag标签。在它所属的这些Vlan中，对于Vid = 端口PVid的Vlan，它处于Untagged port状态；对于Vid ≠ 端口PVid的Vlan，它处于Tagged port状态。
Hybrid端口：
    交换机上既可连接用户主机又可连接其他交换机的端口，它既可连接接入链路又可连接汇聚链路。Hybrid 端口允许多个Vlan的帧通过，并可在出端口方向将某些Vlan帧的Tag标签剥掉。




