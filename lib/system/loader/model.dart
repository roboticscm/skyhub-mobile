import 'package:json_annotation/json_annotation.dart';
part 'model.g.dart';

@JsonSerializable()
class Branch {
  final int id;
  final String name;

  Branch({
    this.id,
    this.name
  });
  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
  Map<String, dynamic> toJson() => _$BranchToJson(this);
}


@JsonSerializable()
class Department {
  final int branchId;
  final int id;
  final String name;

  Department({
    this.branchId,
    this.id,
    this.name,
  });
  factory Department.fromJson(Map<String, dynamic> json) => _$DepartmentFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
}

@JsonSerializable()
class ItemGroup {
  final int id;
  final String code;

  ItemGroup({
    this.id,
    this.code,
  });
  factory ItemGroup.fromJson(Map<String, dynamic> json) => _$ItemGroupFromJson(json);
  Map<String, dynamic> toJson() => _$ItemGroupToJson(this);
}

@JsonSerializable()
class Employee {
  final int id;
  final int userId;
  final String name;
  final int branchId;
  final int departmentId;
  final int groupId;
  Employee({
    this.id,
    this.userId,
    this.name,
    this.branchId,
    this.departmentId,
    this.groupId
  });
  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}


@JsonSerializable()
class Customer {
  final int id;
  final String name;
  final String code;
  final String unaccentName;
  final String address;
  Customer({
    this.id,
    this.code,
    this.name,
    this.unaccentName,
    this.address,
  });
  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class Supplier {
  final int id;
  final String name;
  final String code;
  Supplier({
    this.id,
    this.name,
    this.code,
  });
  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierToJson(this);
}

@JsonSerializable()
class Warehouse {
  final int id;
  final String name;
  Warehouse({
    this.id,
    this.name,
  });
  factory Warehouse.fromJson(Map<String, dynamic> json) => _$WarehouseFromJson(json);
  Map<String, dynamic> toJson() => _$WarehouseToJson(this);
}


@JsonSerializable()
class FunctionalParam {
  final int saleLimitDay;
  final int otherLimitDay;
  FunctionalParam({
    this.saleLimitDay,
    this.otherLimitDay,
  });
  factory FunctionalParam.fromJson(Map<String, dynamic> json) => _$FunctionalParamFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionalParamToJson(this);
}