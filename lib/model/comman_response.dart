import 'package:tkd_app/model/truck_load_model.dart';

class CommonResponse {
  String? message;
  TruckLoad? data;
  bool? success;

  CommonResponse({
    this.message,
    this.data,
    this.success,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
    message: json["message"],
    data: json["data"] == null ? null : TruckLoad.fromJson(json["data"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "success": success,
  };
}