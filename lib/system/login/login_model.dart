import 'package:json_annotation/json_annotation.dart';
part 'login_model.g.dart';

@JsonSerializable()
class AuthRequest {
  final String resetToken;
  final String username;
  final String password;
  final num companyId;
  final num branchId;
  final String urlPrefix;
  

  AuthRequest({
    this.resetToken,
    this.urlPrefix,
    this.username,
    this.password,
    this.companyId,
    this.branchId
  });

  factory AuthRequest.fromJson(Map<String, dynamic> json) => _$AuthRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final int userId;
  final int employeeId;
  final String username;
  final String fullName;
  final String token;
  final String loginResult;
  AuthResponse({
    this.userId,
    this.employeeId,
    this.fullName,
    this.username,
    this.loginResult,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}