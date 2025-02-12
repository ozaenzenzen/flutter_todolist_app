class DeleteTaskResponseModel {
  int? status;
  String? message;

  DeleteTaskResponseModel({
    this.status,
    this.message,
  });

  factory DeleteTaskResponseModel.fromJson(Map<String, dynamic> json) => DeleteTaskResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
