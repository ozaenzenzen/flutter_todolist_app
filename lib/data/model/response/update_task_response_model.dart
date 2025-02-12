class UpdateTaskResponseModel {
  int? status;
  String? message;

  UpdateTaskResponseModel({
    this.status,
    this.message,
  });

  factory UpdateTaskResponseModel.fromJson(Map<String, dynamic> json) => UpdateTaskResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
