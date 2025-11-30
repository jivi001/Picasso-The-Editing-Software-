add_library(titling_engine STATIC)

target_sources(titling_engine PRIVATE
    src/TextRenderer.cpp
)

target_include_directories(titling_engine PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(titling_engine PUBLIC
    common
    # freetype
)
