#===============================================================================
# Copyright 2020-2021 Intel Corporation
# Copyright 2020 Codeplay Software Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#===============================================================================

find_package(CUDA 10.0 REQUIRED)

set(CUDNN_ROOT ${CUDA_TOOLKIT_ROOT_DIR} CACHE PATH "Folder containing NVIDIA cuDNN")

find_path(CUDNN_INCLUDE_DIR "cudnn.h" HINTS ${CUDNN_ROOT} PATH_SUFFIXES include)

include(FindPackageHandleStandardArgs)

find_library(
    CUDNN_LIBRARY cudnn
    HINTS ${CUDNN_ROOT}
    PATH_SUFFIXES lib lib64 bin)

find_package_handle_standard_args(cuDNN
    REQUIRED_VARS
        CUDNN_INCLUDE_DIR
        CUDNN_LIBRARY
)

# extract version from the include
if(CUDNN_INCLUDE_DIR)
  # cuDNN v8 has a separate header file with version defined
  if (EXISTS "${CUDNN_INCLUDE_DIR}/cudnn_version.h")
    file(READ "${CUDNN_INCLUDE_DIR}/cudnn_version.h" CUDNN_H_CONTENTS)
  else()
    file(READ "${CUDNN_INCLUDE_DIR}/cudnn.h" CUDNN_H_CONTENTS)
  endif()

  string(REGEX MATCH "define CUDNN_MAJOR ([0-9]+)" _ "${CUDNN_H_CONTENTS}")
  set(CUDNN_MAJOR_VERSION ${CMAKE_MATCH_1} CACHE INTERNAL "")
  string(REGEX MATCH "define CUDNN_MINOR ([0-9]+)" _ "${CUDNN_H_CONTENTS}")
  set(CUDNN_MINOR_VERSION ${CMAKE_MATCH_1} CACHE INTERNAL "")
  string(REGEX MATCH "define CUDNN_PATCHLEVEL ([0-9]+)" _ "${CUDNN_H_CONTENTS}")
  set(CUDNN_PATCH_VERSION ${CMAKE_MATCH_1} CACHE INTERNAL "")

  set(CUDNN_VERSION
    "${CUDNN_MAJOR_VERSION}.${CUDNN_MINOR_VERSION}.${CUDNN_PATCH_VERSION}"
  )
  message(STATUS "cuDNN version: ${CUDNN_VERSION}")

  unset(CUDNN_H_CONTENTS)
endif()

if(NOT TARGET cuDNN::cuDNN)
  add_library(cuDNN::cuDNN SHARED IMPORTED)
  set_target_properties(cuDNN::cuDNN PROPERTIES
      IMPORTED_LOCATION ${CUDNN_LIBRARY}
      IMPORTED_IMPLIB ${CUDNN_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${CUDNN_INCLUDE_DIR})
endif()
