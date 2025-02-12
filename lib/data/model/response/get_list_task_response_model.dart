class GetLIstTaskResponseModel {
  int? status;
  String? message;
  DataPagination? data;

  GetLIstTaskResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetLIstTaskResponseModel.fromJson(Map<String, dynamic> json) => GetLIstTaskResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : DataPagination.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };

  Map<String, dynamic> toJsonPagination() => {
        "status": status,
        "message": message,
        "Data": data?.toJsonPagination(),
      };
}

class DataPagination {
  int? currentPage;
  int? nextPage;
  int? totalPages;
  int? totalItems;
  List<ListDatumTask>? listData;

  DataPagination({
    this.currentPage,
    this.nextPage,
    this.totalPages,
    this.totalItems,
    this.listData,
  });

  factory DataPagination.fromJson(Map<String, dynamic> json) => DataPagination(
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
        listData: json["list_data"] == null ? [] : List<ListDatumTask>.from(json["list_data"]!.map((x) => ListDatumTask.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_items": totalItems,
        "list_data": listData == null ? [] : List<dynamic>.from(listData!.map((x) => x.toJson())),
      };

  Map<String, dynamic> toJsonPagination() => {
        "current_page": currentPage,
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_items": totalItems,
      };
}

class ListDatumTask {
  String? stamp;
  int? status;
  DateTime? dueDateTime;
  String? taskTitle;
  String? notes;
  String? taskList;
  String? dataJson;

  ListDatumTask({
    this.stamp,
    this.status,
    this.dueDateTime,
    this.taskTitle,
    this.notes,
    this.taskList,
    this.dataJson,
  });

  factory ListDatumTask.fromJson(Map<String, dynamic> json) => ListDatumTask(
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

  Map<String, dynamic> toJsonWithoutDataJson() => {
        "stamp": stamp,
        "status": status,
        "dueDateTime": dueDateTime?.toIso8601String(),
        "taskTitle": taskTitle,
        "notes": notes,
        "taskList": taskList,
      };
}
