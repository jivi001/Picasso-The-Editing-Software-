add_library(ai_engine STATIC)

target_sources(ai_engine PRIVATE
    src/AiEngine.cpp
)

target_include_directories(ai_engine PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(ai_engine PUBLIC
    common
    # onnxruntime
)
