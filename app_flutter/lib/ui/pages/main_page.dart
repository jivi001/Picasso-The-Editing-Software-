import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/project_state.dart';
import '../../core/theme/picasoo_colors.dart';
import 'cut_page.dart';
import 'edit_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1; // Default to Edit Page for now
  final _projectState = ProjectState();

  final List<Widget> _pages = [
    const Center(child: Text('Media Page Placeholder')), // Media
    const CutPage(),
    const EditPage(),
    const Center(child: Text('Fusion Page Placeholder')), // Fusion
    const Center(child: Text('Color Page Placeholder')), // Color
    const Center(child: Text('Fairlight Page Placeholder')), // Audio
    const Center(child: Text('Deliver Page Placeholder')), // Deliver
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _projectState,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
            // Bottom Navigation Bar (Custom for dense look)
            Container(
              height: 48,
              color: PicasooColors.surface2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NavButton(
                    icon: Icons.folder,
                    label: 'Media',
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                  _NavButton(
                    icon: Icons.content_cut,
                    label: 'Cut',
                    isSelected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  _NavButton(
                    icon: Icons.edit,
                    label: 'Edit',
                    isSelected: _selectedIndex == 2,
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  _NavButton(
                    icon: Icons.auto_fix_high,
                    label: 'Fusion',
                    isSelected: _selectedIndex == 3,
                    onTap: () => setState(() => _selectedIndex = 3),
                  ),
                  _NavButton(
                    icon: Icons.color_lens,
                    label: 'Color',
                    isSelected: _selectedIndex == 4,
                    onTap: () => setState(() => _selectedIndex = 4),
                  ),
                  _NavButton(
                    icon: Icons.music_note,
                    label: 'Fairlight',
                    isSelected: _selectedIndex == 5,
                    onTap: () => setState(() => _selectedIndex = 5),
                  ),
                  _NavButton(
                    icon: Icons.rocket_launch,
                    label: 'Deliver',
                    isSelected: _selectedIndex == 6,
                    onTap: () => setState(() => _selectedIndex = 6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: isSelected ? PicasooColors.surface3 : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color:
                  isSelected ? PicasooColors.textHigh : PicasooColors.textMed,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color:
                    isSelected ? PicasooColors.textHigh : PicasooColors.textMed,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
