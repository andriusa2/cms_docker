Contest Management System load test report.

Keywords/glossary:

* CMS (Contest Management System)
* AWS (Amazon Web Services)
* Amazon EC2 (Elastic Cloud)
* Amazon RDS (Relational Database Service)
* Amazon ELB (Elastic Load Balancer)

Testing workers
---------------

How quickly can the workers run, and how scalable can the setup be? The
following setup was tested:

* c3.4xlarge (16 vCPU, 30 GB RAM), c3.8xlarge (32 vCPU, 60 GB RAM): cmsWorker.
* db.t2.medium (2 vCPU, 4 GB RAM): hosted PostgreSQL database (AWS RDS).
* t2.medium (2 vCPU, 4GiB RAM). All management: LogService,
  EvaluationService, Checker, ScoringService, AdminWebServer, etc.

With this setup all submissions of all exercises of first-day BOI2014 were
executed in about 50 minutes. Workers were fully loaded (CPU load ~16 and ~32
respectively).

Some observations. Like seen in the graphs below, management machine was mostly idle.

![Management machine utilization graphs](https://cloud.githubusercontent.com/assets/107720/4853139/342328fc-6083-11e4-8eaa-73b79995c424.png)

Database machine moderately busy (submission testing started around 10:50):

![Database machine utilization graphs](https://cloud.githubusercontent.com/assets/107720/4853135/3416cfbc-6083-11e4-8787-1c50850d4118.png)

**Problematic parts**

It is important to let workers pre-fetch the contest data. If testing starts
before that, weird things happen. Also, the database shouldn not be *too slow*
(db.t2.medium is good).

Conclusion: this is adequate.

Screenshot of random point in time running the benchmarks:

![Benchmark in progress](https://cloud.githubusercontent.com/assets/107720/4853138/3420d110-6083-11e4-8f45-370c86b53e8e.png)

Web traffic
-----------

Making web servers (ContestWebService) scale was more problematic. Test
methodology: set up the web service, ``ab`` on a url with a cookie that
understands user is logged in (so we do not hit the redirect all the time).

I understand this does not fully exercise the system because it does not
load submissions, but sounds like good enough to test basic web service performance.

Some observations:

* Running more than one worker under the same ResourceService did not work.
  All but the first servers kept restarting. Since I didn't believe it's going
  to work anyway, I did not investigate this too much.
* Database should be able connection-number-wise. ContestWebService opens a few
  connections *on every request*, and *looks like* does not shut them down
  immediately. That raised significant concerns with the ``db.t2.medium`` database
  (2 vCPUs, 4 GiB RAM).
* ``TIME_WAIT`` sockets is a big deal. More on that later.

Machine setup:

* 2 * c3.8xlarge (32 vCPU, 60 GiB RAM): ContestWebService.
* db.r3.8xlarge (32 vCPU, 244 GiB RAM): hosted PostgreSQL database (AWS RDS).
* t2.medium (2 vCPU, 4GiB RAM). All management: LogService, EvaluationService, etc.

Logical setup:

* ELB (Elastic Load Balancer) was in front and had the public IP.
* Two machines (c3.8xlarge) had nginx serving port 80 and forwarding the
  requests to ContestWebServices, below.
* Both c3.8xlarge machines had 32 Docker containers running ContestWebService
  each (ports 8890-8921). Each container exposes one port for terminating HTTP
  traffic, and one port for management (so "management" can connect to it). All
  these services had to be configured in ``cms.conf``.  After that they were
  launched using a simple
  [shell script](https://github.com/Motiejus/cms_docker/blob/boi2014/dockers).
* This is important:
  ```
    echo 1 | sudo tee /proc/sys/net/ipv4/tcp_tw_reuse
    echo 1 | sudo tee /proc/sys/net/ipv4/tcp_tw_recycle
  ```
  Normally this is a dangerous/unsafe operation, but we can do this, because we
  are not talking to the outside world and all traffic is contained within a
  single network.

  Without these settings after 30-40 seconds servers got tens of thousands
  ``TIME_WAIT`` network sockets, and the benchmarks stalled without an
  indication what is going wrong. Remember, always check ``netstat`` when
  something is off.

  For the cautious, `tcp_tw_reuse` alone might be enough. But during testing I
  did not yet know `tcp_tw_recycle`
  [can be dangerous](http://kaivanov.blogspot.nl/2010/09/linux-tcp-tuning.html).

**Problematic database**

In the beginning, it was hard to get DB right. In the beginning of the
benchmarks requests started failing due to problems connecting to the database
(``connection refused``). Tried workaround: pgbouncer. However, it does not
solve the error, just postpones it (the same problems happen, just after more
requests). Solution: get a more powerful instance with a higher limit on DB
connections.

db.t2.medium allows 291 connections. The (unofficial) formula is
`DBInstanceClassMemory/12582880`, which, for db.r3.8xlarge, is around 19k.
This is enough for our purposes:

![Number of connections graph](https://cloud.githubusercontent.com/assets/107720/4853137/341fc996-6083-11e4-8a72-1c7e2b1d55b7.png)

![DB usage graphs](https://cloud.githubusercontent.com/assets/107720/4853136/341d9aa4-6083-11e4-9f04-c14865be2afc.png)

With all that changed, the setup was able to do about 980 requests per second
(there were more runs with higher rates, but I logged only this):

```
[ec2-user@ip-172-31-19-49 ~]$ ab -n100000 -c60 -H 'Cookie: login="...";' \
    http://cmsdbproxy-xyz.elb.amazonaws.com/tasks/coprobber/description
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking cmsdbproxy-xyz.elb.amazonaws.com (be patient)
Completed 10000 requests
Completed 20000 requests
Completed 30000 requests
Completed 40000 requests
Completed 50000 requests
Completed 60000 requests
Completed 70000 requests
Completed 80000 requests
Completed 90000 requests
Completed 100000 requests
Finished 100000 requests


Server Software:        nginx/1.6.2
Server Hostname:        cmsdbproxy-xyz.elb.amazonaws.com
Server Port:            80

Document Path:          //tasks/coprobber/description
Document Length:        6844 bytes

Concurrency Level:      60
Time taken for tests:   101.861 seconds
Complete requests:      100000
Failed requests:        10084
   (Connect: 0, Receive: 0, Length: 10084, Exceptions: 0)
Write errors:           0
Total transferred:      729883619 bytes
HTML transferred:       684389916 bytes
Requests per second:    981.73 [#/sec] (mean)
Time per request:       61.117 [ms] (mean)
Time per request:       1.019 [ms] (mean, across all concurrent requests)
Transfer rate:          6997.54 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   0.7      1      20
Processing:    39   58 206.6     49    5110
Waiting:       38   58 206.6     48    5110
Total:         39   59 206.6     49    5110

Percentage of the requests served within a certain time (ms)
  50%     49
  66%     51
  75%     53
  80%     54
  90%     56
  95%     60
  98%     66
  99%     74
 100%   5110 (longest request)
```

Conclusion: with TCP connection reuse and no-bullshit database, it is possible
to reliably issue lots of requests to ContestWebService.
