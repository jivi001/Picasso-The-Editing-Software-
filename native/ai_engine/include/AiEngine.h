#pragma once

#include "common_types.h"
#include <string>
#include <vector>
#include <memory>

namespace picasoo::ai {

    enum class ModelType {
        Whisper,
        RVM, // Robust Video Matting
        ESRGAN
    };

    class AiEngine {
    public:
        AiEngine();
        ~AiEngine();

        bool Initialize();
        
        // Load a specific model
        bool LoadModel(ModelType type, const std::string& modelPath);

        // Run inference on an image (e.g. RVM or ESRGAN)
        bool RunInference(ModelType type, const common::Buffer& inputData, common::Size inputSize, common::Buffer& outputData);

    private:
        struct Impl;
        std::unique_ptr<Impl> m_impl;
    };

}
