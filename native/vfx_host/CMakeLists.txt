add_library(vfx_host STATIC)

target_sources(vfx_host PRIVATE
    src/VfxPluginManager.cpp
)

target_include_directories(vfx_host PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(vfx_host PUBLIC
    common
)
