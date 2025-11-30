import 'package:flutter/material.dart';

class MediaPoolWidget extends StatelessWidget {
  const MediaPoolWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: const Icon(Icons.movie, color: Colors.white54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Clip $index.mp4',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
