#include "DatabaseManager.h"
#include <iostream>
// #include <sqlite3.h>

namespace picasoo::db {

    struct DatabaseManager::Impl {
        // sqlite3* db = nullptr;
    };

    DatabaseManager::DatabaseManager() : m_impl(std::make_unique<Impl>()) {}

    DatabaseManager::~DatabaseManager() {
        Close();
    }

    bool DatabaseManager::Open(const std::string& path) {
        std::cout << "Opening Database: " << path << std::endl;
        // sqlite3_open(path.c_str(), &m_impl->db);
        
        // Initialize Schemas
        ExecuteQuery("CREATE TABLE IF NOT EXISTS projects (id TEXT PRIMARY KEY, name TEXT);");
        return true;
    }

    void DatabaseManager::Close() {
        // if (m_impl->db) sqlite3_close(m_impl->db);
    }

    bool DatabaseManager::ExecuteQuery(const std::string& query) {
        std::cout << "Executing SQL: " << query << std::endl;
        // sqlite3_exec(...)
        return true;
    }

    bool DatabaseManager::CreateProject(const std::string& name, const std::string& path) {
        std::string sql = "INSERT INTO projects (id, name) VALUES ('" + path + "', '" + name + "');";
        return ExecuteQuery(sql);
    }

}
