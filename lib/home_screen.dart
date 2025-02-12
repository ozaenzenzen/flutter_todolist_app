import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todolist_app/domain/task_holder_entity.dart';
import 'package:flutter_todolist_app/presentation/widget/categories_chip_widget.dart';
import 'package:flutter_todolist_app/presentation/widget/task_item_widget.dart';
import 'package:flutter_todolist_app/support/app_color.dart';
import 'package:flutter_todolist_app/support/task_action_enum.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  // final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  List<int> items = List<int>.generate(20, (int index) => index);

  List categoriesFilter = [
    "On-Going",
    "Completed",
    "1 Day To Go",
    "1 Week To Go",
  ];

  String? currentFilter;

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
            onPressed: () async {
              await bottomSheetAction(
                taskActionEnum: TaskActionEnum.create,
                callbackAction: (data) {
                  AppLoggerCS.debugLog("value here 1: ${data?.toJson()}");
                },
              );
            },
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
                      onTap: () {
                        //
                      },
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (currentFilter != null)
                      InkWell(
                        onTap: () {
                          setState(() {
                            currentFilter = null;
                          });
                        },
                        child: Text(
                          "Clear Filter",
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 35.h,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesFilter.length,
                  itemBuilder: (context, index) {
                    Widget chip = CategoriesChipWidget(
                      value: categoriesFilter[index],
                      groupValue: currentFilter,
                      onChanged: (value) {
                        setState(() {
                          if (value == currentFilter) {
                            currentFilter = null;
                          } else {
                            currentFilter = value;
                          }
                          AppLoggerCS.debugLog("$currentFilter");
                        });
                      },
                      label: categoriesFilter[index],
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
                    return Dismissible(
                      key: ValueKey<int>(items[index]),
                      onDismissed: (direction) {
                        // Remove the item from the data source.
                        setState(() {
                          items.removeAt(index);
                        });

                        // Then show a snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${items[index]} dismissed'),
                          ),
                        );
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
                        // title: "title $index",
                        title: "title ${items[index]}",
                        created: DateTime.now(),
                        deadline: DateTime.now(),
                        onTap: () async {
                          await bottomSheetAction(
                            taskActionEnum: TaskActionEnum.update,
                            callbackAction: (data) {
                              AppLoggerCS.debugLog("value here 2: ${data?.toJson()}");
                            },
                          );
                        },
                        onClickCheck: (bool? isCheck) {
                          AppLoggerCS.debugLog("debug: $isCheck");
                          if (isCheck!) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('title ${items[index]} Marked as Done'),
                              ),
                            );
                          }
                        },
                      ),
                    );
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

  Future<void> bottomSheetAction({
    TaskActionEnum? taskActionEnum,
    Function(TaskHolderDataEntity? data)? callbackAction,
  }) async {
    // String? taskTitle;
    DateTime? concatDateAndTime;
    DateTime? chosenDate;
    TimeOfDay? chosenTime;
    TextEditingController taskTitleController = TextEditingController();
    TextEditingController notesController = TextEditingController();
    List<TaskListDataEntity> _tasks = [];
    // List<Map<String, dynamic>> _tasks = [];

    TaskHolderDataEntity dataHolder = TaskHolderDataEntity();

    void dataHolderHandling() {
      dataHolder.taskTitle = taskTitleController.text;
      dataHolder.deadline = concatDateAndTime?.toIso8601String();
      dataHolder.deadline2 = concatDateAndTime;
      dataHolder.notes = notesController.text;
      dataHolder.tasksList = _tasks;
    }

    void addTask() {
      setState(() {
        // _tasks.add({"text": "", "done": false});
        _tasks.add(
          TaskListDataEntity(
            text: "",
            done: false,
          ),
        );
      });
    }

    void removeTask(int index) {
      setState(() {
        _tasks.removeAt(index);
      });
    }

    void toggleTask(int index) {
      setState(() {
        // _tasks[index]["done"] = !_tasks[index]["done"];
        _tasks[index].done = !_tasks[index].done!;
      });
    }

    void updateTaskText(int index, String text) {
      setState(() {
        // _tasks[index]["text"] = text;
        _tasks[index].text = text;
      });
    }

    await AppBottomSheetAction().showBottomSheet(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 12.w,
      ),
      context: context,
      radius: 8.h,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      content: StatefulBuilder(builder: (context, setState) {
        AppLoggerCS.debugLog("_tasks: ${jsonEncode(_tasks.map((task) => task.toJson()).toList())}");
        dataHolderHandling();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        dataHolderHandling();
                        Navigator.pop(context);
                        callbackAction?.call(dataHolder);
                      },
                      child: Text(
                        "Save",
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    if (taskActionEnum == TaskActionEnum.update)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16.w),
                          InkWell(
                            onTap: () {
                              AppDialogActionCS.showWarningPopup(
                                context: context,
                                title: "Warning",
                                description: "Are you sure want to delete this task include all its details?",
                                isHorizontal: false,
                                mainButtonAction: () {
                                  // setState(() {
                                  //   confirmDelete = false;
                                  Navigator.pop(context);
                                  // });
                                },
                                mainButtonTitle: "Back",
                                secondaryButtonAction: () {
                                  // setState(() {
                                  //   confirmDelete = true;
                                  Navigator.pop(context);
                                  // });
                                },
                                secondaryButtonTitle: "Yes",
                              );
                            },
                            child: Text(
                              "Delete",
                              style: GoogleFonts.inter(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back",
                    style: GoogleFonts.inter(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              height: 1.h,
              color: const Color(0xffE2E2E2),
            ),
            SizedBox(height: 16.h),
            // content ?? const SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task Title",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: taskTitleController,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  decoration: InputDecoration(
                    filled: false,
                    contentPadding: EdgeInsets.all(10.h),
                    hintText: "Type Body Here...",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.h),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.h),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          chosenDate = await showDatePicker(
                            context: context,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                          );
                          AppLoggerCS.debugLog('chosenDate: $chosenDate');

                          if (chosenDate != null) {
                            concatDateAndTime = chosenDate;
                            chosenTime = null;
                            AppLoggerCS.debugLog('concatDateAndTime1: $concatDateAndTime');
                          }
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    size: 24.h,
                                    color: Colors.amber.shade400,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    chosenDate != null ? DateFormat("EE, dd MMMM yyyy").format(chosenDate!) : "Set Due Date",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (chosenDate != null)
                              InkWell(
                                onTap: () {
                                  chosenDate = null;
                                  concatDateAndTime = null;
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 24.h,
                                ),
                              )
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      InkWell(
                        onTap: () async {
                          chosenTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          AppLoggerCS.debugLog("chosenTime ${chosenTime?.format(context)}");
                          AppLoggerCS.debugLog('chosenDate2: $chosenDate');
                          if (chosenTime != null) {
                            if (concatDateAndTime == null) {
                              concatDateAndTime = DateTime.now();
                              concatDateAndTime?.add(
                                Duration(
                                  hours: chosenTime!.hour,
                                  minutes: chosenTime!.minute,
                                ),
                              );
                            } else {
                              var durationVal = Duration(
                                hours: chosenTime!.hour,
                                minutes: chosenTime!.minute,
                              );
                              AppLoggerCS.debugLog('durationVal: $durationVal');
                              concatDateAndTime = concatDateAndTime?.add(durationVal);
                            }
                            AppLoggerCS.debugLog('concatDateAndTime2: $concatDateAndTime');
                          }
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lock_clock_outlined,
                                    size: 24.h,
                                    color: Colors.red.shade300,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    chosenTime != null ? "${chosenTime?.format(context)}" : "Set Time",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (chosenTime != null)
                              InkWell(
                                onTap: () {
                                  chosenTime = null;
                                  concatDateAndTime = null;
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 24.h,
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tasks",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: _tasks[index].done,
                                // value: _tasks[index]["done"],
                                onChanged: (val) {
                                  setState(() {
                                    toggleTask(index);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 45.h,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    hintText: "Enter task...",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      updateTaskText(index, text);
                                    });
                                  },
                                  // controller: TextEditingController(text: _tasks[index]["text"]),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  removeTask(index);
                                });
                              },
                              // onPressed: () => _removeTask(index),
                            ),
                          ],
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          addTask();
                        });
                      },
                      child: Text(
                        "Add task..",
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notes",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: notesController,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 14,
                  decoration: InputDecoration(
                    filled: false,
                    contentPadding: EdgeInsets.all(10.h),
                    hintText: "Type Body Here...",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.h),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.h),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        );
      }),
    );
  }
}
