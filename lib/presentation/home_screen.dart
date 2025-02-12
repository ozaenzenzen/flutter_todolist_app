import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/ui/widget/app_overlay_loading2_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todolist_app/data/model/request/add_task_request_model.dart';
import 'package:flutter_todolist_app/data/model/request/get_list_task_request_model.dart';
import 'package:flutter_todolist_app/data/model/request/update_task_request_model.dart';
import 'package:flutter_todolist_app/data/model/response/get_list_task_response_model.dart';
import 'package:flutter_todolist_app/domain/task_holder_entity.dart';
import 'package:flutter_todolist_app/presentation/home_controller.dart';
import 'package:flutter_todolist_app/presentation/widget/categories_chip_widget.dart';
import 'package:flutter_todolist_app/presentation/widget/task_item_widget.dart';
import 'package:flutter_todolist_app/support/app_color.dart';
import 'package:flutter_todolist_app/support/task_action_enum.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.put(HomeController());

  TextEditingController searchController = TextEditingController();
  // final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  List<int> items = List<int>.generate(20, (int index) => index);

  List categoriesFilter = [
    "On-Going",
    "Completed",
    // "1 Day To Go",
    // "1 Week To Go",
  ];

  String? currentFilter;

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  GetListTaskRequestModel dataReq = GetListTaskRequestModel(
    limit: 10,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeController.getListTask(
        isLoadMore: false,
        dataReq: dataReq,
        onSuccess: (data) {
          // AppLoggerCS.debugLog("data: ${jsonEncode(data.toJson())}");
        },
        onFailed: (errorMessage) {
          //
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
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
                    callbackAction: (data) async {
                      // AppLoggerCS.debugLog("value here 1: ${data?.toJson()}");
                      AddTaskRequestModel dataReqAdd = AddTaskRequestModel(
                        dueDateTime: data?.dueDateTime,
                        taskTitle: data?.taskTitle,
                        notes: data?.notes,
                        taskList: data?.taskList,
                        dataJson: data?.dataJson,
                      );
                      await homeController
                          .addTask(
                        dataReq: dataReqAdd,
                        onSuccess: (data) {
                          AppDialogActionCS.showSuccessPopup(
                            context: context,
                            title: "Success",
                            description: "${data.message}",
                            buttonTitle: "Back",
                            mainButtonAction: () {
                              Get.back();
                            },
                          );
                        },
                        onFailed: (String errorMessage) {
                          AppDialogActionCS.showFailedPopup(
                            context: context,
                            title: "Failed",
                            description: errorMessage,
                            buttonTitle: "Back",
                            mainButtonAction: () {
                              Get.back();
                            },
                          );
                        },
                      )
                          .then((value) async {
                        await homeController.getListTask(dataReq: dataReq);
                      });
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
                      ],
                    ),
                  ),
                  // SizedBox(height: 12.h),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 16.w,
                  //   ),
                  //   child: SizedBox(
                  //     height: 45.h,
                  //     child: TextField(
                  //       controller: searchController,
                  //       decoration: InputDecoration(
                  //         fillColor: Colors.grey.shade200,
                  //         filled: true,
                  //         prefixIcon: Icon(
                  //           Icons.search,
                  //           size: 24.h,
                  //         ),
                  //         contentPadding: EdgeInsets.all(10.h),
                  //         hintText: "Search tasks...",
                  //         hintStyle: GoogleFonts.inter(
                  //           fontSize: 16.sp,
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(12.h),
                  //           borderSide: BorderSide(
                  //             color: const Color(0xff2196F3),
                  //             width: 1.w,
                  //           ),
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(12.h),
                  //           borderSide: BorderSide(
                  //             color: const Color(0xff333333).withOpacity(0.4),
                  //             width: 1.w,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                            onTap: () async {
                              currentFilter = null;
                              dataReq.status = null;
                              await homeController.getListTask(dataReq: dataReq);
                              setState(() {});
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
                          onChanged: (value) async {
                            if (value == currentFilter) {
                              currentFilter = null;
                              dataReq.status = null;
                              await homeController.getListTask(dataReq: dataReq);
                            } else {
                              if (value == "On-Going") {
                                dataReq.status = 1;
                                await homeController.getListTask(dataReq: dataReq);
                              }
                              if (value == "Completed") {
                                dataReq.status = 2;
                                await homeController.getListTask(dataReq: dataReq);
                              }
                              currentFilter = value;
                            }
                            AppLoggerCS.debugLog("$currentFilter");
                            setState(() {});
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Tasks",
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (currentFilter == null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 8.w),
                              Text(
                                "(All Data)",
                                style: GoogleFonts.inter(
                                  color: Colors.blue,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() {
                    return Expanded(
                      child: SmartRefresher(
                        enablePullUp: true,
                        onLoading: () async {
                          await homeController
                              .getListTask(
                            dataReq: dataReq,
                            isLoadMore: true,
                            onSuccess: (data) {
                              // AppLoggerCS.debugLog("data: ${jsonEncode(data.toJson())}");
                            },
                            onFailed: (errorMessage) {
                              //
                            },
                          )
                              .then((value) {
                            refreshController.loadComplete();
                          });
                        },
                        onRefresh: () async {
                          await homeController
                              .getListTask(
                            dataReq: dataReq,
                            isLoadMore: false,
                            onSuccess: (data) {
                              // AppLoggerCS.debugLog("data: ${jsonEncode(data.toJson())}");
                            },
                            onFailed: (errorMessage) {
                              //
                            },
                          )
                              .then((value) {
                            refreshController.refreshCompleted();
                          });
                        },
                        controller: refreshController,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          // itemCount: items.length,
                          itemCount: homeController.listDataTask.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return TaskItemWidget(
                              id: "${homeController.listDataTask[index].stamp}",
                              title: "${homeController.listDataTask[index].taskTitle}",
                              created: DateTime.now(),
                              deadline: DateTime.parse(homeController.listDataTask[index].dueDateTime!.toIso8601String()),
                              status: homeController.listDataTask[index].status,
                              onTap: () async {
                                await bottomSheetAction(
                                  taskActionEnum: TaskActionEnum.update,
                                  dataTask: homeController.listDataTask[index],
                                  callbackAction: (data) async {
                                    UpdateTaskRequestModel dataReqUpdate = UpdateTaskRequestModel(
                                      stamp: data?.stamp,
                                      dueDateTime: data?.dueDateTime,
                                      taskTitle: data?.taskTitle,
                                      notes: data?.notes,
                                      taskList: data?.taskList,
                                      dataJson: data?.dataJson,
                                    );
                                    await homeController
                                        .updateTask(
                                      dataReq: dataReqUpdate,
                                    )
                                        .then((value) async {
                                      await homeController.getListTask(dataReq: dataReq);
                                    });
                                  },
                                );
                              },
                              onClickCheck: (bool? isCheck) async {
                                AppLoggerCS.debugLog("debug: $isCheck");
                                if (isCheck!) {
                                  await homeController.finishTask(stamp: homeController.listDataTask[index].stamp!).then((value) async {
                                    await homeController.getListTask(dataReq: dataReq);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${homeController.listDataTask[index].taskTitle} Marked as Done'),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 8.h);
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        Obx(() {
          if (homeController.isLoading.value) {
            return const AppOverlayLoading2Widget();
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }

  Future<void> bottomSheetAction({
    TaskActionEnum? taskActionEnum,
    ListDatumTask? dataTask,
    Function(ListDatumTask? data)? callbackAction,
  }) async {
    DateTime? concatDateAndTime;
    DateTime? chosenDate;
    TimeOfDay? chosenTime;
    TextEditingController taskTitleController = TextEditingController();
    TextEditingController notesController = TextEditingController();
    List<TaskListDataEntity> _tasks = [];

    if (dataTask != null && taskActionEnum == TaskActionEnum.update) {
      concatDateAndTime = dataTask.dueDateTime!;
      chosenDate = dataTask.dueDateTime!;
      chosenTime = TimeOfDay.fromDateTime(dataTask.dueDateTime!);
      taskTitleController.text = dataTask.taskTitle!;
      notesController.text = dataTask.notes!;

      String jsonString = dataTask.taskList?.replaceAll(RegExp(r'\s+'), '') ?? "";
      // AppLoggerCS.debugLog("dataTask1: ${jsonString}");
      List<Map<String, dynamic>> dataListTest = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
      // AppLoggerCS.debugLog("dataTask2: ${dataListTest}");
      _tasks = dataListTest
          .map(
            (e) => TaskListDataEntity(
              text: e['text'],
              done: e['done'],
            ),
          )
          .toList();
      // AppLoggerCS.debugLog("dataTask3: ${_tasks}");
    }

    TaskHolderDataEntity dataHolder = TaskHolderDataEntity();
    ListDatumTask dataHolderApi = ListDatumTask();

    void dataHolderHandling() {
      dataHolder.taskTitle = taskTitleController.text;
      dataHolder.deadline = concatDateAndTime?.toIso8601String();
      dataHolder.deadline2 = concatDateAndTime;
      dataHolder.notes = notesController.text;
      dataHolder.tasksList = _tasks;

      dataHolderApi.stamp = dataTask?.stamp;
      dataHolderApi.status = dataTask?.status;
      dataHolderApi.dueDateTime = dataHolder.deadline2;
      dataHolderApi.taskTitle = taskTitleController.text;
      dataHolderApi.notes = notesController.text;
      dataHolderApi.taskList = jsonEncode(dataHolder.tasksList?.map((task) => task.toJson()).toList());
      dataHolderApi.dataJson = jsonEncode(dataHolderApi.toJsonWithoutDataJson());

      AppLoggerCS.debugLog("dataHolderApi: ${jsonEncode(dataHolderApi.toJson())}");
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (dataHolderApi.status != 2)
                          InkWell(
                            onTap: () {
                              dataHolderHandling();
                              // dataHolder.status = 1;
                              Navigator.pop(context);
                              // callbackAction?.call(dataHolder);
                              callbackAction?.call(dataHolderApi);
                            },
                            child: Text(
                              taskActionEnum == TaskActionEnum.update ? "Update" : "Save",
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
                              if (dataHolderApi.status != 2) SizedBox(width: 16.w),
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
                                    secondaryButtonAction: () async {
                                      // setState(() {
                                      //   confirmDelete = true;
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      await homeController.deleteTask(stamp: dataHolderApi.stamp!).then((value) async {
                                        await homeController.getListTask(dataReq: dataReq);
                                      });
                                      // dataHolder.status = 2;
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
              ],
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              // child: content ?? Container(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                                    initialDate: chosenDate ?? DateTime.now(),
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
                                    initialTime: chosenTime ?? TimeOfDay.now(),
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
                                    Builder(builder: (context) {
                                      AppLoggerCS.debugLog("_tasks[index].text: ${_tasks[index].text}");
                                      return Expanded(
                                        child: SizedBox(
                                          height: 45.h,
                                          child: TextField(
                                            // controller: TextEditingController(text: _tasks[index].text),
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(10),
                                              hintText: (_tasks[index].text != null && _tasks[index].text != "") ? _tasks[index].text : "Enter task...",
                                              // hintText: "Enter task...",
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              enabledBorder: const OutlineInputBorder(
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
                                      );
                                    }),
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
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
