add_library(ipc STATIC)

target_sources(ipc PRIVATE
    src/IpcServer.cpp
)

target_include_directories(ipc PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(ipc PUBLIC
    common
)
