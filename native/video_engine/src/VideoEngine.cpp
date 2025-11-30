#include "VideoEngine.h"
#include <iostream>

extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libswscale/swscale.h>
}

namespace picasoo::video {

    struct VideoEngine::Impl {
        AVFormatContext* formatCtx = nullptr;
        AVCodecContext* codecCtx = nullptr;
        int videoStreamIndex = -1;
        AVFrame* frame = nullptr;
        AVPacket* packet = nullptr;
    };

    VideoEngine::VideoEngine() : m_impl(std::make_unique<Impl>()) {
        // av_register_all() is deprecated in newer ffmpeg, but good to know
    }

    VideoEngine::~VideoEngine() {
        CloseFile();
    }

    bool VideoEngine::OpenFile(const std::string& path) {
        CloseFile();

        m_impl->formatCtx = avformat_alloc_context();
        if (avformat_open_input(&m_impl->formatCtx, path.c_str(), nullptr, nullptr) != 0) {
            return false;
        }

        if (avformat_find_stream_info(m_impl->formatCtx, nullptr) < 0) {
            return false;
        }

        // Find video stream
        for (unsigned int i = 0; i < m_impl->formatCtx->nb_streams; i++) {
            if (m_impl->formatCtx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
                m_impl->videoStreamIndex = i;
                break;
            }
        }

        if (m_impl->videoStreamIndex == -1) return false;

        // Set up codec
        AVCodecParameters* codecPar = m_impl->formatCtx->streams[m_impl->videoStreamIndex]->codecpar;
        const AVCodec* codec = avcodec_find_decoder(codecPar->codec_id);
        if (!codec) return false;

        m_impl->codecCtx = avcodec_alloc_context3(codec);
        avcodec_parameters_to_context(m_impl->codecCtx, codecPar);

        if (avcodec_open2(m_impl->codecCtx, codec, nullptr) < 0) return false;

        m_impl->frame = av_frame_alloc();
        m_impl->packet = av_packet_alloc();

        return true;
    }

    void VideoEngine::CloseFile() {
        if (m_impl->frame) av_frame_free(&m_impl->frame);
        if (m_impl->packet) av_packet_free(&m_impl->packet);
        if (m_impl->codecCtx) avcodec_free_context(&m_impl->codecCtx);
        if (m_impl->formatCtx) avformat_close_input(&m_impl->formatCtx);
    }

    bool VideoEngine::GetNextFrame(common::Buffer& outBuffer, common::Size& outSize) {
        if (!m_impl->formatCtx) return false;

        while (av_read_frame(m_impl->formatCtx, m_impl->packet) >= 0) {
            if (m_impl->packet->stream_index == m_impl->videoStreamIndex) {
                int ret = avcodec_send_packet(m_impl->codecCtx, m_impl->packet);
                if (ret < 0) {
                    av_packet_unref(m_impl->packet);
                    return false;
                }

                ret = avcodec_receive_frame(m_impl->codecCtx, m_impl->frame);
                if (ret == 0) {
                    // Frame decoded
                    outSize.width = m_impl->frame->width;
                    outSize.height = m_impl->frame->height;
                    
                    // TODO: Convert to RGBA and copy to outBuffer
                    // For now, just return true to simulate success
                    av_packet_unref(m_impl->packet);
                    return true;
                }
            }
            av_packet_unref(m_impl->packet);
        }

        return false;
    }

}
