# SNARE-seq pipeline containers

Containers for this pipeline are publicly available on Docker Hub. If you'd
like to build them yourself, they must be built in sequence:
1. "Base" STAR container with just the aligner
1. STAR with GRCh38 index included in the container
1. dropEst with `genes.gtf` from the GRCh38 index

## Building

The three `Dockerfile`s specify `mruffalo` as the owner; you'll need to modify
those if you'd like to push the containers to Docker Hub. The CWL workflow
steps will need to be modified accordingly also.

From this directory:
```shell script
$ docker build -t mruffalo/star:2.6.1e star-2.6.1e/base
$ docker build -t mruffalo/star-grch38:2.6.1e star-2.6.1e/with-grch38
$ docker build -t mruffalo/dropest:0.8.6 dropest-0.8.6
```
