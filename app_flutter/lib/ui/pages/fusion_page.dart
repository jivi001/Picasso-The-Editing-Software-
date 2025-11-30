import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

class FusionPage extends StatelessWidget {
  const FusionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PicasooColors.surface0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hub, size: 64, color: PicasooColors.info),
            const SizedBox(height: 16),
            Text('Fusion Page', style: PicasooTypography.display),
            const SizedBox(height: 8),
            Text('Node-based compositing coming soon',
                style: PicasooTypography.body),
          ],
        ),
      ),
    );
  }
}
