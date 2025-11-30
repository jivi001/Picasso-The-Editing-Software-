add_library(scripting STATIC)

target_sources(scripting PRIVATE
    src/ScriptEngine.cpp
)

target_include_directories(scripting PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(scripting PUBLIC
    common
    # lua
)
