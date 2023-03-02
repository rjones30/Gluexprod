#
# Dockerfile - docker build script for a standard GlueX sim-recon 
#              container image based on centos 7.
#
# author: richard.t.jones at uconn.edu
# version: june 7, 2017
# updated: june 13, 2020 
#
# usage: [as root] $ docker build Dockerfile .
#

FROM centos:7

# install a few utility rpms
RUN yum -y install bind-utils util-linux which wget tar procps less file dump gcc gcc-c++ gcc-gfortran gdb gdb-gdbserver strace openssh-server
RUN yum -y install vim-common vim-filesystem docker-io-vim vim-minimal vim-enhanced vim-X11
RUN yum -y install qt qt-x11 qt-devel
RUN yum -y install motif-devel libXpm-devel libXmu-devel libXp-devel
RUN yum -y install java-1.8.0-openjdk
RUN yum -y install blas lapack blas-devel lapack-devel
RUN yum -y install python3 python3-devel python3-pip
RUN yum -y install postgresql-devel
RUN wget --no-check-certificate https://zeus.phys.uconn.edu/halld/gridwork/libtbb.tgz
RUN tar zxf libtbb.tgz -C /
RUN rm libtbb.tgz

# install the osg worker node client packages
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# work-around for problems using the EPEL mirrors (repomd.xml does not match metalink for epel)
#RUN sed -i 's/^#baseurl/baseurl/' /etc/yum.repos.d/epel.repo
#RUN sed -i 's/^metalink/#metalink/' /etc/yum.repos.d/epel.repo
# end of work-around
RUN yum -y install yum-plugin-priorities
#COPY yum-plugin-priorities-1.1.31-54.el7_8.noarch.rpm /yum-plugin-priorities-1.1.31-54.el7_8.noarch.rpm
#RUN rpm -ivh yum-plugin-priorities-1.1.31-54.el7_8.noarch.rpm
#RUN rpm -Uvh https://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm
RUN yum -y install https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el7-release-latest.rpm
RUN yum -y install osg-wn-client
RUN wget --no-check-certificate https://zeus.phys.uconn.edu/halld/gridwork/dcache-srmclient-3.0.11-1.noarch.rpm
RUN rpm -Uvh dcache-srmclient-3.0.11-1.noarch.rpm
RUN rm dcache-srmclient-3.0.11-1.noarch.rpm

# install the hdpm package builder
ENV GLUEX_TOP /usr/local
ADD https://halldweb.jlab.org/dist/hdpm/hdpm-0.7.2.linux.tar.gz /
RUN tar zxf hdpm-0.7.2.linux.tar.gz
RUN rm hdpm-0.7.2.linux.tar.gz
RUN mv hdpm-0.7.2 hdpm

