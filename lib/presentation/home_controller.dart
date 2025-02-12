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
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository = TaskRepository();

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

  Future<void> getListTask({
    required GetListTaskRequestModel dataReq,
    void Function(GetLIstTaskResponseModel data)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading.value = true;
    try {
      GetLIstTaskResponseModel? response = await taskRepository.getListTask(dataReq: dataReq);
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
