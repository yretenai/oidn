// Copyright 2009-2023 Intel Corporation
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "../image.h"
#include "../tensor.h"
#include "../tile.h"
#include "../color.h"
#include "cpu_input_process_ispc.h"
#include "color_ispc.h"

OIDN_NAMESPACE_BEGIN

  ispc::ImageAccessor toISPC(const Image& image);
  ispc::TensorAccessor3D toISPC(const Tensor& tensor);
  ispc::Tile toISPC(const Tile& tile);
  ispc::TransferFunction toISPC(const TransferFunction& tf);

OIDN_NAMESPACE_END