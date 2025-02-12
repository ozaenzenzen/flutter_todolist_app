import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';

class TaskItemWidget extends StatefulWidget {
  final void Function()? onTap;
  final String id;
  final String title;
  final String? description;
  final DateTime created;
  final DateTime deadline;
  final void Function(bool?)? onClickCheck;

  const TaskItemWidget({
    super.key,
    this.onTap,
    required this.id,
    required this.title,
    this.description,
    required this.created,
    required this.deadline,
    this.onClickCheck,
  });

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  bool _isCheck = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            4.h,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.shade900.withOpacity(0.1),
              offset: const Offset(1, 1),
              blurRadius: 4,
              spreadRadius: 0.1,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // SizedBox(height: 4.h),
                  // Text(
                  //   "'The quick brown fox jumps over the lazy dog' is an English-language pangram – a sentence that contains all the letters of the alphabet. $index",
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: GoogleFonts.inter(
                  //     fontSize: 14.sp,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                  // Text(
                  //   "Status $index",
                  //   style: GoogleFonts.inter(
                  //     fontSize: 14.sp,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                  SizedBox(height: 12.h),
                  Text(
                    "Created ${DateFormat().format(widget.created)}",
                    // "Created ${DateFormat().format(DateTime.now())}",
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade700,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    "Deadline ${DateFormat().format(widget.deadline)}",
                    // "Deadline ${DateFormat().format(DateTime.now())}",
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade700,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Created ${DateFormat().format(DateTime.now())}",
                  //       style: GoogleFonts.inter(
                  //         fontSize: 14.sp,
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     ),
                  //     SizedBox(width: 4.w),
                  //     Text(
                  //       "Deadline ${DateFormat().format(DateTime.now())}",
                  //       style: GoogleFonts.inter(
                  //         fontSize: 14.sp,
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                // widget.onTapCheckbox?.call();
              },
              child: SizedBox(
                width: 50.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.7,
                      child: SizedBox(
                        height: 24.h,
                        width: 24.h,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.red,
                          ),
                          child: Checkbox(
                            side: BorderSide(
                              width: 1.w,
                              color: const Color(0xff333333).withOpacity(0.4),
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: const Color(0xff2196F3),
                            checkColor: Colors.white,
                            value: _isCheck,
                            onChanged: (value) {
                              setState(() {
                                _isCheck = !_isCheck;
                                widget.onClickCheck?.call(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Mark As Done",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
