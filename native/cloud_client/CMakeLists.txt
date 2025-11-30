add_library(cloud_client STATIC)

target_sources(cloud_client PRIVATE
    src/CloudClient.cpp
)

target_include_directories(cloud_client PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(cloud_client PUBLIC
    common
    # cpr::cpr
)
