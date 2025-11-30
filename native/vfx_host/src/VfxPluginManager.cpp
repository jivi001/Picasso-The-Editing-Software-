#include "VfxPluginManager.h"
#include <windows.h>
#include <filesystem>
#include <iostream>

namespace picasoo::vfx {

    // Host Suite Fetcher (Dummy for now)
    void* FetchSuite(OfxPropertySetHandle host, const char* suiteName, int suiteVersion) {
        std::cout << "Plugin requested suite: " << suiteName << std::endl;
        return nullptr;
    }

    VfxPluginManager::VfxPluginManager() {
        m_host.host = nullptr; // TODO: Create property set
        m_host.fetchSuite = FetchSuite;
    }

    VfxPluginManager::~VfxPluginManager() {
        for (auto& lib : m_loadedLibraries) {
            if (lib.dllHandle) {
                FreeLibrary((HMODULE)lib.dllHandle);
            }
        }
    }

    void VfxPluginManager::LoadPlugins(const std::string& directory) {
        namespace fs = std::filesystem;
        if (!fs::exists(directory)) return;

        for (const auto& entry : fs::directory_iterator(directory)) {
            if (entry.path().extension() == ".ofx" || entry.path().extension() == ".dll") {
                HMODULE handle = LoadLibraryA(entry.path().string().c_str());
                if (!handle) continue;

                // OFX uses specific export names, usually defined by the bundle structure
                // But for a flat DLL, we look for OfxGetPlugin
                // Real OFX host logic is more complex (bundle parsing)
                
                // Simplified: Just check if we can load it
                std::cout << "Loaded plugin library: " << entry.path().string() << std::endl;
                
                PluginLib lib;
                lib.dllHandle = handle;
                lib.library = nullptr; // Needs proper casting and function finding
                m_loadedLibraries.push_back(lib);
            }
        }
    }

    std::vector<std::string> VfxPluginManager::GetLoadedPluginNames() {
        std::vector<std::string> names;
        for (const auto& lib : m_loadedLibraries) {
            names.push_back("Loaded Plugin (Unknown ID)");
        }
        return names;
    }

}
