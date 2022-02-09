import 'package:flutter/material.dart';
import 'models/Employee.dart';
import 'models/Services.dart';

class DataTableDemo extends StatefulWidget {
  const DataTableDemo({Key? key}) : super(key: key);

  final String title = "Flutter Data Table";

  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  late List<Employee> _employees;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  // Controller for the first name textfield we are going
  late TextEditingController _firstNameController;

  // Controller for the last name textfield we are going
  late TextEditingController _lastNameController;
  late Employee _selectedEmployee;
  late bool _isUpdating;
  late String _titleProgress;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getEmployees();
  }

  // Methode to update title in the Appbar title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTable().then((value) {
      if (value == 'Success') {
        _showSnackBar(context, value);
        _showProgress(widget.title);
      } else {
        _showProgress(widget.title);
      }
    });
  }

  _addEmployee() {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      print("Empty Fields");
      return;
    }
    _showProgress("Adding Employee...");
    Services.addEmployee(_firstNameController.text, _lastNameController.text)
        .then((result) {
      if (result == "Success") {
        _getEmployees(); // Refresh the list after adding each employee...
        _clearValues();
      }
    });
  }

  _getEmployees() {
    _showProgress("Loading Employees...");
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${employees.length}");
    });
  }

  _updateEmployee(Employee employee) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress("Updating Employee...");
    Services.updateEmployee(
            employee.id, _firstNameController.text, _lastNameController.text)
        .then((result) {
      if (result == "Success") {
        _getEmployees(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deleteEmployee(Employee employee) {
    _showProgress("Deleting Employee...");
    Services.deleteEmployee(employee.id).then((result) {
      if (result == "Success") {
        _getEmployees(); // Refresh after delete...
      }
    });
  }

  // Method to clear the TextField values
  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  _showValues(Employee employee) {
    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;
  }

  // Create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horizontal Scrollview for the DataTable to scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('FIRST NAME')),
            DataColumn(label: Text('LAST NAME')),
            DataColumn(label: Text('DELETE')),
          ],
          rows: _employees
              .map(
                (employee) => DataRow(cells: [
                  DataCell(Text(employee.id),
                      // Add tap in the row and populate the textfields with the
                      // corresponding values to update
                      onTap: () {
                    _showValues(employee);
                    // Set the selected employee to update
                    _selectedEmployee = employee;
                    // Set flag updating to true to indicate in update mode
                    setState(() {
                      _isUpdating = true;
                    });
                  }),
                  DataCell(Text(employee.firstName.toUpperCase()), onTap: () {
                    _showValues(employee);
                    // Set the selected employee to update
                    _selectedEmployee = employee;
                    // Set flag updating to true to indicate in update mode
                    setState(() {
                      _isUpdating = true;
                    });
                  }),
                  DataCell(Text(employee.lastName.toUpperCase()), onTap: () {
                    _showValues(employee);
                    // Set the selected employee to update
                    _selectedEmployee = employee;
                    // Set flag updating to true to indicate in update mode
                    setState(() {
                      _isUpdating = true;
                    });
                  }),
                  DataCell(IconButton(icon: Icon(Icons.delete), onPressed: () {
                    _deleteEmployee(employee);
                  },))
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getEmployees();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(hintText: 'First Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(hintText: 'Last Name'),
              ),
            ),
            // Add an update button and cancel button
            // Show these buttons only when updating an employee
            _isUpdating
                ? Row(
                    children: [
                      OutlinedButton(
                        child: Text('Update'),
                        onPressed: () {
                          _updateEmployee(_selectedEmployee);
                        },
                      ),
                      OutlinedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          setState(() {
                            _isUpdating = false;
                          });
                          _clearValues();
                        },
                      ),
                    ],
                  )
                : Container(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
