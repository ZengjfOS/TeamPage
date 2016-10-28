# TeamPage

  * 主要目的是为了使Team成员有一个信息入口，这样每个人可以通过一个统一的域名访问到其他人的博客、Github账户等等相关信息；
  * 网站以Markdown文档开发，经MKDocs处理为静态页面，通过github.io发布，域名为[aplexos.com](http://aplexos.com/)；
  * 除了作为一个团队成员信息入口以外，还可以提供一些其他的功能，这些可以后续考虑加入；

# 使用方法

  * [参考Mkdocs官方使用说明](http://www.mkdocs.org/)
  * [安装mkdocs](http://www.mkdocs.org/#installation)
    * sudo apt-get install python-pip python-dev build-essential 
    * sudo pip install --upgrade pip 
    * sudo pip install --upgrade virtualenv 
    * pip install mkdocs
    * mkdocs --version
  * 查看[autorun.sh](autorun.sh)使用，最好能读懂脚本代码运行流程，目前所有的操作流程都放在了这个脚本中：

```
    autorun.sh [server][build][pushweb][pushpro]
       1. server: run as local server;
       2. build: build the mkdocs project to a static web site and it will remove hidden nav items;
       3. pushweb: push the static web site to github.io;
       4. pushpro: push the local mkdocs project to github repository.
```

  * 目前由于[hidden.py](tools/hidden.py)只能隐藏[mkdocs.yml](mkdocs.yml)文件中pages字段下的hidden导航条目，所以需要隐藏的md文件，写法要符合这种规范，如果又不清楚的地方，请参考项目的[mkdocs.yml](mkdocs.yml)写法:

```
    [省略内容...]
    pages:
    [省略内容...]
    - hidden :
        - hidden : 'Partners/zengsf/zengsf.md' 
        [这里添加要隐藏的md文件]
    [省略内容...]
```

  * 添加成员，需要完成如下内容：
    * 在docs/Partners/目录添加其自己的子目录，并以Markdown文档写自己的信息；
    * 在docs/index.md中添加引用；
    * 在mkdocs.yml声明md文件，如果不需要在导航栏中显示，请添加在hidden字段内。

# 项目搭建中遇到的问题

每个md文件都要mkdocs.yml文件中声明了才能在别的md文件中引用，不然会出现如下错误：

> Error: The page "index.md" contained a hyperlink to "*.md" which is not listed in the "pages" configuration.

如果在mkdocs.yml中的pages中声明，又会出现我们不想要的导航条目，因为并不是所有的md文件都要出现在导航栏中，以下是一份早期的mkdocs.yuml内容如下：

```
    site_favicon: os.ico
    site_name: AplexOS
    site_author: zengjf
    pages:
    - 主页 : 'index.md'
    - 推荐资源 :
        - 文章 : 'resource/articles.md'
        - 书籍 : 'resource/books.md'
    - Partners（随机排序）:
        - 覃左栋 : 'Partners/qinzd/qinzd.md'
        - 刘涛 : 'Partners/liutao/liutao.md'
        - 陈颖奇 : 'Partners/chenyq/chenyq.md'
        - 陈富林 : 'Partners/chenfl/chenfl.md'
        - 程梦真 : 'Partners/chengmz/chengmz.md'
        - 曾剑锋 : 'Partners/zengjf/zengjf.md'
    - hidden :
        - hidden : 'Partners/zengsf/zengsf.md' 
    theme: readthedocs
    copyright: 'Copyright © 2016 AplexOS'
```

如下是对应的导航栏，注意图片中的hidden相关的导航条目是我们不希望看到的：

![nohidden](images/navnohidden.png)

于是采用Python3写了一个html自动化处理文档[hidden.py](tools/hidden.py)，处理过程在[autorun.sh](autorun.sh)脚本中:

```shell
    if [ $1 == "build" ];then
        mkdocs build --strict
        for partner in `find * -name *.html`    # 查找所有的html文件
        do
            echo $partner
            ./tools/hidden.py $partner          # 移除需要hidden的导航部分
        done

        exit 0
    fi
```

如下图片中的导航栏是我们希望看到的，也是经过脚本处理后的最终效果：

![hidden](images/navhidden.png)
