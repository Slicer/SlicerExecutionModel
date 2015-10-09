FROM debian:8
MAINTAINER Insight Software Consortium <community@itk.org>

RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  python \
  ninja-build \
  wget \
  vim

RUN mkdir -p /usr/src/SlicerExecutionModel-build
WORKDIR /usr/src

ENV ITK_GIT_TAG v4.8.0
RUN git clone git://itk.org/ITK.git && \
  cd ITK && \
  git checkout ${ITK_GIT_TAG} && \
  cd ../ && \
  mkdir ITK-build && \
  cd ITK-build && \
  cmake \
    -G Ninja \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DBUILD_TESTING:BOOL=OFF \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
    -DITK_LEGACY_REMOVE:BOOL=ON \
    -DITK_BUILD_DEFAULT_MODULES:BOOL=OFF \
    -DITK_USE_SYSTEM_LIBRARIES:BOOL=OFF \
    -DModule_ITKCommon:BOOL=ON \
    -DModule_ITKIOXML:BOOL=ON \
    -DModule_ITKExpat:BOOL=ON \
    ../ITK && \
  ninja install && \
  rm -rf ITK ITK-build
