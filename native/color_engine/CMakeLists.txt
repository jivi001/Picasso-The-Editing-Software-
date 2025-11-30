add_library(color_engine STATIC)

target_sources(color_engine PRIVATE
    src/ColorProcessor.cpp
)

target_include_directories(color_engine PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(color_engine PUBLIC
    common
    # OpenColorIO::OpenColorIO
)
