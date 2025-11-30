#pragma once

#include <string>
#include <functional>
#include <thread>
#include <atomic>

namespace picasoo::ipc {

    class IpcServer {
    public:
        using MessageCallback = std::function<void(const std::string&)>;

        IpcServer(const std::string& pipeName);
        ~IpcServer();

        void Start();
        void Stop();
        void Send(const std::string& message);
        void SetCallback(MessageCallback callback);

    private:
        void ListenLoop();

        std::string m_pipeName;
        std::atomic<bool> m_running;
        std::thread m_thread;
        MessageCallback m_callback;
        void* m_pipeHandle; // HANDLE in Windows
    };

}
