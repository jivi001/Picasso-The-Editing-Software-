#pragma once

#include "common_types.h"
#include <string>
#include <memory>

namespace picasoo::titling {

    class TextRenderer {
    public:
        TextRenderer();
        ~TextRenderer();

        bool Initialize();
        bool LoadFont(const std::string& fontPath, int fontSize);
        
        // Renders text to a buffer (RGBA8)
        bool RenderText(const std::string& text, common::Buffer& outBuffer, common::Size& outSize);

    private:
        struct Impl;
        std::unique_ptr<Impl> m_impl;
    };

}
