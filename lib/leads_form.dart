import 'dart:convert';

import 'package:crm_app/Utils/Constants/Colors.dart';
import 'package:crm_app/Utils/Constants/Helpers/helper_functions.dart';
import 'package:crm_app/Utils/Sizes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LeadForm extends StatefulWidget {
  const LeadForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LeadFormState createState() => _LeadFormState();
}

class _LeadFormState extends State<LeadForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _enquiryForController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _enquiryCityController = TextEditingController();
  final TextEditingController _leadStatusController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _selectedEnquiry = 'Select';
  String _selectedStatus = 'Select';
  String _selectedDuration = 'Select'; // Initial value
  final List<String> _enquiryOptions = ['Select', 'Scooty', 'Bike'];
  final List<String> _durationlist = [
    'Select',
    'Day',
    '1 Week',
    '2 Week',
    'Monthly'
  ];
  final List<String> _statuslist = [
    'Select',
    'Created',
    'Contacted',
    'Closed',
    'Not Converted'
  ];
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy'); // Date format
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse("http://localhost/addlead.php"),
        body: {
          'name': _nameController.text,
          'email': _emailController.text,
          'mobile_no': _mobileNoController.text,
          'enquiry_for': _enquiryForController.text,
          'start_date': _startDateController.text,
          'duration': _durationController.text,
          'enquiry_city': _enquiryCityController.text,
          'lead_status': _leadStatusController.text,
          'comment': _commentController.text,
        },
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      setState(() {});

      if (responseData['status'] == 'success') {
        _showSuccessDialog();
      } else {
        _showErrorDialog(responseData['message']);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: const Color.fromARGB(255, 41, 40, 40),
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Container(
              color: Colors.blueAccent,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: const Color.fromARGB(255, 41, 40, 40),
          content: const Text(
            "Lead created successfully!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Container(
              color: Colors.blueAccent,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double containerWidth = size.width * 0.1;
    final double screenWidth = size.width;
    bool dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Employee Code - 20210042",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("*-Required"),
                    InkWell(
                        onTap: () {
                            Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 15,
                        ))
                  ],
                ),
                const Divider(color: Color.fromARGB(255, 172, 172, 172)),
                Text(
                  "Name *",
                  style: TextStyle(
                      color: dark ? ColorsApp.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 172, 172, 172))),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Customer Name',
                      hintStyle: const TextStyle(
                        fontSize: Sizes.smmd,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: containerWidth * 0.3, bottom: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Text(
                  "Email *",
                  style: TextStyle(
                      color: dark ? ColorsApp.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 172, 172, 172))),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'Enter Customer Email',
                        hintStyle: const TextStyle(
                          fontSize: Sizes.smmd,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: containerWidth * 0.3, bottom: 10)),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Text(
                  "Mobile *",
                  style: TextStyle(
                      color: dark ? ColorsApp.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 172, 172, 172))),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: _mobileNoController,
                    decoration: InputDecoration(
                        hintText: 'Enter Customer Mobile',
                        hintStyle: const TextStyle(
                          fontSize: Sizes.smmd,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: containerWidth * 0.3, bottom: 10)),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Text(
                  "Enquiry in *",
                  style:
                      TextStyle(color: dark ? Colors.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 172, 172, 172))),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: _enquiryCityController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Enquiry City",
                      hintStyle: const TextStyle(
                        fontSize: Sizes.smmd,
                      ),
                      contentPadding: EdgeInsets.only(
                          left: containerWidth * 0.3, bottom: 10.0),
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Text(
                  "Enquiry For *",
                  style:
                      TextStyle(color: dark ? Colors.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 172, 172, 172),
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedEnquiry,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEnquiry = newValue!;
                        _enquiryForController.text =
                            newValue; // Update controller value
                      });
                    },
                    items: _enquiryOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: Sizes.smmd,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Select",
                      hintStyle: const TextStyle(
                        fontSize: Sizes.smmd,
                        color: Color.fromARGB(255, 172, 172, 172),
                      ),
                      contentPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                        bottom: 10.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Text(
                  "Start Date ",
                  style:
                      TextStyle(color: dark ? Colors.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 172, 172, 172),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _durationController.text = _dateFormat
                              .format(pickedDate); // Update controller value
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: _durationController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Date",
                          hintStyle: const TextStyle(
                            fontSize: Sizes.smmd,
                          ),
                          contentPadding: EdgeInsets.only(
                            left: containerWidth * 0.3,
                            bottom: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Text(
                  "Duration",
                  style:
                      TextStyle(color: dark ? Colors.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 172, 172, 172),
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedDuration,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDuration = newValue!;
                        _durationController.text =
                            newValue; // Update controller value
                      });
                    },
                    items: _durationlist
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: Sizes.smmd,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Select",
                      hintStyle: const TextStyle(
                        fontSize: Sizes.smmd,
                        color: Color.fromARGB(255, 172, 172, 172),
                      ),
                      contentPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                        bottom: 10.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Text(
                  "Status *",
                  style:
                      TextStyle(color: dark ? Colors.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 172, 172, 172),
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                        _leadStatusController.text =
                            newValue; // Update controller value
                      });
                    },
                    items: _statuslist
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: Sizes.smmd,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Select",
                      hintStyle: const TextStyle(
                        fontSize: Sizes.smmd,
                        color: Color.fromARGB(255, 172, 172, 172),
                      ),
                      contentPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                        bottom: 10.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Text(
                  "Comment ",
                  style:
                      TextStyle(color: dark ? Colors.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 172, 172, 172))),
                  child: TextField(
                    maxLines: null,
                    cursorColor: Colors.white,
                    controller: _commentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        top:10,
                          left: containerWidth * 0.3, bottom: 10.0),
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                const Divider(
                  color: Color.fromARGB(255, 172, 172, 172),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        height: 35,
                        width: screenWidth * 0.35,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: ColorsApp.greycon,
                        ),
                        child: InkWell(
                          onTap: () {
                               Navigator.of(context).pop();
                          },
                          child: const Center(
                            child: Text(
                              "Close",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: screenWidth * 0.05,
                    ),
                    InkWell(
                      onTap: _submitForm,
                      child: Container(
                          height: 35,
                          width: screenWidth * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: ColorsApp.darkgrey,
                          ),
                          child: const Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
