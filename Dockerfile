FROM centos:6.8

ADD Python-2.7.13.tgz /

RUN curl -o CentOS-Base.repo http://mirrors.163.com/.help/CentOS6-Base-163.repo && \
    mv -f CentOS-Base.repo /etc/yum.repos.d/ && \
    yum clean all && \
    yum makecache

RUN yum install -y vim gcc gcc-c++ zlib-devel bzip2-devel openssl-devel xz-libs readline-devel libffi-devel && \
    yum clean all

RUN cd /Python-2.7.13 && ./configure --prefix=/usr && make && make install && make clean && rm -rf /Python-2.7.13

RUN sed -i 's/python/python2.6/g' /usr/bin/yum
