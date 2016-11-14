# a SOLVCON NFS node is a system that could provide NFS folders to share the
# SOLVCON source code and configuration.
FROM ubuntu:14.04
MAINTAINER Taihsiang Ho <tai271828@gmail.com>

# NFS server
RUN apt-get update && apt-get install -y nfs-kernel-server

EXPOSE 111/udp 2049/tcp

ADD run.sh /usr/local/bin/run.sh
ENTRYPOINT ["run.sh"]

# Set up user and environment.
RUN apt-get install -y openssh-client
# Set up SSH keys.
RUN \
  cd $HOME && \
  mkdir $HOME/.ssh && \
  ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -N "" -q && \
  cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

# SSH server.
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:s' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

# Fetch and build SOLVCON
# Install OS-wide packages.
RUN \
  apt-get -qq update && \
  apt-get -qqy install g++ liblapack-dev git wget
# Set up user and environment.
ENV HOME=/root
ENV CONDA_PREFIX="$HOME/opt/conda3"
ENV PATH="${CONDA_PREFIX}/bin:$PATH"
ENV SCSRC="$HOME/solvcon"
# Get latest SOLVCON from github.
RUN cd $HOME && git clone https://github.com/solvcon/solvcon.git
# Install most dependencies at user level through conda and pip.
RUN \
  cd $HOME && \
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda3.sh && \
  bash /tmp/miniconda3.sh -b -p ${CONDA_PREFIX} && \
  rm -f /tmp/miniconda3.sh
RUN \
  conda config --set always_yes yes --set changeps1 no && \
  conda update -q conda && \
  $SCSRC/contrib/conda.sh && \
  pip install https://github.com/pybind/pybind11/archive/master.zip
# Build SOLVCON.
RUN cd $SCSRC && python setup.py build_ext --inplace

