FROM mruffalo/star-grch38:2.6.1e as INDEX

FROM rocker/r-ver:3.6.1
MAINTAINER Viktor Petukhov "viktor.s.petuhov@ya.ru"

RUN apt-get update --yes && apt-get install --no-install-recommends --yes \
  build-essential \
  cmake \
  git \
  less \
  libbamtools-dev \
  libboost-dev \
  libboost-iostreams-dev \
  libboost-log-dev \
  libboost-system-dev \
  libboost-test-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libz-dev \
  nano \
  pandoc \
&& rm -rf /var/cache/apt/*

RUN \
  R -e 'install.packages(c("devtools", "Rcpp","RcppEigen", "RInside", "Matrix", "optparse", "rmarkdown", "withr"))'

WORKDIR "/opt"

RUN git clone https://github.com/hms-dbmi/dropEst.git

RUN \
  R -e 'install.packages("ks", dependencies=c("Depends", "Imports", "LinkingTo"))' && \
  R -e 'devtools::install_local("~/dropEst/dropestr/", dependencies=T)'

RUN \
  mkdir -p dropEst/build && \
  cd dropEst/build && \
  cmake ../ && \
  make

# TODO: Figure out why this was necessary
RUN echo /usr/local/lib/R/lib > /etc/ld.so.conf.d/R-lib.conf && ldconfig

ENV PATH=/opt/dropEst/build:$PATH

COPY --from=INDEX /opt/refdata-cellranger-GRCh38-3.0.0/genes/ /opt/refdata-cellranger-GRCh38-3.0.0/genes/

CMD "/bin/bash"
