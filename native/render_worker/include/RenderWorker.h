#pragma once

#include <string>
#include <functional>
#include <queue>
#include <thread>
#include <mutex>
#include <condition_variable>

namespace picasoo::render {

    struct RenderJob {
        std::string id;
        std::string inputPath;
        std::string outputPath;
        // ... format settings
    };

    class RenderWorker {
    public:
        RenderWorker();
        ~RenderWorker();

        void Start();
        void Stop();
        
        void AddJob(const RenderJob& job);

    private:
        void WorkerLoop();

        std::queue<RenderJob> m_queue;
        std::mutex m_mutex;
        std::condition_variable m_cv;
        std::thread m_thread;
        bool m_running = false;
    };

}
