from continuumio/miniconda3
SHELL ["/bin/bash", "-c"]

RUN apt-get update
RUN apt-get upgrade -y
# Utilities for managing the build
RUN apt-get install -y wget unzip
# Necessary for firefox (which will be installed via conda) which is necessary for bokeh export plots
RUN apt-get install -y libgtk-3-0 libasound2 libdbus-glib-1-2 libx11-xcb-dev libpci-dev libgl1-mesa-glx

RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority true
RUN conda init --system bash

RUN conda install mamba -y
RUN mamba update --all -y

COPY ukb.env.yml .
RUN mamba env create --file=ukb.env.yml -n ukb
RUN rm ukb.env.yml

COPY ukb_r.env.yml .
RUN mamba env create --file=ukb_r.env.yml -n ukb_r
RUN rm ukb_r.env.yml

RUN mkdir -p /container_install/bin
ENV PATH="$PATH:/container_install/bin"
COPY envsetup /container_install/bin/envsetup
RUN chmod a+rx /container_install/bin/envsetup

WORKDIR /container_install
RUN wget https://primus.gs.washington.edu/docroot/versions/PRIMUS_v1.9.0.tgz
# RUN mkdir PRIMUS_v1.9.0
RUN tar -xzvf PRIMUS_v1.9.0.tgz
RUN chmod -R a+rx PRIMUS_v1.9.0
RUN rm PRIMUS_v1.9.0.tgz
ENV PATH="$PATH:/container_install/PRIMUS_v1.9.0/bin"

# Could get a different instruction set for AMD processors
RUN wget https://s3.amazonaws.com/plink2-assets/alpha3/plink2_linux_avx2_20221024.zip
RUN unzip plink2_linux_avx2_20221024.zip -d bin
RUN rm plink2_linux_avx2_20221024.zip

