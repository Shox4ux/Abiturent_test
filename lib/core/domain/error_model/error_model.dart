class ErrorInfo {
  String? name;
  String? message;
  int? code;
  int? status;
  String? type;

  ErrorInfo({this.name, this.message, this.code, this.status, this.type});

  ErrorInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    message = json['message'];
    code = json['code'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['message'] = message;
    data['code'] = code;
    data['status'] = status;
    data['type'] = type;
    return data;
  }
}
