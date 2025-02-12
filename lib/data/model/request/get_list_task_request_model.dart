class GetListTaskRequestModel {
  int limit;
  int? currentPage;
  String? sortOrder;
  int? status;

  GetListTaskRequestModel({
    required this.limit,
    this.currentPage,
    this.sortOrder,
    this.status,
  });

  factory GetListTaskRequestModel.fromJson(Map<String, dynamic> json) => GetListTaskRequestModel(
        limit: json["limit"],
        currentPage: json["current_page"],
        sortOrder: json["sort_order"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "current_page": currentPage,
        "sort_order": sortOrder,
        "status": status,
      };
}
