import 'package:flutter/material.dart';
import 'fader_widget.dart';

class AudioMixerWidget extends StatelessWidget {
  const AudioMixerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 8, // 8 Tracks
      itemBuilder: (context, index) {
        return Container(
          width: 80,
          border: Border(right: BorderSide(color: Colors.black.withOpacity(0.5))),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text('Track ${index + 1}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              const Expanded(child: FaderWidget()),
              const SizedBox(height: 8),
              const Text('0.0 dB', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        );
      },
    );
  }
}
