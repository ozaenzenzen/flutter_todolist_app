import 'package:fam_coding_supply/logic/export.dart';
import 'package:flutter_todolist_app/data/model/request/add_task_request_model.dart';
import 'package:flutter_todolist_app/data/model/request/get_list_task_request_model.dart';
import 'package:flutter_todolist_app/data/model/request/update_task_request_model.dart';
import 'package:flutter_todolist_app/data/model/response/add_task_response_model.dart';
import 'package:flutter_todolist_app/data/model/response/delete_task_response_model.dart';
import 'package:flutter_todolist_app/data/model/response/finish_task_response_model.dart';
import 'package:flutter_todolist_app/data/model/response/get_list_task_response_model.dart';
import 'package:flutter_todolist_app/data/model/response/update_task_response_model.dart';

class TaskRepository {
  AppApiServiceCS appApiService = AppApiServiceCS("https://4f6a-182-3-45-75.ngrok-free.app");

  Future<AddTaskResponseModel?> addTask({
    required AddTaskRequestModel dataReq,
  }) async {
    try {
      final response = await appApiService.call(
        "/task/add",
        method: MethodRequestCS.post,
        request: dataReq.toJson(),
      );
      if (response.data != null) {
        return AddTaskResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[TaskRepository][addTask] errorMessage $errorMessage");
      return null;
    }
  }

  Future<UpdateTaskResponseModel?> updateTask({
    required UpdateTaskRequestModel dataReq,
  }) async {
    try {
      final response = await appApiService.call(
        "/task/update",
        method: MethodRequestCS.post,
        request: dataReq.toJson(),
      );
      if (response.data != null) {
        return UpdateTaskResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[TaskRepository][updateTask] errorMessage $errorMessage");
      return null;
    }
  }

  Future<GetLIstTaskResponseModel?> getListTask({
    required GetListTaskRequestModel dataReq,
  }) async {
    try {
      final response = await appApiService.call(
        "/task/getlist",
        method: MethodRequestCS.post,
        request: dataReq.toJson(),
      );
      if (response.data != null) {
        return GetLIstTaskResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[TaskRepository][updateTask] errorMessage $errorMessage");
      return null;
    }
  }

  Future<DeleteTaskResponseModel?> deleteTask({
    required String stamp,
  }) async {
    try {
      final response = await appApiService.call(
        "/task/delete/$stamp",
        method: MethodRequestCS.post,
      );
      if (response.data != null) {
        return DeleteTaskResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[TaskRepository][deleteTask] errorMessage $errorMessage");
      return null;
    }
  }

  Future<FinishTaskResponseModel?> finishTask({
    required String stamp,
  }) async {
    try {
      final response = await appApiService.call(
        "/task/finish/$stamp",
        method: MethodRequestCS.post,
      );
      if (response.data != null) {
        return FinishTaskResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[TaskRepository][finishTask] errorMessage $errorMessage");
      return null;
    }
  }
}
