import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

class MediaPoolWidget extends StatelessWidget {
  const MediaPoolWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: PicasooColors.surface2,
          child: Row(
            children: [
              Text('Media Pool', style: PicasooTypography.h2),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.search, size: 16),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.grid_view, size: 16),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        // Grid
        Expanded(
          child: Container(
            color: PicasooColors.surface1,
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 120,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 20, // Placeholder count
              itemBuilder: (context, index) {
                return _MediaItem(index: index);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MediaItem extends StatefulWidget {
  final int index;

  const _MediaItem({required this.index});

  @override
  State<_MediaItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<_MediaItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Container(
        decoration: BoxDecoration(
          color: PicasooColors.surface2,
          borderRadius: BorderRadius.circular(4),
          border: _isHovering
              ? Border.all(color: PicasooColors.primary, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(2)),
                ),
                child: const Center(
                  child: Icon(Icons.movie, color: PicasooColors.textLow),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                'Clip ${widget.index + 1}.mp4',
                style: PicasooTypography.small,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
