#include "TimelineManager.h"
#include <iostream>

namespace picasoo::timeline {

    void Timeline::AddTrack(const std::string& name) {
        Track t;
        t.id = std::to_string(tracks.size());
        t.name = name;
        tracks.push_back(t);
    }

    void Timeline::AddClip(int trackIndex, const Clip& clip) {
        if (trackIndex >= 0 && trackIndex < tracks.size()) {
            tracks[trackIndex].clips.push_back(clip);
        }
    }

    TimelineManager::TimelineManager() {}
    TimelineManager::~TimelineManager() {}

    void TimelineManager::CreateTimeline(const std::string& name) {
        m_activeTimeline = std::make_unique<Timeline>();
        m_activeTimeline->name = name;
        m_activeTimeline->id = "tl_1";
        std::cout << "Created Timeline: " << name << std::endl;
    }

    Timeline* TimelineManager::GetActiveTimeline() {
        return m_activeTimeline.get();
    }

    void TimelineManager::AddTrack() {
        if (m_activeTimeline) {
            m_activeTimeline->AddTrack("Video " + std::to_string(m_activeTimeline->tracks.size() + 1));
        }
    }

    void TimelineManager::AddClip(const std::string& assetPath, double startTime, double duration, int trackIndex) {
        if (m_activeTimeline) {
            Clip c;
            c.id = "clip_" + std::to_string(rand());
            c.assetPath = assetPath;
            c.startTime = startTime;
            c.duration = duration;
            c.offset = 0.0;
            c.trackIndex = trackIndex;
            
            m_activeTimeline->AddClip(trackIndex, c);
            std::cout << "Added Clip: " << assetPath << " at " << startTime << "s" << std::endl;
        }
    }

    void TimelineManager::SetUseProxy(bool enable) {
        std::cout << "Proxy Mode: " << (enable ? "ENABLED" : "DISABLED") << std::endl;
        // In a real implementation, this would iterate over all clips and swap assetPath 
        // with the corresponding proxy path (e.g. /proxies/clip_name_proxy.mp4)
    }

}
