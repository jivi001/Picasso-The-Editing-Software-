#pragma once

#include "common_types.h"
#include <string>
#include <memory>
#include <vector>

namespace picasoo::color {

    class ColorProcessor {
    public:
        ColorProcessor();
        ~ColorProcessor();

        bool Initialize(const std::string& configPath);
        
        // Returns GLSL shader code for the transform
        std::string GetShaderCode(const std::string& inputSpace, const std::string& outputSpace);

        // CPU Fallback processing
        void ProcessCPU(common::Buffer& image, int width, int height, const std::string& inputSpace, const std::string& outputSpace);

    private:
        struct Impl;
        std::unique_ptr<Impl> m_impl;
    };

}
