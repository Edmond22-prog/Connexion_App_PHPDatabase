import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Employee.dart';

class Services {
  static const ROOT = "http://10.0.2.2/EmployeesDB/employee_actions.php";
  static const _CREATE_TABLE_ACTION = "CREATE_TABLE";
  static const _GET_ALL_ACTION = "GET_ALL";
  static const _ADD_EMP_ACTION = "ADD_EMP";
  static const _UPDATE_EMP_ACTION = "UPDATE_EMP";
  static const _DELETE_EMP_ACTION = "DELETE_EMP";

  // Method to create the table Employees.
  static Future<String> createTable() async {
    try {
      // Add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map["action"] = _CREATE_TABLE_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: jsonEncode(map));
      print('Create Table Response : ${response.body}');
      if(response.statusCode == 200) {
        return response.body;
      }else{
        print(response.statusCode);
        return "Error here 1";
      }
    }catch (e){
      return "Error here 2";
    }
  }


  static Future<List<Employee>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = _GET_ALL_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('getEmployees Response : ${response.body}');
      if(response.statusCode == 200){
        List<Employee> list = parseResponse(response.body);
        return list;
      }else{
        return List.empty();
      }
    }catch (e){
      return List.empty();  // return an empty list on exception/error
    }
  }


  static List<Employee> parseResponse (String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }


  // Method to add employee to the database...
  static Future<String> addEmployee(String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = _ADD_EMP_ACTION;
      map["first_name"] = firstName;
      map["last_name"] = lastName;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addEmployee Response : ${response.body}');
      if(response.statusCode == 200){
        return response.body;
      }else{
        return "Error";
      }
    }catch (e){
      return "Error";
    }
  }


  // Method to update an employee in database...
  static Future<String> updateEmployee(String empId, String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = _UPDATE_EMP_ACTION;
      map["emp_id"] = empId;
      map["first_name"] = firstName;
      map["last_name"] = lastName;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateEmployee Response : ${response.body}');
      if(response.statusCode == 200){
        return response.body;
      }else{
        return "Error";
      }
    }catch (e){
      return "Error";
    }
  }

  
  // Method to delete an employee from database...
  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = Map<String, dynamic>();
      map["action"] = _DELETE_EMP_ACTION;
      map["emp_id"] = empId;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deleteEmployee Response : ${response.body}');
      if(response.statusCode == 200){
        return response.body;
      }else{
        return "Error";
      }
    }catch (e){
      return "Error";
    }
  }
}