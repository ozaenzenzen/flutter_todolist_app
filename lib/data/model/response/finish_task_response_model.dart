class FinishTaskResponseModel {
  int? status;
  String? message;

  FinishTaskResponseModel({
    this.status,
    this.message,
  });

  factory FinishTaskResponseModel.fromJson(Map<String, dynamic> json) => FinishTaskResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
