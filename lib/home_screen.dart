import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/ui/widget/app_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todolist_app/presentation/widget/task_item_widget.dart';
import 'package:flutter_todolist_app/support/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.white,
          floatingActionButton: FloatingActionButton.extended(
            label: Row(
              children: [
                Icon(
                  Icons.add_box_rounded,
                  size: 24.h,
                ),
              ],
            ),
            onPressed: () {},
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "To Do App - SA Test",
                      style: GoogleFonts.inter(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.settings,
                        size: 24.h,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: SizedBox(
                  height: 45.h,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        size: 24.h,
                      ),
                      contentPadding: EdgeInsets.all(10.h),
                      hintText: "Search tasks...",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        borderSide: BorderSide(
                          color: const Color(0xff2196F3),
                          width: 1.w,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        borderSide: BorderSide(
                          color: const Color(0xff333333).withOpacity(0.4),
                          width: 1.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Text(
                  "Categories",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 35.h,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 23,
                  itemBuilder: (context, index) {
                    Widget chip = Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff2196F3).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          20.h,
                        ),
                      ),
                      child: Text("TEsting $index"),
                    );
                    if (index == 0) {
                      return Row(
                        children: [
                          SizedBox(width: 16.w),
                          chip,
                        ],
                      );
                    }
                    return chip;
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 8.w);
                  },
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Text(
                  "Tasks",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      // key: UniqueKey(),
                      key: Key(item),
                      onDismissed: (direction) {
                        // Remove the item from the data source.
                        setState(() {
                          items.removeAt(index);
                        });

                        // Then show a snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed')));
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: Text(
                          "Delete",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: TaskItemWidget(
                        id: "$index",
                        title: "title $index",
                        created: DateTime.now(),
                        deadline: DateTime.now(),
                      ),
                    );
                    // return InkWell(
                    //   onTap: () {
                    //     //
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 12.h,
                    //       horizontal: 16.w,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(
                    //         4.h,
                    //       ),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.blueGrey.shade900.withOpacity(0.1),
                    //           offset: const Offset(1, 1),
                    //           blurRadius: 4,
                    //           spreadRadius: 0.1,
                    //         )
                    //       ],
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "Title $index",
                    //               style: GoogleFonts.inter(
                    //                 fontSize: 18.sp,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //             ),
                    //             // SizedBox(height: 4.h),
                    //             // Text(
                    //             //   "'The quick brown fox jumps over the lazy dog' is an English-language pangram – a sentence that contains all the letters of the alphabet. $index",
                    //             //   maxLines: 2,
                    //             //   overflow: TextOverflow.ellipsis,
                    //             //   style: GoogleFonts.inter(
                    //             //     fontSize: 14.sp,
                    //             //     fontWeight: FontWeight.w400,
                    //             //   ),
                    //             // ),
                    //             // Text(
                    //             //   "Status $index",
                    //             //   style: GoogleFonts.inter(
                    //             //     fontSize: 14.sp,
                    //             //     fontWeight: FontWeight.w400,
                    //             //   ),
                    //             // ),
                    //             SizedBox(height: 12.h),
                    //             Text(
                    //               "Created ${DateFormat().format(DateTime.now())}",
                    //               style: GoogleFonts.inter(
                    //                 color: Colors.grey.shade700,
                    //                 fontSize: 12.sp,
                    //                 fontWeight: FontWeight.w400,
                    //               ),
                    //             ),
                    //             SizedBox(height: 4.w),
                    //             Text(
                    //               "Deadline ${DateFormat().format(DateTime.now())}",
                    //               style: GoogleFonts.inter(
                    //                 color: Colors.grey.shade700,
                    //                 fontSize: 12.sp,
                    //                 fontWeight: FontWeight.w400,
                    //               ),
                    //             ),
                    //             // Row(
                    //             //   children: [
                    //             //     Text(
                    //             //       "Created ${DateFormat().format(DateTime.now())}",
                    //             //       style: GoogleFonts.inter(
                    //             //         fontSize: 14.sp,
                    //             //         fontWeight: FontWeight.w400,
                    //             //       ),
                    //             //     ),
                    //             //     SizedBox(width: 4.w),
                    //             //     Text(
                    //             //       "Deadline ${DateFormat().format(DateTime.now())}",
                    //             //       style: GoogleFonts.inter(
                    //             //         fontSize: 14.sp,
                    //             //         fontWeight: FontWeight.w400,
                    //             //       ),
                    //             //     ),
                    //             //   ],
                    //             // ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 24.h,
                    //           width: 24.h,
                    //           child: Checkbox(
                    //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //             value: true,
                    //             onChanged: (value) {
                    //               //
                    //             },
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 8.h);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
