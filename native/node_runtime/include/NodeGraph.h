#pragma once

#include "common_types.h"
#include <vector>
#include <string>
#include <map>
#include <memory>
#include <functional>

namespace picasoo::node {

    struct Pin {
        std::string id;
        std::string name;
        enum class Type { Input, Output } type;
        common::DataType dataType; // Assuming DataType is in common_types or similar
        // Value holder...
    };

    class Node {
    public:
        virtual ~Node() = default;
        virtual void Execute() = 0;

        std::string id;
        std::string name;
        std::vector<Pin> inputs;
        std::vector<Pin> outputs;
    };

    class NodeGraph {
    public:
        void AddNode(std::shared_ptr<Node> node);
        void RemoveNode(const std::string& nodeId);
        void Connect(const std::string& outPinId, const std::string& inPinId);
        void Execute();

    private:
        std::vector<std::shared_ptr<Node>> m_nodes;
        // Adjacency list or similar for connections
        std::map<std::string, std::string> m_connections; // InputPinID -> OutputPinID
    };

}
