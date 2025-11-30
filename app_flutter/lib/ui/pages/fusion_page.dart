import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

class FusionPage extends StatelessWidget {
  const FusionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PicasooColors.surface0,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hub, size: 64, color: PicasooColors.info),
            SizedBox(height: 16),
            Text('Fusion Page', style: PicasooTypography.display),
            SizedBox(height: 8),
            Text('Node-based compositing coming soon',
                style: PicasooTypography.body),
          ],
        ),
      ),
    );
  }
}
