#pragma once

#include "TimelineModel.h"
#include <memory>

namespace picasoo::timeline {

    class TimelineManager {
    public:
        TimelineManager();
        ~TimelineManager();

        void CreateTimeline(const std::string& name);
        Timeline* GetActiveTimeline();

        void AddTrack();
        void AddClip(const std::string& assetPath, double startTime, double duration, int trackIndex);

        void SetUseProxy(bool enable);

    private:
        std::unique_ptr<Timeline> m_activeTimeline;
    };

}
