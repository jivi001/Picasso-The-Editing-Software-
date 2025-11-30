#pragma once

#include <string>
#include <vector>
#include <memory>

namespace picasoo::db {

    class DatabaseManager {
    public:
        DatabaseManager();
        ~DatabaseManager();

        bool Open(const std::string& path);
        void Close();

        bool ExecuteQuery(const std::string& query);
        
        // Example specific method
        bool CreateProject(const std::string& name, const std::string& path);

    private:
        struct Impl;
        std::unique_ptr<Impl> m_impl;
    };

}
