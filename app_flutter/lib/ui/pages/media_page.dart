import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

enum FileFilter { all, videos, images }

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  Directory _currentDir = Directory.current;
  List<FileSystemEntity> _allFiles = [];
  List<FileSystemEntity> _filteredFiles = [];
  bool _isLoading = false;
  String? _errorMessage;
  FileFilter _currentFilter = FileFilter.all;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentPaths = [];

  static const List<String> _videoExtensions = [
    '.mp4',
    '.mov',
    '.mkv',
    '.avi',
    '.webm',
    '.m4v'
  ];
  static const List<String> _imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp'
  ];

  @override
  void initState() {
    super.initState();
    _loadFiles(_currentDir);
    _searchController.addListener(_filterFiles);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFiles(Directory dir) async {
    setState(() {
      _isLoading = true;
      _currentDir = dir;
      _errorMessage = null;
    });

    try {
      final files = dir.listSync()
        ..sort((a, b) {
          // Directories first, then by name
          if (a is Directory && b is File) return -1;
          if (a is File && b is Directory) return 1;
          return path.basename(a.path).toLowerCase().compareTo(
                path.basename(b.path).toLowerCase(),
              );
        });

      // Add to recent paths
      final dirPath = dir.path;
      if (!_recentPaths.contains(dirPath)) {
        _recentPaths.insert(0, dirPath);
        if (_recentPaths.length > 5) {
          _recentPaths.removeLast();
        }
      }

      setState(() {
        _allFiles = files;
        _isLoading = false;
      });
      _filterFiles();
    } catch (e) {
      setState(() {
        _allFiles = [];
        _filteredFiles = [];
        _isLoading = false;
        _errorMessage = 'Access denied: ${e.toString()}';
      });
    }
  }

  void _filterFiles() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredFiles = _allFiles.where((file) {
        final name = path.basename(file.path).toLowerCase();

        // Search filter
        if (query.isNotEmpty && !name.contains(query)) {
          return false;
        }

        // Type filter
        if (file is Directory) return true;

        final ext = path.extension(file.path).toLowerCase();
        switch (_currentFilter) {
          case FileFilter.videos:
            return _videoExtensions.contains(ext);
          case FileFilter.images:
            return _imageExtensions.contains(ext);
          case FileFilter.all:
            return true;
        }
      }).toList();
    });
  }

  void _navigateUp() {
    final parent = _currentDir.parent;
    if (parent.path != _currentDir.path) {
      _loadFiles(parent);
    }
  }

  void _setFilter(FileFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
    _filterFiles();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  bool _isVideoFile(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    return _videoExtensions.contains(ext);
  }

  bool _isImageFile(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    return _imageExtensions.contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PicasooColors.surface0,
      child: Row(
        children: [
          // Left Sidebar: Locations & Recent
          _buildSidebar(),

          // Vertical Divider
          Container(width: 1, color: PicasooColors.surface2),

          // Main Content: File Browser
          Expanded(
            child: Column(
              children: [
                _buildToolbar(),
                _buildFilterBar(),
                Expanded(child: _buildFileGrid()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: PicasooColors.surface1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Locations
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Locations', style: PicasooTypography.h2),
          ),
          _buildLocationItem(
            Icons.computer,
            'This PC',
            () => _loadFiles(Directory('C:\\')),
          ),
          _buildLocationItem(
            Icons.home,
            'Home',
            () => _loadFiles(
                Directory(Platform.environment['USERPROFILE'] ?? 'C:\\')),
          ),
          _buildLocationItem(
            Icons.download,
            'Downloads',
            () => _loadFiles(
                Directory('${Platform.environment['USERPROFILE']}\\Downloads')),
          ),
          _buildLocationItem(
            Icons.movie,
            'Videos',
            () => _loadFiles(
                Directory('${Platform.environment['USERPROFILE']}\\Videos')),
          ),

          // Recent paths
          if (_recentPaths.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Recent', style: PicasooTypography.h2),
            ),
            ..._recentPaths.take(5).map((recentPath) {
              final dirName = path.basename(recentPath);
              return _buildLocationItem(
                Icons.history,
                dirName.isEmpty ? recentPath : dirName,
                () => _loadFiles(Directory(recentPath)),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: PicasooColors.surface1,
      child: Row(
        children: [
          // Navigation buttons
          IconButton(
            icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
            onPressed: _navigateUp,
            tooltip: 'Up',
          ),
          const SizedBox(width: 8),

          // Current path
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: PicasooColors.surface0,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.folder, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentDir.path,
                      style: PicasooTypography.small,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Search
          SizedBox(
            width: 200,
            child: TextField(
              controller: _searchController,
              style: PicasooTypography.body,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: PicasooTypography.body
                    .copyWith(color: PicasooColors.textLow),
                prefixIcon:
                    const Icon(Icons.search, size: 16, color: Colors.white54),
                filled: true,
                fillColor: PicasooColors.surface0,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Refresh
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
            onPressed: () => _loadFiles(_currentDir),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: PicasooColors.surface0,
      child: Row(
        children: [
          const Text('Show: ', style: PicasooTypography.small),
          const SizedBox(width: 8),
          _buildFilterChip('All', FileFilter.all),
          const SizedBox(width: 8),
          _buildFilterChip('Videos', FileFilter.videos),
          const SizedBox(width: 8),
          _buildFilterChip('Images', FileFilter.images),
          const Spacer(),
          Text(
            '${_filteredFiles.length} items',
            style:
                PicasooTypography.small.copyWith(color: PicasooColors.textLow),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, FileFilter filter) {
    final isActive = _currentFilter == filter;
    return InkWell(
      onTap: () => _setFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? PicasooColors.primary : PicasooColors.surface2,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: PicasooTypography.small.copyWith(
            color: isActive ? Colors.white : PicasooColors.textMed,
          ),
        ),
      ),
    );
  }

  Widget _buildFileGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: PicasooTypography.body),
          ],
        ),
      );
    }

    if (_filteredFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 48, color: PicasooColors.textLow),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty ? 'Empty folder' : 'No results',
              style: PicasooTypography.body,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredFiles.length,
      itemBuilder: (context, index) => _buildFileItem(_filteredFiles[index]),
    );
  }

  Widget _buildLocationItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: PicasooColors.textMed, size: 20),
      title: Text(label, style: PicasooTypography.body),
      dense: true,
      onTap: onTap,
      hoverColor: PicasooColors.surface2,
    );
  }

  Widget _buildFileItem(FileSystemEntity file) {
    final isDir = file is Directory;
    final name = path.basename(file.path);
    final isVideo = !isDir && _isVideoFile(file.path);
    final isImage = !isDir && _isImageFile(file.path);

    String? fileSize;
    if (!isDir) {
      try {
        final stat = file.statSync();
        fileSize = _formatFileSize(stat.size);
      } catch (e) {
        fileSize = null;
      }
    }

    return Tooltip(
      message: file.path,
      waitDuration: const Duration(milliseconds: 500),
      child: InkWell(
        onTap: () {
          if (isDir) {
            _loadFiles(file);
          } else {
            // TODO: Add to media pool or preview
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added: $name'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: PicasooColors.surface1,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: PicasooColors.surface2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon/Thumbnail area
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: PicasooColors.surface0,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(7)),
                  ),
                  child: Center(
                    child: Icon(
                      isDir
                          ? Icons.folder
                          : (isVideo
                              ? Icons.movie
                              : (isImage
                                  ? Icons.image
                                  : Icons.insert_drive_file)),
                      size: 48,
                      color: isDir
                          ? Colors.amber
                          : (isVideo
                              ? PicasooColors.primary
                              : (isImage
                                  ? PicasooColors.secondary
                                  : Colors.grey)),
                    ),
                  ),
                ),
              ),

              // File info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: PicasooTypography.small,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (fileSize != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        fileSize,
                        style: PicasooTypography.small.copyWith(
                          color: PicasooColors.textLow,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
