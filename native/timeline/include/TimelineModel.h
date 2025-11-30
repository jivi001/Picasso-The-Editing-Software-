#pragma once

#include <string>
#include <vector>
#include <memory>

namespace picasoo::timeline {

    struct Clip {
        std::string id;
        std::string name;
        std::string assetPath;
        double startTime; // In seconds
        double duration;  // In seconds
        double offset;    // Source offset
        int trackIndex;
    };

    struct Track {
        std::string id;
        std::string name;
        std::vector<Clip> clips;
    };

    class Timeline {
    public:
        std::string id;
        std::string name;
        std::vector<Track> tracks;
        
        void AddTrack(const std::string& name);
        void AddClip(int trackIndex, const Clip& clip);
    };

}
