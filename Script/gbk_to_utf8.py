#!/usr/bin/env python3

# txt文档批量从gbk转换为utf-8
import os
import re

pwd=os.walk(os.getcwd())
for a,b,c in pwd:
    for i in c:
        if re.search('.*\.txt$',i):
            file_FullPath=os.path.join(a,i)
            file_open=open(file_FullPath,'r',encoding='gbk')
            file_read=file_open.read()
            file_open.close()
            file_write=open(file_FullPath,'w',encoding='utf-8')
            file_write.write(file_read)
            file_write.close()