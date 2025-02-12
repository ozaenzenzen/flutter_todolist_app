import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter_todolist_app/data/model/request/add_task_request_model.dart';
import 'package:flutter_todolist_app/data/model/request/get_list_task_request_model.dart';
import 'package:flutter_todolist_app/data/model/request/update_task_request_model.dart';
import 'package:flutter_todolist_app/data/model/response/add_task_response_model.dart';
import 'package:flutter_todolist_app/data/model/response/delete_task_response_model.dart';
import 'package:flutter_todolist_app/data/model/response/finish_task_response_model.dart';
import 'package:flutter_todolist_app/data/model/response/get_list_task_response_model.dart';
import 'package:flutter_todolist_app/data/model/response/update_task_response_model.dart';
import 'package:flutter_todolist_app/data/repository/task_repository.dart';
import 'package:flutter_todolist_app/init_config.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository = TaskRepository(AppInitConfig.appApiService);

  RxBool isLoading = false.obs;

  Future<void> addTask({
    required AddTaskRequestModel dataReq,
    void Function(AddTaskResponseModel data)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading.value = true;
    try {
      AddTaskResponseModel? response = await taskRepository.addTask(dataReq: dataReq);
      if (response == null) {
        onFailed?.call("Failed From Server 1");
        isLoading.value = false;
        return;
      }
      if (response.data == null) {
        onFailed?.call("${response.message}");
        isLoading.value = false;
        return;
      }
      if (response.status! <= 200 || response.status! >= 300) {
        onFailed?.call("${response.message}");
        isLoading.value = false;
        return;
      }
      if (response.status == 201) {
        onSuccess?.call(response);
        isLoading.value = false;
        return;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[HomeController][addTask] errorMessage $errorMessage");
      isLoading.value = false;
      onFailed?.call("Failed");
      return;
    }
  }

  Future<void> updateTask({
    required UpdateTaskRequestModel dataReq,
    void Function(UpdateTaskResponseModel data)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading.value = true;
    try {
      UpdateTaskResponseModel? response = await taskRepository.updateTask(dataReq: dataReq);
      if (response == null) {
        onFailed?.call("Failed From Server 1");
        isLoading.value = false;
        return;
      }
      if (response.status != 200) {
        onFailed?.call("${response.message}");
        isLoading.value = false;
        return;
      }
      if (response.status == 200) {
        onSuccess?.call(response);
        isLoading.value = false;
        return;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[HomeController][updateTask] errorMessage $errorMessage");
      isLoading.value = false;
      onFailed?.call("Failed");
      return;
    }
  }

  RxList<ListDatumTask> listDataTask = <ListDatumTask>[].obs;
  Rx<int> currentGetListPage = 1.obs;
  Rx<int> totalPage = 1.obs;

  Future<void> getListTask({
    required GetListTaskRequestModel dataReq,
    bool isLoadMore = false,
    void Function(GetLIstTaskResponseModel data)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading.value = true;
    try {
      if (!isLoadMore) {
        currentGetListPage.value = 1;
      } else {
        currentGetListPage.value++;
      }

      GetListTaskRequestModel req = GetListTaskRequestModel(
        limit: 10,
        currentPage: currentGetListPage.value,
        sortOrder: dataReq.sortOrder,
        status: dataReq.status,
      );

      AppLoggerCS.debugLog("currentGetListPage: $currentGetListPage");

      GetLIstTaskResponseModel? response = await taskRepository.getListTask(
        // dataReq: dataReq,
        dataReq: req,
      );
      if (response == null) {
        onFailed?.call("Failed From Server 1");
        isLoading.value = false;
        return;
      }
      if (response.data == null) {
        onFailed?.call("Failed From Server 2");
        isLoading.value = false;
        return;
      }
      if (response.status != 200) {
        onFailed?.call("${response.message}");
        isLoading.value = false;
        return;
      }
      if (response.status == 200) {
        AppLoggerCS.debugLog("response.data: ${jsonEncode(response.data!.toJsonPagination())}");
        totalPage.value = response.data!.totalPages!;
        if (response.data!.listData!.isEmpty) {
          currentGetListPage.value--;
        }
        if (!isLoadMore) {
          listDataTask.value = response.data!.listData!;
        } else if (currentGetListPage <= response.data!.totalPages!) {
          listDataTask.addAll(response.data!.listData!);
        }

        AppLoggerCS.debugLog("length: ${listDataTask.length}");

        onSuccess?.call(response);
        isLoading.value = false;
        return;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[HomeController][getListTask] errorMessage $errorMessage");
      isLoading.value = false;
      onFailed?.call("Failed");
      return;
    }
  }

  Future<void> deleteTask({
    required String stamp,
    void Function(DeleteTaskResponseModel data)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading.value = true;
    try {
      DeleteTaskResponseModel? response = await taskRepository.deleteTask(stamp: stamp);
      if (response == null) {
        onFailed?.call("Failed From Server 1");
        isLoading.value = false;
        return;
      }
      if (response.status != 200) {
        onFailed?.call("${response.message}");
        isLoading.value = false;
        return;
      }
      if (response.status == 200) {
        onSuccess?.call(response);
        isLoading.value = false;
        return;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[HomeController][deleteTask] errorMessage $errorMessage");
      isLoading.value = false;
      onFailed?.call("Failed");
      return;
    }
  }

  Future<void> finishTask({
    required String stamp,
    void Function(FinishTaskResponseModel data)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading.value = true;
    try {
      FinishTaskResponseModel? response = await taskRepository.finishTask(stamp: stamp);
      if (response == null) {
        onFailed?.call("Failed From Server 1");
        isLoading.value = false;
        return;
      }
      if (response.status != 200) {
        onFailed?.call("${response.message}");
        isLoading.value = false;
        return;
      }
      if (response.status == 200) {
        onSuccess?.call(response);
        isLoading.value = false;
        return;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[HomeController][finishTask] errorMessage $errorMessage");
      isLoading.value = false;
      onFailed?.call("Failed");
      return;
    }
  }
}
