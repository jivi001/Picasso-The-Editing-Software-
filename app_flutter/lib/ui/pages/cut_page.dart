import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/project_state.dart';
import '../organisms/media_pool_widget.dart';
import '../organisms/video_viewer.dart';
import '../organisms/dual_timeline_widget.dart';

class CutPage extends StatefulWidget {
  const CutPage({super.key});

  @override
  State<CutPage> createState() => _CutPageState();
}

class _CutPageState extends State<CutPage> {
  bool _isSourceTapeMode = false;

  @override
  Widget build(BuildContext context) {
    final projectState = context.watch<ProjectState>();

    return Column(
      children: [
        // Top Navigation Bar
        Container(
          height: 48,
          color: PicasooColors.surface1,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Project Name & Tabs
              const Text('Project 1',
                  style: TextStyle(
                      color: PicasooColors.textHigh,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 32),
              _PageTab(label: 'Media', isSelected: false, onTap: () {}),
              _PageTab(label: 'Cut', isSelected: true, onTap: () {}),
              _PageTab(label: 'Edit', isSelected: false, onTap: () {}),

              const Spacer(),

              // Playback Controls
              IconButton(
                  icon: const Icon(Icons.skip_previous,
                      color: PicasooColors.textMed),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.play_arrow,
                      color: PicasooColors.textHigh),
                  onPressed: () {}),
              IconButton(
                  icon:
                      const Icon(Icons.skip_next, color: PicasooColors.textMed),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.loop, color: PicasooColors.textMed),
                  onPressed: () {}),

              const Spacer(),

              // Timecode
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: PicasooColors.border),
                ),
                child: const Text('00:00:00:00',
                    style: TextStyle(
                        color: PicasooColors.primary, fontFamily: 'monospace')),
              ),

              const SizedBox(width: 16),

