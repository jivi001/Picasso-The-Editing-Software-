import 'package:flutter/material.dart';

enum PinType { input, output }
enum DataType { image, float, vector }

class PinModel {
  final String id;
  final String nodeId;
  final String name;
  final PinType type;
  final DataType dataType;

  PinModel({
    required this.id,
    required this.nodeId,
    required this.name,
    required this.type,
    required this.dataType,
  });
}

class NodeModel {
  final String id;
  String name;
  Offset position;
  final List<PinModel> inputs;
  final List<PinModel> outputs;

  NodeModel({
    required this.id,
    required this.name,
    required this.position,
    this.inputs = const [],
    this.outputs = const [],
  });
}

class ConnectionModel {
  final String outputPinId;
  final String inputPinId;

  ConnectionModel({required this.outputPinId, required this.inputPinId});
}
