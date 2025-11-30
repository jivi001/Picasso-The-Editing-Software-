enable_testing()

add_executable(picasoo_tests
    src/TimelineTests.cpp
    src/AudioTests.cpp
)

target_link_libraries(picasoo_tests PRIVATE
    timeline
    audio_engine
    GTest::gtest_main
)

add_test(NAME CoreTests COMMAND picasoo_tests)
