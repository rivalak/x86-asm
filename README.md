# x86_asm

> *x86 汇编语言： 从实模式到保护模式* linux 版本代码   
> 用 qemu 启动 和 bochs 调试

## 1 usage

### 1.1 运行程序查看结果

* 需要安装 qemu，使用   
  ```s
  $ qemu-system-i386 -hda <file.bin> 
  ``` 

* or just 
  ```s 
  $ make qemu 
  ```

### 1.2 使用 bochs 调试
> 如果不明白请查看 [<u>参考4 - bochs 安装、配置和使用</u>](https://blog.csdn.net/Rivalak/article/details/101427828)  

  ```s
  $ make bochs

  1. 一直回车默认选项创建 bximage
  2. 选择选项 "2. Read options from..."
  3. 输入 .bochsrc 文件所在目录
  4. 回车启动 bochs
  ```

## 2 References

1. [x86汇编语言: 从实模式到保护模式](https://www.jianshu.com/p/d481cb547e9f)  
2. [lichuang/x86-asm-book-source](https://github.com/lichuang/x86-asm-book-source)  
3. [x86汇编语言 书下载](http://www.3322.cc/soft/36223.html)
4. [bochs 安装、配置和使用](https://blog.csdn.net/Rivalak/article/details/101427828)  
