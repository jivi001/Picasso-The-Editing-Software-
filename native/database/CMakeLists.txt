add_library(database STATIC)

target_sources(database PRIVATE
    src/DatabaseManager.cpp
)

target_include_directories(database PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(database PUBLIC
    common
    # sqlite3
)
