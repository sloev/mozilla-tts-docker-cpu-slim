#FROM pytorch/pytorch:1.0.1-cuda10.0-cudnn7-runtime as base
FROM python:3.7 as base


RUN apt-get update && \
	apt-get install -y git libsndfile1 espeak && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM base as tts_base

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.

ENV LANG C.UTF-8
WORKDIR /srv/app
RUN git clone \
    https://github.com/mozilla/TTS \
    /srv/app

RUN ls -la
RUN git log | head -n 5
RUN git reset 72a6ac54c8 --hard

RUN pip install gdown
RUN python setup.py install develop


FROM tts_base as tts_model

RUN gdown --id 1dntzjWFg7ufWaTaFy80nRz-Tu02xWZos -O tts_model.pth.tar
RUN gdown --id 18CQ6G6tBEOfvCHlPqP8EBI4xWbrr9dBc -O config.json

RUN gdown --id 1uULLlv2J7LYNuQsSfrvGBa2C-x30e1aO -O scale_stats.npy

RUN gdown --id 1Ty5DZdOc0F7OTGj9oJThYbL5iVu_2G0K -O vocoder_model.pth.tar
RUN gdown --id 1Rd0R_nRCrbjEdpOwq6XwZAktvugiBvmu -O config_vocoder.json

FROM tts_model
RUN apt-get update && apt-get install -y sox
RUN pip install pysndfx

ADD test.py .

CMD ["python","test.py"]