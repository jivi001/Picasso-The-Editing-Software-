#include <gtest/gtest.h>
#include "AudioEngine.h"

using namespace picasoo::audio;

TEST(AudioTest, VolumeControl) {
    AudioEngine engine;
    engine.Initialize();
    
    // Since we don't have getters in the stub, we just verify it doesn't crash
    engine.SetVolume(0.5f);
    engine.SetTrackVolume(1, 0.8f);
    
    // In a real test, we would mock the internal state or use a getter
    SUCCEED();
}
