.. zzjlogin-git-install:

======================================
Gitb客户端安装
======================================


git安装
======================================

git下载安装
--------------------------------------

下载地址：https://git-scm.com/downloads

.. attention::
    这个 ``git``客户端提供服务的应该是亚马逊云，国内经常会出现下载特别慢或者下载不下来的情况。

下载以后的安装过程就和普通软件一样。一直下一步即可。

.. attention::
    安装完 ``git`` 客户端以后需要把git的路径加入到环境变量。

安装以后可以通过命令行使用git

测试安装结果
-------------------------------------

在window的命令提示符界面输入 ``git`` 会有如下提示信息，则说明安装及配置成功。

.. code-block:: text
    :linenos:

    C:\Users\Administrator>git
    usage: git [--version] [--help] [-C <path>] [-c <name>=<value>]
            [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
            [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]
            [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
            <command> [<args>]

    These are common Git commands used in various situations:

    start a working area (see also: git help tutorial)
    clone      Clone a repository into a new directory
    init       Create an empty Git repository or reinitialize an existing one

    work on the current change (see also: git help everyday)
    add        Add file contents to the index
    mv         Move or rename a file, a directory, or a symlink
    reset      Reset current HEAD to the specified state
    rm         Remove files from the working tree and from the index

    examine the history and state (see also: git help revisions)
    bisect     Use binary search to find the commit that introduced a bug
    grep       Print lines matching a pattern
    log        Show commit logs
    show       Show various types of objects
    status     Show the working tree status

    grow, mark and tweak your common history
    branch     List, create, or delete branches
    checkout   Switch branches or restore working tree files
    commit     Record changes to the repository
    diff       Show changes between commits, commit and working tree, etc
    merge      Join two or more development histories together
    rebase     Reapply commits on top of another base tip
    tag        Create, list, delete or verify a tag object signed with GPG

    collaborate (see also: git help workflows)
    fetch      Download objects and refs from another repository
    pull       Fetch from and integrate with another repository or a local branch
    push       Update remote refs along with associated objects

    'git help -a' and 'git help -g' list available subcommands and some
    concept guides. See 'git help <command>' or 'git help <concept>'
    to read about a specific subcommand or concept.














