.. _zzjlogin_path:

======================================================================================================================================================
bat当面目录添加到环境变量
======================================================================================================================================================



添加系统环境变量：

通过修改注册表添加系统环境变量：

::

    set base_dir=%~dp0
    set BAT_HOME=%base_dir%
    setx /M BAT_HOME %base_dir%
    ::set PATH=%PATH%;%%BAT_HOME%%;
    set PATH=%PATH%;%BAT_HOME%;
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "Path" /t REG_EXPAND_SZ /d "%PATH%" /f

    ::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment

