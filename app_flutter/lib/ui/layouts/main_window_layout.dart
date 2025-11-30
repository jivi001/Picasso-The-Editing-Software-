import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';
import '../../core/app_state.dart';
import '../atoms/picasoo_button.dart';
import '../pages/media_page.dart';
import '../pages/edit_page.dart';
import '../pages/color_page.dart';
import '../pages/fusion_page.dart';
import '../pages/deliver_page.dart';
import '../../ui/pages/audio_page.dart';

class MainWindowLayout extends StatefulWidget {
  const MainWindowLayout({super.key});

  @override
  State<MainWindowLayout> createState() => _MainWindowLayoutState();
}

class _MainWindowLayoutState extends State<MainWindowLayout> {
  AppPage _currentPage = AppPage.edit;

  void _navigateTo(AppPage page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case AppPage.media:
        return const MediaPage();
      case AppPage.cut:
        return const EditPage(); // Cut page uses same layout for now
      case AppPage.edit:
        return const EditPage();
      case AppPage.fusion:
        return const FusionPage();
      case AppPage.color:
        return const ColorPage();
      case AppPage.audio:
        return const AudioPageWidget();
      case AppPage.deliver:
        return const DeliverPage();
    }
  }

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
                        isSelected: _currentPage == AppPage.media,
                        onTap: () => _navigateTo(AppPage.media),
                      ),
                      _SidebarItem(
                        icon: Icons.movie_creation,
                        label: 'Cut',
                        isSelected: _currentPage == AppPage.cut,
                        onTap: () => _navigateTo(AppPage.cut),
                      ),
                      _SidebarItem(
                        icon: Icons.edit,
                        label: 'Edit',
                        isSelected: _currentPage == AppPage.edit,
                        onTap: () => _navigateTo(AppPage.edit),
                      ),
                      _SidebarItem(
                        icon: Icons.auto_fix_high,
                        label: 'Fusion',
                        isSelected: _currentPage == AppPage.fusion,
                        onTap: () => _navigateTo(AppPage.fusion),
                      ),
                      _SidebarItem(
                        icon: Icons.color_lens,
                        label: 'Color',
                        isSelected: _currentPage == AppPage.color,
                        onTap: () => _navigateTo(AppPage.color),
                      ),
                      _SidebarItem(
                        icon: Icons.music_note,
                        label: 'Audio',
                        isSelected: _currentPage == AppPage.audio,
                        onTap: () => _navigateTo(AppPage.audio),
                      ),
                      _SidebarItem(
                        icon: Icons.rocket_launch,
                        label: 'Deliver',
                        isSelected: _currentPage == AppPage.deliver,
                        onTap: () => _navigateTo(AppPage.deliver),
                      ),
                    ],
                  ),
                ),
                // Workspace View
                Expanded(
                  child: _buildCurrentPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 60,
          width: 60,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: _isHovering ? PicasooColors.surface2 : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: widget.isSelected
                    ? PicasooColors.primary
                    : PicasooColors.textLow,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: PicasooTypography.small.copyWith(
                  color: widget.isSelected
                      ? PicasooColors.textHigh
                      : PicasooColors.textLow,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
