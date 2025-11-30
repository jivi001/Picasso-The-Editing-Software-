#pragma once

#include <string>
#include <vector>
#include <memory>

namespace picasoo::cloud {

    struct Comment {
        std::string id;
        std::string author;
        std::string text;
        double timestamp;
    };

    class CloudClient {
    public:
        CloudClient();
        ~CloudClient();

        bool Connect(const std::string& endpoint, const std::string& apiKey);
        
        bool PostComment(const std::string& projectId, const Comment& comment);
        std::vector<Comment> GetComments(const std::string& projectId);

    private:
        struct Impl;
        std::unique_ptr<Impl> m_impl;
    };

}
