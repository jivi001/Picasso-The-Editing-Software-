#include "AiEngine.h"
#include <iostream>

// #include <onnxruntime_cxx_api.h>

namespace picasoo::ai {

    struct AiEngine::Impl {
        // Ort::Env env;
        // Ort::Session session;
    };

    AiEngine::AiEngine() : m_impl(std::make_unique<Impl>()) {}

    AiEngine::~AiEngine() {}

    bool AiEngine::Initialize() {
        std::cout << "Initializing AI Engine (ONNX Runtime)..." << std::endl;
        // Check for DirectML provider
        return true;
    }

    bool AiEngine::LoadModel(ModelType type, const std::string& modelPath) {
        std::cout << "Loading AI Model: " << modelPath << std::endl;
        // m_impl->session = Ort::Session(m_impl->env, modelPath.c_str(), Ort::SessionOptions{});
        return true;
    }

    bool AiEngine::RunInference(ModelType type, const common::Buffer& inputData, common::Size inputSize, common::Buffer& outputData) {
        // Prepare tensors
        // Run session.Run()
        std::cout << "Running Inference..." << std::endl;
        return true;
    }

}
