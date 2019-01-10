FROM python:3.7-alpine3.8

ENV OPENCV_VERSION 3.4.5

RUN apk add --no-cache \
      libjpeg-turbo \
      libpng \
      tiff \
      jasper \
      ffmpeg
RUN apk add --no-cache --virtual=build_dependencies \
      linux-headers \
      build-base \
      clang-dev \
      ninja \
      cmake \
      libjpeg-turbo-dev \
      libpng-dev \
      tiff-dev \
      jasper-dev \
      ffmpeg-dev && \
    export CC=/usr/bin/clang CXX=/usr/bin/clang++ && \
    pip install --no-cache-dir numpy && \
    wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz -O - | tar xz && \
    mkdir opencv-${OPENCV_VERSION}/cmaked && \
    cd opencv-${OPENCV_VERSION}/cmaked && \
    cmake -G Ninja \
      -DBUILD_TIFF=ON \
      -DBUILD_opencv_java=OFF \
      -DWITH_CUDA=OFF \
      -DENABLE_AVX=OFF \
      -DWITH_OPENGL=ON \
      -DWITH_OPENCL=ON \
      -DWITH_IPP=ON \
      -DWITH_TBB=OFF \
      -DWITH_EIGEN=ON \
      -DWITH_V4L=ON \
      -DBUILD_TESTS=OFF \
      -DBUILD_PERF_TESTS=OFF \
      -DCMAKE_BUILD_TYPE=RELEASE \
      -DCMAKE_INSTALL_PREFIX=$(python -c "import sys; print(sys.prefix)") \
      -DPYTHON_EXECUTABLE=$(which python) \
      -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
      -DPYTHON_PACKAGES_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. && \
    ninja install && \
    rm -rf ~/.cache/pip && \
    apk del build_dependencies && \
    rm -rf opencv-${OPENCV_VERSION}