# install the scl devtoolset packages to get more advanced gnu compilers
RUN yum -y install centos-release-scl-rh scl-utils
#RUN yum -y install devtoolset-4-runtime devtoolset-4-gcc-gdb-plugin devtoolset-4-gcc-gfortran devtoolset-4-gcc-c++ devtoolset-4-gcc 
#RUN yum -y install devtoolset-4-gcc-plugin-devel devtoolset-4-libstdc++-devel devtoolset-4-libquadmath-devel
#RUN yum -y install devtoolset-6-gcc-gdb-plugin-6.3.1-3.1.el7.x86_64 devtoolset-6-gcc-gfortran-6.3.1-3.1.el7.x86_64 devtoolset-6-runtime-6.1-1.el7.x86_64
#RUN yum -y install devtoolset-6-libquadmath-devel-6.3.1-3.1.el7.x86_64 devtoolset-6-libstdc++-devel-6.3.1-3.1.el7.x86_64 devtoolset-6-gcc-plugin-devel-6.3.1-3.1.el7.x86_64
#RUN yum -y install devtoolset-6-gcc-6.3.1-3.1.el7.x86_64 devtoolset-6-binutils-2.27-12.el7.1.x86_64 devtoolset-6-gcc-c++-6.3.1-3.1.el7.x86_64
RUN yum -y install devtoolset-7-gcc-c++-7.3.1-5.16.el7.x86_64 devtoolset-7-libquadmath-devel-7.3.1-5.16.el7.x86_64 devtoolset-7-libstdc++-devel-7.3.1-5.16.el7.x86_64
RUN yum -y install devtoolset-7-gcc-gdb-plugin-7.3.1-5.16.el7.x86_64 devtoolset-7-binutils-2.28-11.el7.x86_64 devtoolset-7-gcc-plugin-devel-7.3.1-5.16.el7.x86_64
RUN yum -y install devtoolset-7-gcc-7.3.1-5.16.el7.x86_64 devtoolset-7-runtime-7.1-4.el7.x86_64 devtoolset-6-binutils-2.27-12.el7.1.x86_64 devtoolset-7-gcc-gfortran-7.3.1-5.16.el7.x86_64
RUN yum -y install devtoolset-8-libquadmath-devel-8.3.1-3.2.el7.x86_64 devtoolset-8-runtime-8.1-1.el7.x86_64 devtoolset-8-gcc-gfortran-8.3.1-3.2.el7.x86_64
RUN yum -y install devtoolset-8-gcc-c++-8.3.1-3.2.el7.x86_64 devtoolset-8-binutils-2.30-55.el7.2.x86_64 devtoolset-8-gcc-8.3.1-3.2.el7.x86_64 devtoolset-7-binutils-2.28-11.el7.x86_64
RUN yum -y install devtoolset-8-libstdc++-devel-8.3.1-3.2.el7.x86_64 devtoolset-8-gcc-gdb-plugin-8.3.1-3.2.el7.x86_64 devtoolset-8-gcc-plugin-devel-8.3.1-3.2.el7.x86_64
RUN yum -y install devtoolset-9-gcc-c++-9.3.1-2.el7.x86_64 devtoolset-9-binutils-2.32-16.el7.x86_64 devtoolset-9-gcc-gdb-plugin-9.3.1-2.el7.x86_64
RUN yum -y install devtoolset-9-runtime-9.1-0.el7.x86_64 devtoolset-9-gcc-plugin-devel-9.3.1-2.el7.x86_64 devtoolset-9-libstdc++-devel-9.3.1-2.el7.x86_64
RUN yum -y install devtoolset-9-gcc-gfortran-9.3.1-2.el7.x86_64 devtoolset-9-libquadmath-devel-9.3.1-2.el7.x86_64 devtoolset-9-gcc-9.3.1-2.el7.x86_64

# install some additional packages that might be useful
RUN yum -y install gfal2-plugin-lfc gfal2-all gfal2-plugin-gridftp gfal2-devel gfal2-plugin-dcap gfal2-plugin-srm gfal2-plugin-rfio
RUN yum -y install apr apr-util atlas autoconf automake bc cmake cmake3 git scons bzip2-devel boost-python36 boost-python boost-system
RUN yum -y install gsl gsl-devel libgnome-keyring lyx-fonts m4 neon pakchois mariadb mariadb-libs mariadb-devel
RUN yum -y install perl-File-Slurp perl-Test-Harness perl-Thread-Queue perl-XML-NamespaceSupport perl-XML-Parser perl-XML-SAX perl-XML-SAX-Base perl-XML-Simple perl-XML-Writer
RUN yum -y install subversion subversion-libs
RUN yum -y install python2-pip python-devel
RUN yum -y install hdf5 hdf5-devel
RUN yum -y install valgrind
RUN pip3 install --upgrade pip
RUN pip2 install future numpy==1.16.6
RUN pip3 install psycopg2
RUN pip3 install pandas
RUN pip3 install h5py
RUN pip3 install h5hep
RUN pip3 install keras
RUN pip3 install tensorflow
RUN pip3 install tensorflow_decision_forests
RUN python3 -m pip install numpy==1.19.5
RUN python3 -m pip install scipy
RUN python3 -m pip install tqdm

# add some packages that are needed for the kshell nuclear structure code
RUN yum -y install ucx libevent openmp openmpi openmpi-devel

# create mount point for sim-recon, simlinks in /usr/local
RUN wget --no-check-certificate https://zeus.phys.uconn.edu/halld/gridwork/local.tar.gz
RUN mv /usr/sbin/sshd /usr/sbin/sshd_orig
RUN tar zxf local.tar.gz -C /
RUN rm local.tar.gz
RUN rm -rf /hdpm

# make the cvmfs filesystem visible inside the container
VOLUME /cvmfs/oasis.opensciencegrid.org
