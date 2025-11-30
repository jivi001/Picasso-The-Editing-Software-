import 'package:flutter/material.dart';
import 'node_model.dart';
import 'node_widget.dart';

class NodeGraphWidget extends StatefulWidget {
  const NodeGraphWidget({super.key});

  @override
  State<NodeGraphWidget> createState() => _NodeGraphWidgetState();
}

class _NodeGraphWidgetState extends State<NodeGraphWidget> {
  final List<NodeModel> nodes = [];
  final List<ConnectionModel> connections = [];
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    // Add dummy nodes for testing
    nodes.add(NodeModel(
      id: '1',
      name: 'Media In',
      position: const Offset(100, 100),
      outputs: [PinModel(id: 'p1', nodeId: '1', name: 'Image', type: PinType.output, dataType: DataType.image)],
    ));
    nodes.add(NodeModel(
      id: '2',
      name: 'Blur',
      position: const Offset(300, 150),
      inputs: [PinModel(id: 'p2', nodeId: '2', name: 'Input', type: PinType.input, dataType: DataType.image)],
      outputs: [PinModel(id: 'p3', nodeId: '2', name: 'Output', type: PinType.output, dataType: DataType.image)],
    ));
    nodes.add(NodeModel(
      id: '3',
      name: 'Media Out',
      position: const Offset(500, 100),
      inputs: [PinModel(id: 'p4', nodeId: '3', name: 'Image', type: PinType.input, dataType: DataType.image)],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
        });
      },
      child: ClipRect(
        child: Stack(
          children: [
            // Grid Background (CustomPainter could go here)
            Container(color: const Color(0xFF1E1E1E)),
            
            // Connections
            CustomPaint(
              size: Size.infinite,
              painter: ConnectionPainter(nodes: nodes, connections: connections, offset: _offset),
            ),

            // Nodes
            ...nodes.map((node) {
              // Apply global offset to node position for rendering
              final renderPos = node.position + _offset;
              // We need a way to update the actual node position relative to the canvas, not just visual
              // For now, let's just render them at stored position + canvas offset
              return Positioned(
                left: renderPos.dx,
                top: renderPos.dy,
                child: GestureDetector(
                   onPanUpdate: (details) {
                      setState(() {
                        node.position += details.delta;
                      });
                   },
                   child: NodeWidget(
                    node: node, // Pass the model, but we override position in the stack
                    onDragUpdate: (n, delta) {
                       // This callback is actually redundant if we wrap NodeWidget in GestureDetector here
                       // But let's keep it for cleaner architecture later
                    },
                  ).build(context), // HACK: Re-using build to avoid wrapping again, but better to just use NodeWidget normally
               ),
              );
            }).toList(),
             
             // Correct way:
             ...nodes.map((node) => NodeWidget(
               node: NodeModel(
                 id: node.id, 
                 name: node.name, 
                 position: node.position + _offset, // Render with offset
                 inputs: node.inputs,
                 outputs: node.outputs
               ),
               onDragUpdate: (n, delta) {
                 setState(() {
                   // Update the REAL position (without offset)
                   final index = nodes.indexWhere((element) => element.id == n.id);
                   if (index != -1) {
                     nodes[index].position += delta;
                   }
                 });
               },
             )),
          ],
        ),
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  final List<NodeModel> nodes;
  final List<ConnectionModel> connections;
  final Offset offset;

  ConnectionPainter({required this.nodes, required this.connections, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var connection in connections) {
      // Find positions (simplified)
      // In real app, we'd calculate exact pin positions
      final outNode = nodes.firstWhere((n) => n.outputs.any((p) => p.id == connection.outputPinId), orElse: () => nodes[0]);
      final inNode = nodes.firstWhere((n) => n.inputs.any((p) => p.id == connection.inputPinId), orElse: () => nodes[0]);

      final start = outNode.position + const Offset(150, 40) + offset; // Approx output pin pos
      final end = inNode.position + const Offset(0, 40) + offset; // Approx input pin pos

      final path = Path();
      path.moveTo(start.dx, start.dy);
      path.cubicTo(
        start.dx + 50, start.dy,
        end.dx - 50, end.dy,
        end.dx, end.dy
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
