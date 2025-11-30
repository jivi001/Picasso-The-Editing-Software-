import 'package:flutter/material.dart';

class ReviewPanelWidget extends StatelessWidget {
  const ReviewPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey[850],
          child: const Text('Comments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(backgroundColor: Colors.blue, child: Text('U$index')),
                title: Text('User $index', style: const TextStyle(color: Colors.white)),
                subtitle: const Text('Please fix the audio here.', style: TextStyle(color: Colors.white70)),
                trailing: Text('00:1${index * 5}', style: const TextStyle(color: Colors.grey)),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey[900],
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(icon: const Icon(Icons.send, color: Colors.blue), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }
}
