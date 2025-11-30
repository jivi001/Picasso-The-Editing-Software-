#include "ScriptEngine.h"
#include <iostream>

// #include <lua.hpp>

namespace picasoo::scripting {

    struct ScriptEngine::Impl {
        // lua_State* L;
    };

    ScriptEngine::ScriptEngine() : m_impl(std::make_unique<Impl>()) {}

    ScriptEngine::~ScriptEngine() {
        // if (m_impl->L) lua_close(m_impl->L);
    }

    bool ScriptEngine::Initialize() {
        std::cout << "Initializing Script Engine (Lua)..." << std::endl;
        // m_impl->L = luaL_newstate();
        // luaL_openlibs(m_impl->L);
        return true;
    }

    bool ScriptEngine::RunScript(const std::string& script) {
        std::cout << "Running Lua Script: " << script << std::endl;
        // int ret = luaL_dostring(m_impl->L, script.c_str());
        // if (ret != LUA_OK) { ... error handling ... }
        return true;
    }

}
