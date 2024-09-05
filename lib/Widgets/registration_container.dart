import 'dart:convert'; // For JSON encoding and decoding

import 'package:crm_app/Utils/Constants/Colors.dart';
import 'package:crm_app/Widgets/update_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationContainer extends StatelessWidget {
  final String name;
  final String phone;
  final String city;
  final String vehicle;
  final String date;
  final String id;
  final String duration;
  final String comment;
  final String status;
  final double containerHeight;
  // ignore: non_constant_identifier_names
  final String enquiry_id;
  final String email;

  const RegistrationContainer({
    super.key,
    required this.containerHeight,
    required this.name,
    required this.phone,
    required this.city,
    required this.vehicle,
    required this.date,
    required this.id,
    required this.duration,
    required this.comment,
    required this.status,
    required this.enquiry_id,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: screenWidth,
      decoration: BoxDecoration(
        color: ColorsApp.darkgreen.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: screenWidth * 0.5,
              constraints: const BoxConstraints(),
              child: Image.asset(
                "assets/images/Wave design  - Copy.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7, right: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.044,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final phoneNumber = Uri.parse('tel:$phone');
                              if (await launchUrl(phoneNumber)) {
                                await launchUrl(phoneNumber);
                              } else {
                                throw 'Could not launch $phoneNumber';
                              }
                            },
                            child: Text(
                              phone,
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              city,
                              style: TextStyle(
                                fontSize: screenWidth * 0.044,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              vehicle,
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Start Date",
                            style: TextStyle(
                              fontSize: screenWidth * 0.044,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: screenWidth * 0.038,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Created By",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.044,
                            ),
                          ),
                          Text(
                            id,
                            style: TextStyle(
                              fontSize: screenWidth * 0.038,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            "Duration",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.044,
                            ),
                          ),
                          Text(
                            duration,
                            style: TextStyle(
                              fontSize: screenWidth * 0.038,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Last Comment",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.044,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.1,
                            child: Text(
                              comment,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.038,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.044,
                            ),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: screenWidth * 0.038,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: screenHeight * 0.02,
                right: screenHeight * 0.02,
                bottom: screenHeight * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateLead(
                                    name: name,
                                    email: email,
                                    mobilenumber: phone,
                                    enquiryin: city,
                                    enquiryfor: vehicle,
                                    enquiryid: enquiry_id,
                                    date: date,
                                    comment: comment,
                                    employee: id,
                                  )));
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.03,
                      ),
                      child: Image.asset(
                        "assets/images/Posters_20240705_080928_0005.png",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          final phoneNumber = Uri.parse('tel:+91$phone');
                          if (await launchUrl(phoneNumber)) {
                            await launchUrl(phoneNumber);
                          } else {
                            throw 'Could not launch $phoneNumber';
                          }
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: screenHeight * 0.03,
                          ),
                          child: Image.asset(
                            "assets/images/Posters_20240705_080928_0006.png",
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () async {
                          await _launchWhatsApp(phone);
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: screenHeight * 0.03,
                          ),
                          child: Image.asset(
                            "assets/images/Posters_20240705_080928_0007.png",
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _showAddTemplatesDialog(context);
                    },
                    child: Container(
                      height: screenHeight * 0.04,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: ColorsApp.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add Templates",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.015,
                            ),
                          ),
                          Image.asset(
                            "assets/images/Posters_20240705_080927_0004.png",
                            scale: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWhatsApp(String phone) async {
    final whatsappUrl = Uri.parse('https://wa.me/+91$phone');
    try {
      await launchUrl(whatsappUrl);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showAddTemplatesDialog(BuildContext context) async {
    List<Map<String, String>> templates = await TemplateManager.getTemplates();

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Templates'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display existing templates
                Expanded(
                  child: ListView.builder(
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      final template = templates[index];
                      return ListTile(
                        title: Text(template['title'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                // Handle copy action
                                Clipboard.setData(
                                  ClipboardData(
                                    text: ' ${template['subtitle']}',
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Template copied to clipboard')),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class TemplateManager {
  static const String _keyTemplates = 'templates';

  // Retrieve stored templates
  static Future<List<Map<String, String>>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonTemplates = prefs.getString(_keyTemplates);
    if (jsonTemplates == null) return [];
    final List<dynamic> jsonList = json.decode(jsonTemplates);
    return jsonList.map((json) => Map<String, String>.from(json)).toList();
  }

  // Save templates
  static Future<void> saveTemplates(List<Map<String, String>> templates) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonTemplates = json.encode(templates);
    await prefs.setString(_keyTemplates, jsonTemplates);
  }
}
