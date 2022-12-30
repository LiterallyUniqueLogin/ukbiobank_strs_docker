from continuumio/miniconda3
SHELL ["/bin/bash", "-c"]

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget

RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority true
RUN conda install mamba -y

RUN mamba update --all -y

COPY ukb.env.yml .
RUN mamba env update --file=ukb.env.yml

RUN echo -e "\nsource activate ukb" >> ~/.bashrc

RUN wget https://primus.gs.washington.edu/docroot/versions/PRIMUS_v1.9.0.tgz -P ~
RUN mkdir ~/PRIMUS_v1.9.0
RUN tar -xzvf ~/PRIMUS_v1.9.0.tgz -C ~
RUN rm ~/PRIMUS_v1.9.0.tgz
ENV PATH="$PATH:~/PRIMUS_v1.9.0/bin"

# Could get a different instruction set for AMD processors
RUN apt-get install -y unzip
RUN wget https://s3.amazonaws.com/plink2-assets/alpha3/plink2_linux_avx2_20221024.zip -P ~
RUN unzip ~/plink2_linux_avx2_20221024.zip -d ~/bin
RUN rm ~/plink2_linux_avx2_20221024.zip
ENV PATH="$PATH:~/bin"

