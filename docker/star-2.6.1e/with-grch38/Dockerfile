FROM mruffalo/star:2.6.1e

MAINTAINER Matt Ruffalo <mruffalo@cs.cmu.edu>
LABEL description="Image for STAR aligner version 2.6.1e, with GRCh38 index"

# Download and extract 

RUN apt-get -y update \
 && apt-get -y install curl \
 && rm -rf /var/cache/apt/*

WORKDIR /opt
RUN curl https://cf.10xgenomics.com/supp/cell-exp/refdata-cellranger-GRCh38-3.0.0.tar.gz | tar -xzf -
