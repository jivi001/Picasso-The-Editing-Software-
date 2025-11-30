#pragma once

#include <vector>
#include <algorithm>
#include <cmath>

namespace picasoo::animation {

    enum class InterpolationType {
        Linear,
        Bezier,
        Constant
    };

    struct Keyframe {
        double time;
        double value;
        InterpolationType type;
        
        // Bezier handles (normalized 0..1 relative to segment)
        double inHandleX = 0.0, inHandleY = 0.0;
        double outHandleX = 1.0, outHandleY = 1.0;
    };

    class AnimationTrack {
    public:
        void AddKeyframe(double time, double value, InterpolationType type = InterpolationType::Linear);
        double GetValueAt(double time) const;

    private:
        std::vector<Keyframe> m_keys;
    };

}
