#pragma once

#include "common_types.h"
#include <string>
#include <memory>

namespace picasoo::video {

    class VideoEngine {
    public:
        VideoEngine();
        ~VideoEngine();

        bool OpenFile(const std::string& path);
        void CloseFile();
        
        // Decodes the next frame into the provided buffer
        bool GetNextFrame(common::Buffer& outBuffer, common::Size& outSize);

    private:
        struct Impl;
        std::unique_ptr<Impl> m_impl;
    };

}
