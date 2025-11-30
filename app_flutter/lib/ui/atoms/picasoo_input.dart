import 'package:flutter/material.dart';
import '../../core/theme/picasoo_colors.dart';
import '../../core/theme/picasoo_typography.dart';

class PicasooInput extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final bool isNumber;
  final Function(String)? onChanged;
  final double? initialValue;

  const PicasooInput({
    super.key,
    this.placeholder,
    this.controller,
    this.isNumber = false,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<PicasooInput> createState() => _PicasooInputState();
}

class _PicasooInputState extends State<PicasooInput> {
  bool _isFocused = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(
          text: widget.initialValue?.toString() ?? '',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
      child: Container(
        height: 28,
        decoration: BoxDecoration(
          color: PicasooColors.surface1,
          border: Border.all(
            color: _isFocused ? PicasooColors.primary : PicasooColors.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          controller: _controller,
          style: PicasooTypography.body.copyWith(color: PicasooColors.textHigh),
          cursorColor: PicasooColors.primary,
          keyboardType:
              widget.isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle:
                PicasooTypography.body.copyWith(color: PicasooColors.textLow),
            border: InputBorder.none,
            isDense: true,
            contentPadding:
                const EdgeInsets.only(bottom: 14), // Center text vertically
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
