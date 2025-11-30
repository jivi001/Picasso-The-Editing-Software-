#pragma once
#include "NodeGraph.h"
#include <iostream>

namespace picasoo::node {

    class TransformNode : public Node {
    public:
        TransformNode() {
            id = "transform_" + std::to_string(rand());
            name = "Transform";
            inputs.push_back({ "in", "Input", Pin::Type::Input, common::DataType::RGBA8 });
            outputs.push_back({ "out", "Output", Pin::Type::Output, common::DataType::RGBA8 });
        }

        void Execute() override {
            std::cout << "Executing Transform Node: " << id << std::endl;
            // Actual image processing logic would go here (OpenCV / Shader)
        }
    };

    class BlurNode : public Node {
    public:
        BlurNode() {
            id = "blur_" + std::to_string(rand());
            name = "Blur";
            inputs.push_back({ "in", "Input", Pin::Type::Input, common::DataType::RGBA8 });
            outputs.push_back({ "out", "Output", Pin::Type::Output, common::DataType::RGBA8 });
        }

        void Execute() override {
            std::cout << "Executing Blur Node: " << id << std::endl;
            // Actual blur logic
        }
    };

}
