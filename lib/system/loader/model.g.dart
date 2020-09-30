part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Branch _$BranchFromJson(Map<String, dynamic> json) {
  return Branch(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$BranchToJson(Branch instance) =>
  <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };



Department _$DepartmentFromJson(Map<String, dynamic> json) {
  return Department(
    branchId: json['branchId'] as int,
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
  <String, dynamic>{
    'branchId': instance.branchId,
    'id': instance.id,
    'name': instance.name,
  };

ItemGroup _$ItemGroupFromJson(Map<String, dynamic> json) {
  return ItemGroup(
    id: json['id'] as int,
    code: json['code'] as String,
  );
}

Map<String, dynamic> _$ItemGroupToJson(ItemGroup instance) =>
  <String, dynamic>{
    'id': instance.id,
    'code': instance.code,
  };

Employee _$EmployeeFromJson(Map<String, dynamic> json) {
  return Employee(
    id: json['id'] as int,
    userId: json['userId'] as int,
    name: json['name'] as String,
    branchId: json['branchId'] as int,
    departmentId: json['departmentId'] as int,
    groupId: json['groupId'] as int,
  );
}

Map<String, dynamic> _$EmployeeToJson(Employee instance) =>
  <String, dynamic>{
    'id': instance.id,
    'userId': instance.userId,
    'name': instance.name,
    'branchId': instance.branchId,
    'departmentId': instance.departmentId,
    'groupId': instance.groupId,
  };

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    id: json['id'] as int,
    name: json['name'] as String,
    code: json['code'] as String,
    unaccentName: json['unaccentName'] as String,
    address: json['address'] as String,
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'unaccentName': instance.unaccentName,
      'address': instance.address,
    };


Supplier _$SupplierFromJson(Map<String, dynamic> json) {
  return Supplier(
    id: json['id'] as int,
    name: json['name'] as String,
    code: json['code'] as String,
  );
}

Map<String, dynamic> _$SupplierToJson(Supplier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
    };


Warehouse _$WarehouseFromJson(Map<String, dynamic> json) {
  return Warehouse(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$WarehouseToJson(Warehouse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };


FunctionalParam _$FunctionalParamFromJson(Map<String, dynamic> json) {
  return FunctionalParam(
    saleLimitDay: json['saleLimitDay'] as int,
    otherLimitDay: json['otherLimitDay'] as int,
  );
}

Map<String, dynamic> _$FunctionalParamToJson(FunctionalParam instance) =>
    <String, dynamic>{
      'saleLimitDay': instance.saleLimitDay,
      'otherLimitDay': instance.otherLimitDay,
    };