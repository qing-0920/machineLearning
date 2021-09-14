# BUILD to  registry.cn-beijing.aliyuncs.com/imanager/ubuntu_aigislib_cpu
FROM registry.cn-beijing.aliyuncs.com/imanager/ipse_base:latest

RUN useradd supermap -p supermap -U && \
    mkdir /home/supermap && \
    chown supermap:supermap -R /home/supermap && \
    chmod +w /etc/sudoers && \
    echo 'supermap ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    chmod -w /etc/sudoers

USER supermap
WORKDIR /home/supermap

RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh && \
 bash Miniconda3-py37_4.10.3-Linux-x86_64.sh -p /home/supermap/miniconda -b && \
 rm Miniconda3-py37_4.10.3-Linux-x86_64.sh

ENV PATH=/home/supermap/miniconda/bin:${PATH}
# RUN conda update -y conda
# conda config --set remote_read_timeout_secs 6000.0 && \
COPY requirements-conda-cpu.yml ./
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
  conda config --set show_channel_urls yes && \
  conda env update -n base -f requirements-conda-cpu.yml && \
  conda clean --all -f -y