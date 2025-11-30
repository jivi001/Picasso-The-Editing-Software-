add_library(render_worker STATIC)

target_sources(render_worker PRIVATE
    src/RenderWorker.cpp
)

target_include_directories(render_worker PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(render_worker PUBLIC
    common
)
