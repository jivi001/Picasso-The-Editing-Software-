#pragma once

#include <string>
#include <vector>
#include <memory>
#include <cstdint>
#include <fmt/core.h>
#include <spdlog/spdlog.h>

namespace picasoo::common {

    using Byte = uint8_t;
    using Buffer = std::vector<Byte>;

    struct Size {
        int width;
        int height;
    };

    enum class PixelFormat {
        RGBA8,
        RGBA16F,
        RGBA32F,
        NV12,
        P010
    };

    // Simple Logger Wrapper
    inline void LogInfo(const std::string& msg) {
        spdlog::info(msg);
    }

    inline void LogError(const std::string& msg) {
        spdlog::error(msg);
    }

}
