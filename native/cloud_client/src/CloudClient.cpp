#include "CloudClient.h"
#include <iostream>

// #include <cpr/cpr.h>

namespace picasoo::cloud {

    struct CloudClient::Impl {
        std::string endpoint;
        std::string apiKey;
    };

    CloudClient::CloudClient() : m_impl(std::make_unique<Impl>()) {}

    CloudClient::~CloudClient() {}

    bool CloudClient::Connect(const std::string& endpoint, const std::string& apiKey) {
        m_impl->endpoint = endpoint;
        m_impl->apiKey = apiKey;
        std::cout << "Connected to Cloud: " << endpoint << std::endl;
        return true;
    }

    bool CloudClient::PostComment(const std::string& projectId, const Comment& comment) {
        std::cout << "Posting Comment to " << projectId << ": " << comment.text << std::endl;
        // cpr::Post(...)
        return true;
    }

    std::vector<Comment> CloudClient::GetComments(const std::string& projectId) {
        std::cout << "Fetching Comments for " << projectId << std::endl;
        // Mock data
        std::vector<Comment> comments;
        comments.push_back({"c1", "Alice", "Great cut!", 10.5});
        comments.push_back({"c2", "Bob", "Fix color here.", 45.2});
        return comments;
    }

}
