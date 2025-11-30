import 'package:flutter/material.dart';
import 'node_model.dart';

class NodeWidget extends StatelessWidget {
  final NodeModel node;
  final Function(NodeModel, Offset) onDragUpdate;

  const NodeWidget({
    super.key,
    required this.node,
    required this.onDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          onDragUpdate(node, details.delta);
        },
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[600]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Text(
                  node.name,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              // Pins
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Inputs
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          node.inputs.map((pin) => _buildPin(pin)).toList(),
                    ),
                    // Outputs
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:
                          node.outputs.map((pin) => _buildPin(pin)).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPin(PinModel pin) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pin.type == PinType.input) _pinCircle(),
          const SizedBox(width: 4),
          Text(pin.name,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(width: 4),
          if (pin.type == PinType.output) _pinCircle(),
        ],
      ),
    );
  }

  Widget _pinCircle() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }
}
