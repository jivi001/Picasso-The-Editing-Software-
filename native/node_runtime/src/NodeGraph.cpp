#include "NodeGraph.h"
#include <algorithm>
#include <iostream>

namespace picasoo::node {

    void NodeGraph::AddNode(std::shared_ptr<Node> node) {
        m_nodes.push_back(node);
    }

    void NodeGraph::RemoveNode(const std::string& nodeId) {
        m_nodes.erase(std::remove_if(m_nodes.begin(), m_nodes.end(), 
            [&](const std::shared_ptr<Node>& n) { return n->id == nodeId; }), m_nodes.end());
    }

    void NodeGraph::Connect(const std::string& outPinId, const std::string& inPinId) {
        m_connections[inPinId] = outPinId;
    }

    void NodeGraph::Execute() {
        // Topological sort would go here.
        // For now, just execute all nodes in order (naive).
        for (auto& node : m_nodes) {
            node->Execute();
        }
    }

}
