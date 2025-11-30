add_library(animation STATIC)

target_sources(animation PRIVATE
    src/AnimationTrack.cpp
)

target_include_directories(animation PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(animation PUBLIC
    common
)
