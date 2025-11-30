#pragma once

#include "common_types.h"
#include <string>
#include <vector>
#include <memory>
#include <functional>

namespace picasoo::audio {

    class AudioEngine {
    public:
        AudioEngine();
        ~AudioEngine();

        bool Initialize();
        void Shutdown();

        // Load an audio file into memory (simplified for now)
        bool LoadTrack(const std::string& path, int trackId);
        
        void Play();
        void Pause();
        void SetVolume(float volume);

        // Track Control
        void SetTrackVolume(int trackId, float volume);
        void SetTrackPan(int trackId, float pan);
        float GetPeakLevel(int trackId);

        // Callback for audio processing (e.g. for waveform generation)
        using AudioCallback = std::function<void(const std::vector<float>& buffer)>;
        void SetProcessCallback(AudioCallback callback);

    private:
        struct Impl;
        std::unique_ptr<Impl> m_impl;
    };

}
