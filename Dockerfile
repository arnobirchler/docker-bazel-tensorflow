FROM openjdk:8

RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
  && curl https://bazel.build/bazel-release.pub.gpg | apt-key add -

RUN apt-get update \
  && apt-get install -y bazel \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/models

COPY models /home/models

RUN curl -L https://github.com/protocolbuffers/protobuf/releases/download/v3.9.1/protoc-3.9.1-linux-x86_64.zip > protoc.zip
RUN mkdir /opt/protoc
RUN unzip protoc.zip -d /opt/protoc
RUN rm protoc.zip
ENV PATH="/opt/protoc/bin:${PATH}"
ENV PYTHONPATH="${PYTHONPATH}:/home/models"
ENV PYTHONPATH="${PYTHONPATH}:/home/models/research"
ENV PYTHONPATH="${PYTHONPATH}:/home/models/research/slim"
RUN (cd /home/models/research && protoc --python_out=. object_detection/protos/*)

# Set up workspace
RUN mkdir -p /usr/src/app
ENV WORKSPACE /usr/src/app
WORKDIR /usr/src/app

RUN git clone https://github.com/tensorflow/tensorflow.git

# Set up workspace
ENV WORKSPACE /usr/src/app/tensorflow
WORKDIR /usr/src/app/tensorflow
