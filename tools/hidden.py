#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright (c) 2016 - zengjf <zengjf42@163.com>

'''
需要删除的数据格式：
            <li>
    <ul class="subnav">
    <li><span>hidden</span></li>



    <li class="toctree-l1 ">
        <a class="" href="resource/articles/">hidden</a>

    </li>


    </ul>
<li>

'''

import re
import os
import sys

if __name__ == '__main__':

    if len(sys.argv) != 2 :
        print("usage: hidden <path to index.html file>")
        sys.exit(-1)

    readFile = open(sys.argv[1], "r+")
    writeFile = open("tmp.html", "w+")

    while 1:
        line = readFile.readline()
        if line.__len__() == 0:
            break

        if re.search(r'<li>', str(line)) != None:
            line1 = readFile.readline()

            if re.search(r'<ul class="subnav">', str(line1)) != None:
                line2 = readFile.readline()
                if re.search(r'<li><span>hidden</span></li>', str(line2)) != None:
                    while 1:
                        line = readFile.readline()
                        if re.search(r'</ul>', str(line)) != None:
                            line = readFile.readline()
                            if re.search(r'<li>', str(line)) != None:
                                break
                else:
                    writeFile.write(line)
                    writeFile.write(line1)
                    writeFile.write(line2)

            else:
                writeFile.write(line)
                writeFile.write(line1)

        else:
            writeFile.write(line)


    os.remove(sys.argv[1])
    os.rename("tmp.html", sys.argv[1])

