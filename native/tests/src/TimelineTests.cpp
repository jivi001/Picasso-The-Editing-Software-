#include <gtest/gtest.h>
#include "TimelineManager.h"

using namespace picasoo::timeline;

TEST(TimelineTest, CreateTimeline) {
    TimelineManager manager;
    manager.CreateTimeline("Test Project");
    
    Timeline* tl = manager.GetActiveTimeline();
    ASSERT_NE(tl, nullptr);
    EXPECT_EQ(tl->name, "Test Project");
}

TEST(TimelineTest, AddTrack) {
    TimelineManager manager;
    manager.CreateTimeline("Test Project");
    manager.AddTrack();
    
    Timeline* tl = manager.GetActiveTimeline();
    EXPECT_EQ(tl->tracks.size(), 1);
}

TEST(TimelineTest, AddClip) {
    TimelineManager manager;
    manager.CreateTimeline("Test Project");
    manager.AddTrack();
    manager.AddClip("/path/to/video.mp4", 0.0, 10.0, 0);
    
    Timeline* tl = manager.GetActiveTimeline();
    ASSERT_FALSE(tl->tracks.empty());
    EXPECT_EQ(tl->tracks[0].clips.size(), 1);
    EXPECT_EQ(tl->tracks[0].clips[0].duration, 10.0);
}
