add_library(audio_engine STATIC)

target_sources(audio_engine PRIVATE
    src/AudioEngine.cpp
)

target_include_directories(audio_engine PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(audio_engine PUBLIC
    common
    # PortAudio::PortAudio
)
