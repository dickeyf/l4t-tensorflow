FROM dustynv/l4t-tensorflow:tf2-r36.2.0 as builder

ARG BAZEL_VERSION=6.1.0
ARG BAZEL_URL=https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}
ARG BAZEL_EXEC=bazel-${BAZEL_VERSION}-linux-arm64

SHELL ["/bin/bash", "-c"]
RUN curl -fSsL ${BAZEL_URL}/${BAZEL_EXEC} -o /usr/bin/bazel && chmod +x /usr/bin/bazel

RUN git clone https://github.com/tensorflow/text.git && cd /text #&& git checkout "2.14"
RUN cd /text && \
    . oss_scripts/configure.sh && \
    . oss_scripts/prepare_tf_dep.sh && \
    sed -i "s/project_version = .*\$/project_version = \"$(python3 -c 'import tensorflow as tf; print(tf.__version__)')\"/" oss_scripts/pip_package/setup.py && \
    cd /text && \
    bazel build --enable_runfiles oss_scripts/pip_package:build_pip_package && \
    ./bazel-bin/oss_scripts/pip_package/build_pip_package .

FROM dustynv/l4t-tensorflow:tf2-r36.2.0

COPY --from=builder /text/tensorflow_text*.whl ./
RUN pip install ./tensorflow_text*.whl
RUN pip install "tf-models-official==2.14.*"