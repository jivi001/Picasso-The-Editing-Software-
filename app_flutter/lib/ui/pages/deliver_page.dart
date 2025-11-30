import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

class DeliverPage extends StatelessWidget {
  const DeliverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PicasooColors.surface0,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, size: 64, color: PicasooColors.success),
            SizedBox(height: 16),
            Text('Deliver Page', style: PicasooTypography.display),
            SizedBox(height: 8),
            Text('Export and delivery tools coming soon',
                style: PicasooTypography.body),
          ],
        ),
      ),
    );
  }
}
