import 'package:flutter/material.dart';

class DeliverPageWidget extends StatelessWidget {
  const DeliverPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Render Settings
        Container(
          width: 300,
          color: Colors.grey[850],
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Render Settings', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildDropdown('Format', ['MP4', 'MOV', 'AVI']),
              const SizedBox(height: 10),
              _buildDropdown('Codec', ['H.264', 'H.265', 'ProRes']),
              const SizedBox(height: 10),
              _buildDropdown('Resolution', ['1920x1080 HD', '3840x2160 UHD']),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {}, // TODO: Trigger Render
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Add to Render Queue'),
                ),
              ),
            ],
          ),
        ),
        // Preview / Queue
        Expanded(
          child: Container(
            color: Colors.black,
            child: const Center(child: Text('Render Queue Placeholder', style: TextStyle(color: Colors.white54))),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)),
          child: DropdownButton<String>(
            value: items.first,
            isExpanded: true,
            dropdownColor: Colors.grey[800],
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {},
          ),
        ),
      ],
    );
  }
}