              // Render Button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.ios_share, size: 16),
                label: const Text('Quick Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PicasooColors.surface3,
                  foregroundColor: PicasooColors.textHigh,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        // Top Area (Media Pool & Viewer)
        Expanded(
          flex: 5,
          child: Row(
            children: [
              // Media Pool
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    // Source Tape Toggle Bar
                    Container(
                      height: 40,
                      color: PicasooColors.surface2,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isSourceTapeMode = !_isSourceTapeMode;
                              });
                            },
                            icon: Icon(
                              Icons.movie,
                              color: _isSourceTapeMode
                                  ? PicasooColors.primary
                                  : PicasooColors.textMed,
                            ),
                            label: Text(
                              'Source Tape',
                              style: TextStyle(
                                color: _isSourceTapeMode
                                    ? PicasooColors.primary
                                    : PicasooColors.textMed,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.sort,
                                color: PicasooColors.textMed),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    // Media Grid
                    const Expanded(child: MediaPoolWidget()),
                  ],
                ),
              ),
              // Viewer
              Expanded(
                flex: 6,
                child: Container(
                  color: Colors.black,
                  margin: const EdgeInsets.all(1),
                  child: Column(
                    children: [
                      // Viewer Header
                      Container(
                        height: 32,
                        color: PicasooColors.surface2,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            const Spacer(),
                            Text(
                              _isSourceTapeMode
                                  ? 'Source Tape'
                                  : 'Timeline Viewer',
                              style:
                                  const TextStyle(color: PicasooColors.textMed),
                            ),
                            const Spacer(),
                            if (_isSourceTapeMode) ...[
                              IconButton(
                                icon: const Icon(Icons.keyboard_tab,
                                    size: 16,
                                    color: PicasooColors.textHigh), // Mark In
                                tooltip: 'Mark In (I)',
                                onPressed: () {
                                  projectState.markIn();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Mark In Set'),
                                        duration: Duration(milliseconds: 500)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    size: 16,
                                    color: PicasooColors.textHigh), // Mark Out
                                tooltip: 'Mark Out (O)',
                                onPressed: () {
                                  projectState.markOut();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Mark Out Set'),
                                        duration: Duration(milliseconds: 500)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.clear,
                                    size: 16, color: PicasooColors.textMed),
                                tooltip: 'Clear Marks',
                                onPressed: () {
                                  projectState.clearMarks();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Marks Cleared'),
                                        duration: Duration(milliseconds: 500)),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Video Player
                      Expanded(
                        child: Stack(
                          children: [
                            VideoViewer(
                              timeline: _isSourceTapeMode
                                  ? projectState.sourceTape
                                  : projectState.timeline,
                            ),
                            // Overlay for In/Out points (Visual feedback)
                            if (_isSourceTapeMode)
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Builder(
                                  builder: (context) {
                                    final inPoint = projectState.sourceInPoint;
                                    final outPoint =
                                        projectState.sourceOutPoint;
                                    if (inPoint == null && outPoint == null) {
                                      return const SizedBox();
                                    }
                                    return Container(
                                      padding: const EdgeInsets.all(4),
                                      color: Colors.black54,
                                      child: Text(
                                        'In: ${inPoint?.toString().split('.').first ?? '-'} | Out: ${outPoint?.toString().split('.').first ?? '-'}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Smart Edit Toolbar
        Container(
          height: 48,
          color: PicasooColors.surface2,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SmartToolButton(
                  icon: Icons.call_received,
                  label: 'Smart Insert',
                  onTap: () {
                    final selected = projectState.selectedMedia;
                    if (selected != null) {
                      projectState.smartInsert(selected);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Smart Inserted'),
                            duration: Duration(milliseconds: 500)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Select a clip first'),
                            duration: Duration(milliseconds: 500)),
                      );
                    }
                  }),
              const SizedBox(width: 8),
              _SmartToolButton(
                  icon: Icons.fast_forward,
                  label: 'Append',
                  onTap: () {
                    final selected = projectState.selectedMedia;
                    if (selected != null) {
                      projectState.addClipToTimeline(selected);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Appended to Timeline'),
                            duration: Duration(milliseconds: 500)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Select a clip first'),
                            duration: Duration(milliseconds: 500)),
                      );
                    }
                  }),
              const SizedBox(width: 8),
              _SmartToolButton(
                  icon: Icons.content_copy,
                  label: 'Ripple Ovr',
                  onTap: () {
                    final selected = projectState.selectedMedia;
                    if (selected != null) {
                      projectState.rippleOverwrite(selected);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Ripple Overwrite Applied'),
                            duration: Duration(milliseconds: 500)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Select a clip first'),
                            duration: Duration(milliseconds: 500)),
                      );
                    }
                  }),
              const SizedBox(width: 8),
              _SmartToolButton(
                  icon: Icons.zoom_in,
                  label: 'Close Up',
                  onTap: () {
                    projectState.closeUp();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Close Up Applied'),
                          duration: Duration(milliseconds: 500)),
                    );
                  }),
              const SizedBox(width: 8),
              _SmartToolButton(
                  icon: Icons.vertical_align_top,
                  label: 'Place On Top',
                  onTap: () {
                    final selected = projectState.selectedMedia;
                    if (selected != null) {
                      projectState.placeOnTop(selected);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Placed On Top'),
                            duration: Duration(milliseconds: 500)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Select a clip first'),
                            duration: Duration(milliseconds: 500)),
                      );
                    }
                  }),
              const SizedBox(width: 8),
              _SmartToolButton(
                  icon: Icons.layers,
                  label: 'Src Ovr',
                  onTap: () {
                    final selected = projectState.selectedMedia;
                    if (selected != null) {
                      projectState.sourceOverwrite(selected);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Source Overwrite Applied'),
                            duration: Duration(milliseconds: 500)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Select a clip first'),
                            duration: Duration(milliseconds: 500)),
                      );
                    }
                  }),
            ],
          ),
        ),
        // Bottom Area (Dual Timeline)
        const Expanded(
          flex: 4,
          child: DualTimelineWidget(),
        ),
      ],
    );
  }
}

class _SmartToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SmartToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: PicasooColors.surface3,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: PicasooColors.textHigh),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      color: PicasooColors.textHigh, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PageTab({
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
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(color: PicasooColors.primary, width: 2))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? PicasooColors.textHigh : PicasooColors.textMed,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
