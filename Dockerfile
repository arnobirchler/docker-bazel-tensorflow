FROM arnobirchler/tensorflow-jupiter-opencv

RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list

RUN apt-get clean && apt-get update \
  && apt-get install -y bazel \
  && rm -rf /var/lib/apt/lists/*

# Set up workspace
RUN mkdir -p /usr/src/app
ENV WORKSPACE /usr/src/app
WORKDIR /usr/src/app

RUN git clone https://github.com/tensorflow/tensorflow.git

# Set up workspace
ENV WORKSPACE /usr/src/app/tensorflow
WORKDIR /usr/src/app/tensorflow
