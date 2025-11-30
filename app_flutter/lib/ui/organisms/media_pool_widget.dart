import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';
import '../../core/project_state.dart';

class MediaPoolWidget extends StatefulWidget {
  const MediaPoolWidget({super.key});

  @override
  State<MediaPoolWidget> createState() => _MediaPoolWidgetState();
}

class _MediaPoolWidgetState extends State<MediaPoolWidget> {
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaPool = context.watch<ProjectState>().mediaPool;
    final filteredMedia = mediaPool.where((file) {
      return path.basename(file.path).toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      children: [
        // Header
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: PicasooColors.surface2,
          child: Row(
            children: [
              const Text('Media Pool', style: PicasooTypography.h2),
              const SizedBox(width: 16),
              // Search Bar
              Expanded(
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: PicasooColors.surface1,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: PicasooColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search,
                          size: 16, color: PicasooColors.textMed),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                                color: PicasooColors.textLow, fontSize: 12),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                              color: PicasooColors.textHigh, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // View Toggle
              IconButton(
                icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view,
                    size: 16, color: PicasooColors.textMed),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
                tooltip:
                    _isGridView ? 'Switch to List View' : 'Switch to Grid View',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: Container(
            color: PicasooColors.surface1,
            child: filteredMedia.isEmpty
                ? Center(
                    child: Text(
                      mediaPool.isEmpty
                          ? 'No media imported.\nGo to Media page to add files.'
                          : 'No matches found.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: PicasooColors.textLow),
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: filteredMedia.length,
                        itemBuilder: (context, index) {
                          return _MediaItemGrid(file: filteredMedia[index]);
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredMedia.length,
                        itemBuilder: (context, index) {
                          return _MediaItemList(file: filteredMedia[index]);
                        },
                      ),
          ),
        ),
      ],
    );
  }
}

class _MediaItemGrid extends StatefulWidget {
  final FileSystemEntity file;

  const _MediaItemGrid({required this.file});

  @override
  State<_MediaItemGrid> createState() => _MediaItemGridState();
}

class _MediaItemGridState extends State<_MediaItemGrid> {
  bool _isHovering = false;

  IconData _getIcon() {
    final ext = path.extension(widget.file.path).toLowerCase();
    if ([
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
      '.heic',
      '.bmp',
      '.gif',
      '.tiff',
      '.tif',
      '.svg',
      '.ico',
      '.raw',
      '.dng'
    ].contains(ext)) {
      return Icons.image;
    }
    return Icons.movie;
  }

  @override
  Widget build(BuildContext context) {
    final projectState = context.watch<ProjectState>();
    final isSelected = projectState.selectedMedia?.path == widget.file.path;

    return Draggable<FileSystemEntity>(
      data: widget.file,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: PicasooColors.surface2.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: PicasooColors.primary),
          ),
          child: Center(
            child: Icon(_getIcon(), color: PicasooColors.textHigh, size: 32),
          ),
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: () {
            projectState.selectMedia(widget.file);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? PicasooColors.primary.withValues(alpha: 0.2)
                  : PicasooColors.surface2,
              borderRadius: BorderRadius.circular(4),
              border: isSelected || _isHovering
                  ? Border.all(color: PicasooColors.primary, width: 2)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(2)),
                    ),
                    child: Center(
                      child: Icon(_getIcon(), color: PicasooColors.textLow),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          path.basename(widget.file.path),
                          style: PicasooTypography.small,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_isHovering)
                        GestureDetector(
                          onTap: () {
                            context
                                .read<ProjectState>()
                                .addClipToTimeline(widget.file);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to Timeline'),
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.add_circle,
                            size: 16,
                            color: PicasooColors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaItemList extends StatelessWidget {
  final FileSystemEntity file;

  const _MediaItemList({required this.file});

  IconData _getIcon() {
    final ext = path.extension(file.path).toLowerCase();
    if ([
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
      '.heic',
      '.bmp',
      '.gif',
      '.tiff',
      '.tif',
      '.svg',
      '.ico',
      '.raw',
      '.dng'
    ].contains(ext)) {
      return Icons.image;
    }
    return Icons.movie;
  }

  @override
  Widget build(BuildContext context) {
    final projectState = context.watch<ProjectState>();
    final isSelected = projectState.selectedMedia?.path == file.path;

    return Draggable<FileSystemEntity>(
      data: file,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
            color: PicasooColors.surface2.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: PicasooColors.primary),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(_getIcon(), color: PicasooColors.textHigh, size: 16),
              const SizedBox(width: 8),
              Text(path.basename(file.path), style: PicasooTypography.body),
            ],
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          projectState.selectMedia(file);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? PicasooColors.primary.withValues(alpha: 0.2)
                : PicasooColors.surface2,
            borderRadius: BorderRadius.circular(4),
            border: isSelected
                ? Border.all(color: PicasooColors.primary, width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(_getIcon(), size: 20, color: PicasooColors.textMed),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  path.basename(file.path),
                  style: PicasooTypography.body,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Metadata placeholder
              const Text(
                '00:00:05:00', // Placeholder duration
                style: TextStyle(
                    color: PicasooColors.textLow,
                    fontSize: 12,
                    fontFamily: 'monospace'),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  context.read<ProjectState>().addClipToTimeline(file);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to Timeline'),
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: const Icon(
                  Icons.add_circle,
                  size: 16,
                  color: PicasooColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
