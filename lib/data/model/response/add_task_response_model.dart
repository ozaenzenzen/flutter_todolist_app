class AddTaskResponseModel {
  int? status;
  String? message;
  DataAddTask? data;

  AddTaskResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory AddTaskResponseModel.fromJson(Map<String, dynamic> json) => AddTaskResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : DataAddTask.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataAddTask {
  String? stamp;
  int? status;
  DateTime? dueDateTime;
  String? taskTitle;
  String? notes;
  String? taskList;
  String? dataJson;

  DataAddTask({
    this.stamp,
    this.status,
    this.dueDateTime,
    this.taskTitle,
    this.notes,
    this.taskList,
    this.dataJson,
  });

  factory DataAddTask.fromJson(Map<String, dynamic> json) => DataAddTask(
        stamp: json["stamp"],
        status: json["status"],
        dueDateTime: json["dueDateTime"] == null ? null : DateTime.parse(json["dueDateTime"]),
        taskTitle: json["taskTitle"],
        notes: json["notes"],
        taskList: json["taskList"],
        dataJson: json["dataJson"],
      );

  Map<String, dynamic> toJson() => {
        "stamp": stamp,
        "status": status,
        "dueDateTime": dueDateTime?.toIso8601String(),
        "taskTitle": taskTitle,
        "notes": notes,
        "taskList": taskList,
        "dataJson": dataJson,
      };
}
