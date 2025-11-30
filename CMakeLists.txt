cmake_minimum_required(VERSION 3.20)

project(PicasooCore LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Global Compiler Flags
if(MSVC)
    add_compile_options(/W4 /permissive- /Zc:__cplusplus)
endif()

# Dependencies (via vcpkg)
find_package(fmt CONFIG REQUIRED)
find_package(spdlog CONFIG REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(unofficial-sqlite3 CONFIG REQUIRED)
# Add other find_packages as needed when implementing modules

# Subdirectories
add_subdirectory(native/common)
add_subdirectory(native/video_engine)
add_subdirectory(native/ipc)
add_subdirectory(native/node_runtime)
add_subdirectory(native/vfx_host)
add_subdirectory(native/color_engine)
add_subdirectory(native/audio_engine)
add_subdirectory(native/ai_engine)
add_subdirectory(native/database)
add_subdirectory(native/render_worker)
add_subdirectory(native/animation)
add_subdirectory(native/titling_engine)
add_subdirectory(native/timeline)
add_subdirectory(native/scripting)
add_subdirectory(native/cloud_client)
# add_subdirectory(native/panels)       # Uncomment when created

# Main Library / Executable definitions will go here or in subdirectories
