import 'package:flutter/material.dart';
import '../audio/audio_mixer_widget.dart';

class AudioPageWidget extends StatelessWidget {
  const AudioPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timeline / Waveform View
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey[900],
            child: const Center(child: Text('Audio Timeline', style: TextStyle(color: Colors.white54))),
          ),
        ),
        // Mixer
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey[850],
            child: const AudioMixerWidget(),
          ),
        ),
      ],
    );
  }
}
