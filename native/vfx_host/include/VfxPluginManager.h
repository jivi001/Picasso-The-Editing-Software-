#pragma once

#include "ofx_core.h"
#include <string>
#include <vector>
#include <memory>

namespace picasoo::vfx {

    class VfxPluginManager {
    public:
        VfxPluginManager();
        ~VfxPluginManager();

        void LoadPlugins(const std::string& directory);
        std::vector<std::string> GetLoadedPluginNames();

    private:
        struct PluginLib {
            void* dllHandle;
            OfxPluginLibrary* library;
        };
        std::vector<PluginLib> m_loadedLibraries;
        OfxHost m_host;
    };

}
