FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

# update, and install basic packages
RUN apt-get update -qq
RUN apt-get install -y build-essential curl git python
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -y python python-setuptools python-dev python-tk python-pip
RUN pip install numpy scipy matplotlib notebook pandas sympy nose scikit-learn scikit-image h5py
RUN apt-get -y clean
RUN rm -r /var/lib/apt/lists/*

RUN git clone --branch v1.3.9 --depth 1 https://github.com/Netflix/vmaf.git /opt/vmaf
WORKDIR /opt/vmaf
RUN git submodule update --init --recursive
ENV PYTHONPATH=/opt/vmaf/python/src:/opt/vmaf:/opt/vmaf/sureal/python/src:$PYTHONPATH
ENV PATH=/opt/vmaf:/opt/vmaf/wrapper:/opt/vmaf/sureal:$PATH
RUN make
ADD entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
