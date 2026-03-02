FROM dockcross/linux-x64
MAINTAINER Insight Software Consortium <community@itk.org>

WORKDIR /usr/src

# "ac65b49c34fcfa3c3422a66026c7fe2bbaa88902" # slicer-v5.4.5-2025-11-19-f51594a
ENV ITK_GIT_COMMIT=ac65b49c34fcfa3c3422a66026c7fe2bbaa88902

RUN \
  #
  # Settings
  #
  working_dir=$(pwd) && \
  #
  # Checkout
  #
  git clone https://github.com/Slicer/ITK.git ${working_dir}/ITK && \
  cd ${working_dir}/ITK && git reset --hard ${ITK_GIT_COMMIT} && \
  #
  # Configure
  #
  cmake \
    -G Ninja \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr/local \
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
    -S ${working_dir}/ITK -B ${working_dir}/ITK-build && \
  #
  # Build and install
  #
  ninja install && \
  #
  # Cleanup
  #
  rm -rf $working_dir/ITK $working_dir/ITK-build

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.description="An open-source CMake-based project that provides macros and associated tools for the easy building of 3D Slicer command line interface (CLI) modules." \
      org.label-schema.url="http://www.slicer.org" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"
