#include "IpcServer.h"
#include <windows.h>
#include <iostream>

namespace picasoo::ipc {

    IpcServer::IpcServer(const std::string& pipeName) 
        : m_pipeName("\\\\.\\pipe\\" + pipeName), m_running(false), m_pipeHandle(INVALID_HANDLE_VALUE) {}

    IpcServer::~IpcServer() {
        Stop();
    }

    void IpcServer::Start() {
        if (m_running) return;
        m_running = true;
        m_thread = std::thread(&IpcServer::ListenLoop, this);
    }

    void IpcServer::Stop() {
        m_running = false;
        if (m_pipeHandle != INVALID_HANDLE_VALUE) {
            CloseHandle(m_pipeHandle);
            m_pipeHandle = INVALID_HANDLE_VALUE;
        }
        if (m_thread.joinable()) {
            m_thread.join();
        }
    }

    void IpcServer::Send(const std::string& message) {
        if (m_pipeHandle == INVALID_HANDLE_VALUE) return;
        
        DWORD bytesWritten;
        WriteFile(m_pipeHandle, message.c_str(), static_cast<DWORD>(message.size()), &bytesWritten, NULL);
    }

    void IpcServer::SetCallback(MessageCallback callback) {
        m_callback = callback;
    }

    void IpcServer::ListenLoop() {
        while (m_running) {
            m_pipeHandle = CreateNamedPipeA(
                m_pipeName.c_str(),
                PIPE_ACCESS_DUPLEX,
                PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,
                1,
                1024 * 16,
                1024 * 16,
                0,
                NULL
            );

            if (m_pipeHandle == INVALID_HANDLE_VALUE) {
                // Log error
                std::this_thread::sleep_for(std::chrono::seconds(1));
                continue;
            }

            if (ConnectNamedPipe(m_pipeHandle, NULL) != FALSE) {
                char buffer[1024];
                DWORD bytesRead;
                while (ReadFile(m_pipeHandle, buffer, sizeof(buffer) - 1, &bytesRead, NULL) != FALSE) {
                    buffer[bytesRead] = '\0';
                    if (m_callback) {
                        m_callback(std::string(buffer));
                    }
                }
            }

            CloseHandle(m_pipeHandle);
            m_pipeHandle = INVALID_HANDLE_VALUE;
        }
    }

}
