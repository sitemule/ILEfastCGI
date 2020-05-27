# ILEfastCGI
ILE version of the LIBFCGI tailored for IBM i


# Installation
What you need before you start:

* IBM i 7.3 TR3 (or higher)
* git and gmake (YUM)
* ILE C 


From a IBM i menu prompt start the SSH deamon:`===> STRTCPSVR *SSHD`
Then start ssh from win/mac/linux

```
mkdir /prj
cd /prj 
git -c http.sslVerify=false clone https://github.com/sitemule/ILEfastCGI.git
cd ILEfastCGI
gmake 
```
Now you have library ILEFCGI on your IBM i - and you are good to go. You can simply copy the serivce program
to you own projects libraries along with the binding directory and header files.

For an example how the ILEfastCGI can be used, please look in ILEastic project where one option 
is to use fastCGI for connectio to Apache or Nginx

https://github.com/sitemule/ILEastic/blob/master/examples/Fastcgi01.rpgle


