import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';
import '../atoms/picasoo_input.dart';
import '../atoms/picasoo_button.dart';

class InspectorWidget extends StatelessWidget {
  const InspectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: PicasooColors.surface2,
          child: const Row(
            children: [
              Icon(Icons.tune, size: 16, color: PicasooColors.textMed),
              SizedBox(width: 8),
              Text('Inspector', style: PicasooTypography.h2),
            ],
          ),
        ),
        // Content
        Expanded(
          child: Container(
            color: PicasooColors.surface1,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const _SectionHeader(title: 'Video'),
                const SizedBox(height: 12),
                const _PropertyRow(
                  label: 'Zoom',
                  child: Row(
                    children: [
                      Expanded(
                          child:
                              PicasooInput(isNumber: true, initialValue: 1.0)),
                      SizedBox(width: 8),
                      Expanded(
                          child:
                              PicasooInput(isNumber: true, initialValue: 1.0)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const _PropertyRow(
                  label: 'Position',
                  child: Row(
                    children: [
                      Expanded(
                          child:
                              PicasooInput(isNumber: true, initialValue: 0.0)),
                      SizedBox(width: 8),
                      Expanded(
                          child:
                              PicasooInput(isNumber: true, initialValue: 0.0)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const _PropertyRow(
                  label: 'Rotation',
                  child: PicasooInput(isNumber: true, initialValue: 0.0),
                ),
                const SizedBox(height: 24),
                const Divider(color: PicasooColors.border),
                const SizedBox(height: 12),
                const _SectionHeader(title: 'Composite'),
                const SizedBox(height: 12),
                const _PropertyRow(
                  label: 'Opacity',
                  child: PicasooInput(isNumber: true, initialValue: 100.0),
                ),
                const SizedBox(height: 8),
                _PropertyRow(
                  label: 'Blend Mode',
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: PicasooColors.surface0,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: PicasooColors.border),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Normal', style: PicasooTypography.body),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                PicasooButton(
                  label: 'Reset All',
                  onPressed: () {},
                  variant: PicasooButtonVariant.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.arrow_drop_down, color: PicasooColors.textMed),
        const SizedBox(width: 4),
        Text(title, style: PicasooTypography.h1),
      ],
    );
  }
}

class _PropertyRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _PropertyRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: PicasooTypography.body
                  .copyWith(color: PicasooColors.textMed)),
        ),
        Expanded(child: child),
      ],
    );
  }
}
