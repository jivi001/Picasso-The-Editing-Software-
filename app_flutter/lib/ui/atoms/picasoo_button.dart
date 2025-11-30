import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

enum PicasooButtonVariant { primary, secondary, ghost }

class PicasooButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final PicasooButtonVariant variant;
  final IconData? icon;
  final bool isCompact;

  const PicasooButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PicasooButtonVariant.primary,
    this.icon,
    this.isCompact = false,
  });

  @override
  State<PicasooButton> createState() => _PicasooButtonState();
}

class _PicasooButtonState extends State<PicasooButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final height = widget.isCompact ? 28.0 : 32.0;
    final padding = widget.isCompact
        ? const EdgeInsets.symmetric(horizontal: 8)
        : const EdgeInsets.symmetric(horizontal: 12);

    Color backgroundColor;
    Color textColor;

    // Determine colors based on variant and state
    switch (widget.variant) {
      case PicasooButtonVariant.primary:
        backgroundColor = widget.onPressed == null
            ? PicasooColors.surface3
            : _isPressed
                ? Color.lerp(PicasooColors.primary, Colors.black, 0.1)!
                : _isHovering
                    ? Color.lerp(PicasooColors.primary, Colors.white, 0.1)!
                    : PicasooColors.primary;
        textColor = widget.onPressed == null
            ? PicasooColors.textDisabled
            : PicasooColors.textHigh;
        break;
      case PicasooButtonVariant.secondary:
        backgroundColor = widget.onPressed == null
            ? PicasooColors.surface1
            : _isPressed
                ? PicasooColors.surface2
                : _isHovering
                    ? PicasooColors.surface4
                    : PicasooColors.surface3;
        textColor = widget.onPressed == null
            ? PicasooColors.textDisabled
            : PicasooColors.textMed;
        break;
      case PicasooButtonVariant.ghost:
        backgroundColor = _isPressed
            ? PicasooColors.surface3
            : _isHovering
                ? PicasooColors.surface2
                : Colors.transparent;
        textColor = widget.onPressed == null
            ? PicasooColors.textDisabled
            : PicasooColors.textMed;
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: textColor),
                const SizedBox(width: 4),
              ],
              Text(
                widget.label,
                style: PicasooTypography.button.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
