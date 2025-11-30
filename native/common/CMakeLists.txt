add_library(common STATIC)

target_sources(common PRIVATE
    # No cpp files yet, just headers for now
)

target_include_directories(common PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(common PUBLIC
    fmt::fmt
    spdlog::spdlog
    nlohmann_json::nlohmann_json
)
