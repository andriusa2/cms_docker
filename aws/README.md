Making AMIs for Contest Management System
-----------------------------------------

These scripts make it easy to do the following:

1. Create deb file of Contest Management System.
2. Create an AMI using that debian file.

About the setup
---------------

We are using a fork of cms 1.2 with a few additions. See [the
branch](https://github.com/lmio/cms/tree/lmio2015) for the code changes.

We assume the following setup in AWS:

1. **worker** node running cmsWorkers only. Runs on c4.xlarge or larger
   (otherwise it's impossible to turn off hyperthreading).
2. **cws** node running two CWS instances on ports 9000 (contest id=1) and 9001
   (contest id=2).
3. **centriukas** running everything else. It also runs nginx on port 80 http
   basic-auth. Hostname: `centriukas.cms1`.
4. **Database**. User: `cmsdb`. Hostname: `cmsdb.cms1`.

Getting started
---------------

Requirements:

1. Machine with Docker 1.9+ for building the deb file. If in EC2, you don't
   need the second one.
2. EC2 machine with [aminator](https://github.com/Netflix/aminator) for
   creating the AMI.

Creating the deb image
----------------------

```
make deb ADMINPW=admin_passwd DBPASSWD=db_passwd
```

The image will be in `build/cms_aws.deb`.

Creating the AMI
----------------

TBD. Will be:

```
make ami
```
