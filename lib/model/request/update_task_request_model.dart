class UpdateTaskRequestModel {
  String? stamp;
  DateTime? dueDateTime;
  String? taskTitle;
  String? notes;
  String? taskList;
  String? dataJson;

  UpdateTaskRequestModel({
    this.stamp,
    this.dueDateTime,
    this.taskTitle,
    this.notes,
    this.taskList,
    this.dataJson,
  });

  factory UpdateTaskRequestModel.fromJson(Map<String, dynamic> json) => UpdateTaskRequestModel(
        stamp: json["stamp"],
        dueDateTime: json["dueDateTime"] == null ? null : DateTime.parse(json["dueDateTime"]),
        taskTitle: json["taskTitle"],
        notes: json["notes"],
        taskList: json["taskList"],
        dataJson: json["dataJson"],
      );

  Map<String, dynamic> toJson() => {
        "stamp": stamp,
        "dueDateTime": dueDateTime?.toIso8601String(),
        "taskTitle": taskTitle,
        "notes": notes,
        "taskList": taskList,
        "dataJson": dataJson,
      };
}
