import 'package:mobile/common/common.dart';
import 'package:mobile/locale/locales.dart';

import 'loader_api.dart';
import 'model.dart';

class GlobalData {
  static DataAPI dataAPI = DataAPI();
  static List<Branch> branchList;
  static List<Department> departmentList;
  static List<ItemGroup> itemGroupList;
  static List<Employee> employeeList;
  static List<Employee> employeeSplitNameList;
  static List<Customer> customerList;
  static List<Supplier> supplierList;
  static List<Warehouse> parentWarehouseList;
  static FunctionalParam functionalParam;

  static Future<void> loadData() async {
    branchList = await dataAPI.findAllBranch();
    departmentList = await dataAPI.findAllDepartment();
    itemGroupList = await dataAPI.findAllItemGroup();
    employeeList = await dataAPI.findAllEmployee();
    employeeSplitNameList = await dataAPI.findAllEmployeeSplitName();
    customerList = await dataAPI.findAllCustomer();
    supplierList = await dataAPI.findAllSupplier();
    parentWarehouseList = await dataAPI.findParentWarehouse();
    functionalParam = await dataAPI.findSystemSettings();
  }

  static String getEmpName(int empId){
    if (employeeList == null || employeeList.length == 0)
      return "";
    if(empId == null)
      return L10n.ofValue().allUsers;
    else
      return employeeList.singleWhere((test) => test.id == empId, orElse: () => null)?.name;
  }

  static String getCustomerName(int customerId){
    if (customerList == null || customerList.length == 0)
      return "";
    if(customerId == null)
      return "---";
    else
      return customerList.singleWhere((test) => test.id == customerId, orElse: () => null)?.name;
  }

  static String getSupplierName(int supplierId){
    if (supplierList == null || supplierList.length == 0)
      return "";
    if(supplierId == null)
      return "---";
    else
      return supplierList.singleWhere((test) => test.id == supplierId, orElse: () => null)?.name;
  }

  static bool isAdminUser() {
    if ((GlobalParam.adminIds?.length??0) > 0 && GlobalParam.adminIds.contains(GlobalParam.USER_ID))
      return true;

    return false;
  }
}