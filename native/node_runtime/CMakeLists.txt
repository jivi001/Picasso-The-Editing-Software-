add_library(node_runtime STATIC)

target_sources(node_runtime PRIVATE
    src/NodeGraph.cpp
)

target_include_directories(node_runtime PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(node_runtime PUBLIC
    common
)
