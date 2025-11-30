add_library(timeline STATIC)

target_sources(timeline PRIVATE
    src/TimelineManager.cpp
)

target_include_directories(timeline PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(timeline PUBLIC
    common
)
