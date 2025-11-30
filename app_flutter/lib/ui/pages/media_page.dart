import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PicasooColors.surface0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: PicasooColors.primary),
            const SizedBox(height: 16),
            Text('Media Page', style: PicasooTypography.display),
            const SizedBox(height: 8),
            Text('Media management coming soon', style: PicasooTypography.body),
          ],
        ),
      ),
    );
  }
}
