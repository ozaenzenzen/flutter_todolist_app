import 'dart:ffi';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';

class CategoriesChipWidget extends StatefulWidget {
  final String value;
  final String? groupValue;
  final Function(String) onChanged;
  final String label;

  const CategoriesChipWidget({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  @override
  State<CategoriesChipWidget> createState() => _CategoriesChipWidgetState();
}

class _CategoriesChipWidgetState extends State<CategoriesChipWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged.call(widget.value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (widget.value == widget.groupValue) ? const Color(0xff2196F3).withOpacity(0.65) : const Color(0xff2196F3).withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            20.h,
          ),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
