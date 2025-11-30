#pragma once

#include <string>
#include <memory>

namespace picasoo::scripting {

    class ScriptEngine {
    public:
        ScriptEngine();
        ~ScriptEngine();

        bool Initialize();
        bool RunScript(const std::string& script);
        
        // Register a function to be called from Lua
        // void RegisterFunction(const std::string& name, ...);

    private:
        struct Impl;
        std::unique_ptr<Impl> m_impl;
    };

}
