import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';
import '../atoms/picasoo_button.dart';
import '../organisms/media_pool_widget.dart';
import '../organisms/timeline_widget.dart';
import '../organisms/inspector_widget.dart';

class MainWindowLayout extends StatelessWidget {
  const MainWindowLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Bar
          Container(
            height: 40,
            color: PicasooColors.surface2,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Menu
                const Icon(Icons.menu, color: PicasooColors.textMed),
                const SizedBox(width: 16),
                // Project Name
                Text('Untitled Project', style: PicasooTypography.h2),
                const Spacer(),
                // Workspace Tools
                PicasooButton(
                  label: 'Export',
                  onPressed: () {},
                  variant: PicasooButtonVariant.primary,
                  isCompact: true,
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Row(
              children: [
                // Sidebar (Navigation)
                Container(
                  width: 60,
                  color: PicasooColors.surface1,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _SidebarItem(
                          icon: Icons.folder,
                          label: 'Media',
                          isSelected: false),
                      _SidebarItem(
                          icon: Icons.movie_creation,
                          label: 'Cut',
                          isSelected: false),
                      _SidebarItem(
                          icon: Icons.edit, label: 'Edit', isSelected: true),
                      _SidebarItem(
                          icon: Icons.auto_fix_high,
                          label: 'Fusion',
                          isSelected: false),
                      _SidebarItem(
                          icon: Icons.color_lens,
                          label: 'Color',
                          isSelected: false),
                      _SidebarItem(
                          icon: Icons.music_note,
                          label: 'Audio',
                          isSelected: false),
                      _SidebarItem(
                          icon: Icons.rocket_launch,
                          label: 'Deliver',
                          isSelected: false),
                    ],
                  ),
                ),
                // Workspace View
                Expanded(
                  child: Column(
                    children: [
                      // Top Half
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            // Media Pool
                            const Expanded(
                              flex: 3,
                              child: MediaPoolWidget(),
                            ),
                            // Viewers (Placeholder)
                            Expanded(
                              flex: 6,
                              child: Container(
                                color: Colors.black,
                                margin: const EdgeInsets.all(1),
                                child: const Center(
                                  child: Text('Source / Program Viewer',
                                      style: TextStyle(color: Colors.white54)),
                                ),
                              ),
                            ),
                            // Inspector
                            const Expanded(
                              flex: 3,
                              child: InspectorWidget(),
                            ),
                          ],
                        ),
                      ),
                      // Bottom Half (Timeline)
                      const Expanded(
                        flex: 1,
                        child: TimelineWidget(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? PicasooColors.primary : PicasooColors.textLow,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: PicasooTypography.small.copyWith(
              color:
                  isSelected ? PicasooColors.textHigh : PicasooColors.textLow,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
