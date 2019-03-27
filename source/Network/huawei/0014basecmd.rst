.. _network.huawei.basecmd:

======================================================================================================================================================
华为基础命令
======================================================================================================================================================


.. contents::


设置系统名称
======================================================================================================================================================


.. code-block:: text
    :linenos:

    <Huawei>sys
    Enter system view, return user view with Ctrl+Z.
    [Huawei]sysname sw1
    [sw1


设置系统时间
======================================================================================================================================================



.. code-block:: text
    :linenos:

    <sw1>dis time all
    Current time is 14:26:48 3-27-2019 Wednesday              
    Total time-range number is 0 

    <sw1>clock	
    <sw1>clock timezone BJ add 08:00:00
    <sw1>dis time all
    Current time is 06:27:45 3-28-2019 Thursday               
    Total time-range number is 0 

    <sw1>clock datetime 14:29:00 2019-03-27
    <sw1>dis time all
    Current time is 14:29:08 3-27-2019 Wednesday              
    Total time-range number is 0 


设置标题信息
======================================================================================================================================================

.. code-block:: text
    :linenos:

    <sw1>sys
    Enter system view, return user view with Ctrl+Z.

    [sw1]header login information 'nihao'
    [sw1]header shell information "welcome to this dev"

保存配置
======================================================================================================================================================

.. code-block:: text
    :linenos:

    <sw1>save
    The current configuration will be written to the device.
    Are you sure to continue?[Y/N]y









