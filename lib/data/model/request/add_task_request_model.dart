class AddTaskRequestModel {
  DateTime? dueDateTime;
  String? taskTitle;
  String? notes;
  String? taskList;
  String? dataJson;

  AddTaskRequestModel({
    this.dueDateTime,
    this.taskTitle,
    this.notes,
    this.taskList,
    this.dataJson,
  });

  factory AddTaskRequestModel.fromJson(Map<String, dynamic> json) => AddTaskRequestModel(
        dueDateTime: json["dueDateTime"] == null ? null : DateTime.parse(json["dueDateTime"]),
        taskTitle: json["taskTitle"],
        notes: json["notes"],
        taskList: json["taskList"],
        dataJson: json["dataJson"],
      );

  Map<String, dynamic> toJson() => {
        "dueDateTime": dueDateTime?.toIso8601String(),
        "taskTitle": taskTitle,
        "notes": notes,
        "taskList": taskList,
        "dataJson": dataJson,
      };
}
