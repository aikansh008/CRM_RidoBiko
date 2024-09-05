import 'dart:convert';

import 'package:crm_app/Utils/Constants/Colors.dart';
import 'package:crm_app/Utils/Constants/Helpers/helper_functions.dart';
import 'package:crm_app/Utils/Sizes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UpdateLead extends StatefulWidget {
  final String name;
  final String email;
  final String mobilenumber;
  final String enquiryin;
  final String enquiryfor;
  final String enquiryid;
  final String date;
  final String comment;
  final String employee;

  const UpdateLead({
    super.key,
    required this.name,
    required this.email,
    required this.mobilenumber,
    required this.enquiryin,
    required this.enquiryfor,
    required this.enquiryid,
    required this.date,
    required this.comment,
    required this.employee,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LeadFormState createState() => _LeadFormState();
}

class _LeadFormState extends State<UpdateLead> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _leadStatusController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final String _selectedStatus = 'Select';
  final String _selectedDuration = 'Select';
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
    'Not Converted',
    'Closed'
  ];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse("https://ridobiko.in/crm/mobile_app_apis/updatelead.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'enquiry_id': widget.enquiryid,
          'duration': _durationController.text,
          'start_date': _startDateController.text,
          'status': _leadStatusController.text,
          'comment': _commentController.text,
        }),
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
            "Lead updated successfully!",
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
                Text(
                  "Enquiry Id -#${widget.enquiryid} | Employee code -${widget.employee}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Last Connected - ${widget.date}"),
                    InkWell(
                      onTap: () {
                           Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 15,
                      ),
                    )
                  ],
                ),
                const Divider(color: Color.fromARGB(255, 172, 172, 172)),
                _buildReadonlyField("Name", widget.name, containerWidth, dark),
                _buildReadonlyField(
                    "Email", widget.email, containerWidth, dark),
                _buildReadonlyField(
                    "Mobile", widget.mobilenumber, containerWidth, dark),
                _buildReadonlyField(
                    "Enquiry in", widget.enquiryin, containerWidth, dark),
                _buildReadonlyField(
                    "Enquiry For", widget.enquiryfor, containerWidth, dark),
                _buildDateField(
                    "Start Date", _startDateController, containerWidth, dark),
                _buildDropdownField(
                    "Duration",
                    _durationlist,
                    _selectedDuration,
                    _durationController,
                    containerWidth,
                    dark),
                _buildDropdownField("Status", _statuslist, _selectedStatus,
                    _leadStatusController, containerWidth, dark),
                _buildTextField(
                    "Comment", _commentController, containerWidth, dark,
                    height: 80),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Text(
                  "Logs:",
                  style:
                      TextStyle(color: dark ? Colors.white : ColorsApp.black),
                ),
                const SizedBox(height: Sizes.spaceBtwtextfileds),
                Text(
                  widget.comment,
                  style: TextStyle(
                    color: dark ? Colors.white : ColorsApp.black,
                    fontSize: Sizes.smmd,
                  ),
                ),
                const SizedBox(height: 100),
                const Divider(color: Color.fromARGB(255, 172, 172, 172)),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton(screenWidth * 0.35, "Close", ColorsApp.greycon,
                        () {
                        Navigator.of(context).pop();
                    }),
                    SizedBox(width: screenWidth * 0.05),
                    _buildButton(screenWidth * 0.35, "Submit",
                        ColorsApp.darkgrey, _submitForm),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadonlyField(
      String label, String value, double containerWidth, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: dark ? ColorsApp.white : ColorsApp.black)),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 172, 172, 172)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: containerWidth * 0.3),
            child: Align(alignment: Alignment.centerLeft, child: Text(value)),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      double containerWidth, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: dark ? Colors.white : ColorsApp.black)),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 172, 172, 172)),
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
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  controller.text = formattedDate;
                });
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: containerWidth * 0.3, bottom: 10.0),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
      ],
    );
  }

  Widget _buildDropdownField(
      String label,
      List<String> options,
      String selectedValue,
      TextEditingController controller,
      double containerWidth,
      bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: dark ? Colors.white : ColorsApp.black)),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 172, 172, 172)),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
                controller.text = newValue;
              });
            },
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child:
                    Text(value, style: const TextStyle(fontSize: Sizes.smmd)),
              );
            }).toList(),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Select",
              hintStyle: const TextStyle(
                  fontSize: Sizes.smmd,
                  color: Color.fromARGB(255, 172, 172, 172)),
              contentPadding:
                  EdgeInsets.only(left: containerWidth * 0.3, bottom: 10.0),
            ),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      double containerWidth, bool dark,
      {double height = 40}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: dark ? Colors.white : ColorsApp.black)),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 172, 172, 172)),
          ),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: containerWidth * 0.3, bottom: 10.0),
            ),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
      ],
    );
  }

  Widget _buildButton(
      double width, String label, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 35,
        width: width,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: color,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
