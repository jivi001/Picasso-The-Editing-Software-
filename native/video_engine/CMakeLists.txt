add_library(video_engine STATIC)

target_sources(video_engine PRIVATE
    src/VideoEngine.cpp
)

target_include_directories(video_engine PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(video_engine PUBLIC
    common
    # FFmpeg libraries (linked via vcpkg targets usually, e.g. FFmpeg::avcodec)
    # For now assuming they are available globally or via variables
)
