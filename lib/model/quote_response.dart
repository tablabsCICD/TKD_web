class QuoteRespose {
  int? statusCode;
  String? message;
  bool? isSuccess;

  QuoteRespose({
    this.statusCode,
    this.message,
    this.isSuccess,
  });

  factory QuoteRespose.fromJson(Map<String, dynamic> json) => QuoteRespose(
    statusCode: json["statusCode"],
    message: json["message"],
    isSuccess: json["isSuccess"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "isSuccess": isSuccess,
  };
}
