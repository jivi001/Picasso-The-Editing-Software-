#include "Keyframe.h"

namespace picasoo::animation {

    void AnimationTrack::AddKeyframe(double time, double value, InterpolationType type) {
        Keyframe k;
        k.time = time;
        k.value = value;
        k.type = type;
        
        // Insert sorted
        auto it = std::lower_bound(m_keys.begin(), m_keys.end(), k, [](const Keyframe& a, const Keyframe& b) {
            return a.time < b.time;
        });
        m_keys.insert(it, k);
    }

    double AnimationTrack::GetValueAt(double time) const {
        if (m_keys.empty()) return 0.0;
        if (time <= m_keys.front().time) return m_keys.front().value;
        if (time >= m_keys.back().time) return m_keys.back().value;

        // Find segment
        auto it = std::upper_bound(m_keys.begin(), m_keys.end(), time, [](double t, const Keyframe& k) {
            return t < k.time;
        });
        
        const Keyframe& p1 = *std::prev(it);
        const Keyframe& p2 = *it;

        double t = (time - p1.time) / (p2.time - p1.time);

        if (p1.type == InterpolationType::Constant) {
            return p1.value;
        } else if (p1.type == InterpolationType::Linear) {
            return p1.value + (p2.value - p1.value) * t;
        } else if (p1.type == InterpolationType::Bezier) {
            // Simple Cubic Bezier (1D) approximation for demo
            // Real implementation needs 2D curve solving for time remapping
            double t2 = t * t;
            double t3 = t2 * t;
            double mt = 1 - t;
            double mt2 = mt * mt;
            double mt3 = mt2 * mt;
            
            // P0=0, P1=outHandle, P2=inHandle, P3=1
            // This is just the easing curve (0..1)
            double ease = 3 * p1.outHandleY * mt2 * t + 3 * (1.0 - p2.inHandleY) * mt * t2 + t3;
            
            return p1.value + (p2.value - p1.value) * ease;
        }

        return p1.value;
    }

}
