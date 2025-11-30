#include "RenderWorker.h"
#include <iostream>
#include <cstdlib>

namespace picasoo::render {

    RenderWorker::RenderWorker() {}

    RenderWorker::~RenderWorker() {
        Stop();
    }

    void RenderWorker::Start() {
        m_running = true;
        m_thread = std::thread(&RenderWorker::WorkerLoop, this);
    }

    void RenderWorker::Stop() {
        m_running = false;
        m_cv.notify_all();
        if (m_thread.joinable()) {
            m_thread.join();
        }
    }

    void RenderWorker::AddJob(const RenderJob& job) {
        {
            std::lock_guard<std::mutex> lock(m_mutex);
            m_queue.push(job);
        }
        m_cv.notify_one();
    }

    void RenderWorker::WorkerLoop() {
        while (m_running) {
            RenderJob job;
            {
                std::unique_lock<std::mutex> lock(m_mutex);
                m_cv.wait(lock, [this] { return !m_queue.empty() || !m_running; });

                if (!m_running && m_queue.empty()) break;

                job = m_queue.front();
                m_queue.pop();
            }

            std::cout << "Processing Render Job: " << job.id << std::endl;
            
            // Construct FFmpeg command
            // ffmpeg -i input -c:v prores_ks -profile:v 0 -q:v 4 -c:a copy -s 960x540 output
            std::string cmd = "ffmpeg -y -i \"" + job.inputPath + "\" -c:v prores_ks -profile:v 0 -q:v 4 -c:a copy -s 960x540 \"" + job.outputPath + "\"";
            
            std::cout << "Executing: " << cmd << std::endl;
            int ret = std::system(cmd.c_str());
            
            if (ret == 0) {
                std::cout << "Job Completed: " << job.id << std::endl;
            } else {
                std::cout << "Job Failed: " << job.id << std::endl;
            }
        }
    }

}
