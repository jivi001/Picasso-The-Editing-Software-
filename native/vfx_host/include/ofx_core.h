#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#define OfxGetEnvHost 0
#define OfxSetHost 1

typedef struct OfxHost* OfxHostHandle;
typedef struct OfxImageEffect* OfxImageEffectHandle;
typedef struct OfxPropertySet* OfxPropertySetHandle;

typedef struct OfxHost {
    OfxPropertySetHandle host;
    void* (*fetchSuite)(OfxPropertySetHandle host, const char* suiteName, int suiteVersion);
} OfxHost;

typedef struct OfxPlugin {
    const char* pluginApi;
    int apiVersion;
    const char* pluginIdentifier;
    unsigned int pluginVersionMajor;
    unsigned int pluginVersionMinor;
    void (*setHost)(OfxHost* host);
    // ... more function pointers
} OfxPlugin;

typedef struct OfxPluginLibrary {
    int (*getNumberOfPlugins)(void);
    OfxPlugin* (*getPlugin)(int index);
} OfxPluginLibrary;

#ifdef __cplusplus
}
#endif
