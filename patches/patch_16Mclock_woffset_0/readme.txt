修复bug：当用户选择16M clock的时候（sdk缺省32M），而且master连接参数里面的woffset=0，连接会失败。
Bug fix:when choose 16M clock(default is 32M),and if woffset(one of master's connect parameters) is 0,the connection will failed. 

patch包括V1.J-V1.O之间版本更新的.a文件，用户如果使用16M模式，请更新对应的.a文件。
If use 16M clock mode,please replace the ‘.a’ file.
