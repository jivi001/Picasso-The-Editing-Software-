import 'package:flutter/material.dart';

class MultiCamViewerWidget extends StatelessWidget {
  const MultiCamViewerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: List.generate(4, (index) {
        return Container(
          color: Colors.black,
          child: Stack(
            children: [
              Center(
                child: Text(
                  'Angle ${index + 1}',
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  color: Colors.red,
                  child: Text('CAM ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
