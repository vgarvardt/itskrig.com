Deploying PHP Application to Kubernetes: Index
10 Jun 18 14:31 +0100
php, kubernetes, k8s

+++

This set of articles summarizes my experience moving legacy PHP application from Amazon EC2 instances to Kubernetes cluster.

## Initial state

* Legacy PHP 7.0 application consisting of two parts:
  * Web-application - several Amazon EC2 instances behind the API Gateway ([Janus](https://github.com/hellofresh/janus) in our case), each has nginx and php-fpm running;
  * Consumers - single powerful Amazon EC2 instance running several long-running cli php processes, supervisored by [runit](http://smarden.org/runit/);
* All logs are written to filesystem on each instance (handled by [Monolog](https://github.com/Seldaek/monolog)) and then are sent to [Graylog](https://www.graylog.org/) using [Filebeat](https://www.elastic.co/products/beats/filebeat);
* Deployment/maintenance is done with [Ansible](https://www.ansible.com/);
* Short period of downtime when nginx and php-fpm processes are being restarted (no blue-green deployemnt);

## Target state

* All instances are runinng in existing [Kubernetes](https://kubernetes.io/) cluster ("k8s" for short) - this is very important, since I'm focusing on migrating the application, not setting up a cluster;
* Logs are shipped to [Graylog](https://www.graylog.org/) - k8s cluster already ships all app logs from stdout/stderr for couple golang applications;
* No downtime during deployment;
* Autoscaling - there are periods of the day/week/year when we do not have a lot traffic, so it would be nice to lower number of instances, and automatically increase number of instances during massive marketing campaigns;

We'll be moving from initial to target state step by step, w/out implementing all at once - e.g. at the moment of writing this post autoscaling problem is not solved, this is the next thing we're going to work on.

## Index

* [Building Docker Images](/php-k8s/images)
* Gathering Logs
* Deployment w/out downtime
* Autoscaling
