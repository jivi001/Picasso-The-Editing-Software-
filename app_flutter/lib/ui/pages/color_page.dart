import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PicasooColors.surface0,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.palette, size: 64, color: PicasooColors.secondary),
            SizedBox(height: 16),
            Text('Color Page', style: PicasooTypography.display),
            SizedBox(height: 8),
            Text('Color grading tools coming soon',
                style: PicasooTypography.body),
          ],
        ),
      ),
    );
  }
}
