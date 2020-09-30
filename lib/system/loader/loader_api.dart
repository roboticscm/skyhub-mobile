import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/common/http.dart';

import 'model.dart';

class DataAPI {
  Future<List<Branch>> findAllBranch() async {
    const URL = 'system/branch/find-all';
    try {
      var response = await Http.get(URL);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Branch.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<Department>> findAllDepartment() async {
    const URL = 'system/department/find-all';
    try {
      var response = await Http.get(URL);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Department.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<ItemGroup>> findAllItemGroup() async {
    const URL = 'system/item-group/find-all';
    try {
      var response = await Http.get(URL);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => ItemGroup.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<Employee>> findAllEmployee() async {
    const URL = 'system/employee/find-all';
    try {
      var response = await Http.get(URL);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Employee.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<Employee>> findAllEmployeeSplitName() async {
    const URL = 'system/employee/find-all-split-name';
    try {
      var response = await Http.get(URL);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Employee.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<Employee>> findNeighbourEmployee(int userId, String business) async {
    const URL = 'system/employee/find-neighbour-employee';
    try {
      var response = await Http.get('$URL?userId=$userId&business=$business');
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Employee.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<Customer>> findAllCustomer() async {
    const URL = 'system/customer/find-all';
    try {
      var response = await Http.get(URL);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Customer.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<Supplier>> findAllSupplier() async {
    const URL = 'system/supplier/find-all';
    try {
      var response = await Http.get(URL);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Supplier.fromJson(model)).toList();
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<List<Warehouse>> findParentWarehouse() async {
    const URL = 'inventory/find-warehouse-by-parent-id?parentId=0';
    try {
      var response = await Http.get(URL);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Warehouse.fromJson(model)).toList();
      }else {
        print(response.body);
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }

  Future<FunctionalParam> findSystemSettings() async {
    const URL = 'system/param/find-system-settings';
    try {
      var response = await Http.get(URL);

      if (response.statusCode == 200) {
        return FunctionalParam.fromJson(json.decode(response.body));
      }else {
        print(response.body);
      }
    }
    catch (e) {
      debugPrint('error ' + e.toString());
      return null;
    }
    return null;
  }
}