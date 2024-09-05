// import 'dart:convert';
// import 'package:crm_app/Utils/Constants/Colors.dart';
// import 'package:crm_app/Utils/Constants/Helpers/helper_functions.dart';
// import 'package:crm_app/Utils/Sizes.dart';
// import 'package:crm_app/Widgets/card_container.dart';
// import 'package:crm_app/Widgets/drawerwidget.dart';
// import 'package:crm_app/Widgets/registration_container.dart';
// import 'package:crm_app/leads_form.dart';
// import 'package:crm_app/potentilal_leads.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AllLeads extends StatefulWidget {
//   const AllLeads({super.key});

//   @override
//   State<AllLeads> createState() => _AllLeadsState();
// }

// class _AllLeadsState extends State<AllLeads> {
//   List<dynamic> leads = [];
//   List<dynamic> Contacted = [];
//   List<dynamic> Created = [];
//   List<dynamic> closed = [];
//   List<dynamic> notconverted = [];
//   List<dynamic> filteredLeads = [];
//   List<dynamic> statusFilteredLeads = [];
  
//   String selectedStatus = "Contacted"; // Track the selected status
//   int convertedCount = 0;
//   int notConvertedCount = 0;
//   int closedCount = 0;
//   int created = 0;
//   final TextEditingController _searchController = TextEditingController();
//   int variable = 1;

//   Future<void> fetchLeads() async {
//     try {
//       final response = await http.get(
//           Uri.parse("https://ridobiko.in/crm/mobile_app_apis/getlead.php"));
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         setState(() {
//           leads =
//               jsonResponse['leads']; // Update to match your response structure
//           filteredLeads = leads;

//           // Initialize counts
//           convertedCount = 0;
//           notConvertedCount = 0;
//           closedCount = 0;
//           created = 0;
//           // Calculate counts
//           for (var lead in leads) {
//             final status = lead["lead_status"];
//             if (status == "Contacted") {
//               Contacted.add(lead);
//               convertedCount++;
//             } else if (status == "Not Converted") {
//               notconverted.add(lead);
//               notConvertedCount++;
//             } else if (status == "Closed") {
//               closed.add(lead);
//               closedCount++;
//             } else if (status == "Created") {
//               Created.add(lead);
//               created++;
//             }
//           }

//           // Apply status filtering
//         });
//       } else {
//         if (kDebugMode) {
//           print("Failed to fetch leads: ${response.statusCode}");
//         }
//         if (kDebugMode) {
//           print("Response body: ${response.body}");
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error fetching leads: $e");
//       }
//     }
//   }

//   // void _filterLeads(String query) {
//   //   setState(() {
//   //     filteredLeads = leads.where((lead) {
//   //       final name = lead["name"].toLowerCase();
//   //       final mobileNo = lead["mobile_no"].toLowerCase();
//   //       final city = lead["enquiry_city"].toLowerCase();
//   //       final searchQuery = query.toLowerCase();

//   //       return name.contains(searchQuery) ||
//   //           mobileNo.contains(searchQuery) ||
//   //           city.contains(searchQuery);
//   //     }).toList();
//   //     _filterLeadsByStatus();
//   //   });
//   // }

//   // void _filterLeadsByStatus(List<dynamic> temp) {
//   //   setState(() {
//   //     if (selectedStatus == "Created") {
//   //       statusFilteredLeads = Created;
//   //     } else if (selectedStatus == "Contacted") {
//   //       statusFilteredLeads = filteredLeads.where((lead) {
//   //         return lead["lead_status"] == "Created";
//   //       }).toList();
//   //     } else {
//   //       statusFilteredLeads = filteredLeads.where((lead) {
//   //         return lead["lead_status"] == selectedStatus;
//   //       }).toList();
//   //     }
//   //   });
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   fetchLeads(); // Fetch leads when the widget is initialized

//   //   _searchController.addListener(() {
//   //     _filterLeads(_searchController.text);
//   //   });
//   // }

//   // @override
//   // void dispose() {
//   //   _searchController.dispose();
//   //   super.dispose();
//   // }

//   Widget buildLeadList(List<dynamic> leads) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: leads.length,
//       itemBuilder: (context, index) {
//         final lead = leads[index];
//         return RegistrationContainer(
//           containerHeight: 200,
//           name: lead['name'] ?? 'Name not available',
//           phone: lead['mobile_no'] ?? 'Phone not available',
//           city: lead['enquiry_city'] ?? 'City not available',
//           vehicle: lead['enquiry_for'] ?? 'Vehicle not available',
//           date: lead['start_date'] ?? 'Date not available',
//           id: lead['created_by'] ?? 'ID not available',
//           duration: lead['duration'] ?? 'Duration not available',
//           comment: lead['comment'] ?? 'Comment not available',
//           status: lead['lead_status'] ?? 'Status not available',
//           enquiry_id: lead['enquiry_id'] ?? 'Enquiry ID not available',
//           email: lead['email'] ?? 'Email not available',
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//      final size = MediaQuery.of(context).size;
//     final double containerWidth = size.width * 0.4;
//     bool dark = HelperFunctions.isDarkMode(context);
//     List<dynamic> currentLeads;
//     if (variable == 1) {
//       currentLeads = Created;
//     } else if (variable == 2) {
//       currentLeads = Contacted;
//     } else if (variable == 3) {
//       currentLeads = closed;
//     } else {
//       currentLeads = notconverted;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: dark ? Colors.white : Colors.black,
//         ),
//         title: const Text("All Leads"),
//         centerTitle: true,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               margin:
//                   EdgeInsets.only(top: HelperFunctions.screenHeight() * 0.06),
//               decoration: const BoxDecoration(
//                 color: ColorsApp.greycon,
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(left: 10),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundImage: AssetImage(
//                               "assets/images/facebook-female-profile-icon-16.png"),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "Manas Ranjan",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         Text(
//                           "7079964300",
//                           style: TextStyle(color: Colors.white, fontSize: 11),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 18.0),
//                       child: Icon(
//                         Icons.arrow_forward_ios,
//                         color: Colors.white,
//                         size: 10,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                   top: HelperFunctions.screenHeight() * 0.05,
//                   left: HelperFunctions.screenWidth() * .01),
//               child: const Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   DrawerWidget(
//                     heading: "Analytics",
//                     widget: AllLeads(),
//                   ),
//                   DrawerWidget(
//                     heading: "All Leads",
//                     subheading: "Overall Leads",
//                     widget: AllLeads(),
//                   ),
//                   DrawerWidget(
//                       heading: "Today's Potential Leads",
//                       subheading: "Overall Potential Leads",
//                       widget: PotentialLeads()),
//                   DrawerWidget(
//                       heading: "Signed up but not Transacted",
//                       subheading: "",
//                       widget: AllLeads()),
//                   DrawerWidget(
//                       heading: "Add new Template",
//                       subheading: "",
//                       widget: AboutDialog()),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               const SizedBox(height: Sizes.spaceBtwSections),
//               // Status Dropdown
//               // DropdownButton<String>(
//               //   value: selectedStatus,
//               //   items: ["All", "Contacted", "Closed", "Not Converted"]
//               //       .map((status) => DropdownMenuItem<String>(
//               //             value: status,
//               //             child: Text(status),
//               //           ))
//               //       .toList(),
//               //   onChanged: (value) {
//               //     setState(() {
//               //       selectedStatus = value ?? "All";
//               //       _filterLeadsByStatus();
//               //     });
//               //   },
//               // ),
//               const SizedBox(height: Sizes.spaceBtwSections),
//               // CardContainers
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     variable = 1;
//                   });
//                 },
//                 child: CardContainer(
//                   c1: const Color.fromARGB(255, 222, 174, 150),
//                   c2: const Color.fromARGB(255, 222, 68, 155),
//                   days: "Created",
//                   numbers: created.toString(),
//                 ),
//               ),
//               const SizedBox(height: Sizes.spaceBtwSections),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     variable = 2;
//                   });
//                 },
//                 child: CardContainer(
//                   c1: const Color.fromARGB(255, 123, 162, 220),
//                   c2: const Color.fromARGB(255, 15, 135, 205).withOpacity(0.9),
//                   days: "Contacted",
//                   numbers: convertedCount.toString(),
//                 ),
//               ),
//               const SizedBox(height: Sizes.spaceBtwSections),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     variable = 3;
//                   });
//                 },
//                 child: CardContainer(
//                   c1: const Color.fromARGB(250, 14, 240, 179).withOpacity(0.9),
//                   c2: const Color.fromARGB(255, 7, 188, 139),
//                   days: "Closed",
//                   numbers: closedCount.toString(),
//                 ),
//               ),
//               const SizedBox(height: Sizes.spaceBtwSections),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     variable = 4;
//                   });
//                 },
//                 child: CardContainer(
//                   c1: const Color.fromARGB(255, 40, 39, 39).withOpacity(0.8),
//                   c2: const Color.fromARGB(66, 51, 47, 47),
//                   days: "Not Converted",
//                   numbers: notConvertedCount.toString(),
//                 ),
//               ),
//               const SizedBox(height: Sizes.spaceBtwSections),
//               Container(
//                 width: double.infinity,
//                 color: dark
//                     ? const Color.fromARGB(255, 48, 44, 44)
//                     : ColorsApp.white2,
//                 height: 160,
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Search (Name/Mobile/City)",
//                       style: TextStyle(fontSize: Sizes.smmd),
//                     ),
//                     Container(
//                       color: dark
//                           ? ColorsApp.darkgrey
//                           : const Color.fromARGB(255, 190, 190, 190),
//                       height: 40,
//                       child: Row(
//                         children: [
//                           Flexible(
//                             flex: 1,
//                             child: Container(
//                               alignment: Alignment.center,
//                               child: const Icon(
//                                 Icons.search,
//                                 size: Sizes.iconXs,
//                               ),
//                             ),
//                           ),
//                           Flexible(
//                             flex: 3,
//                             child: Container(
//                               alignment: Alignment.center,
//                               color: ColorsApp.white,
//                               child: TextFormField(
//                                 controller: _searchController,
//                                 style: const TextStyle(color: Colors.black),
//                                 decoration: const InputDecoration(
//                                   contentPadding: EdgeInsets.only(bottom: 10),
//                                   border: InputBorder.none,
//                                   hintText: "Search Name/Mobile/City",
//                                   hintStyle: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: Sizes.smmd,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Flexible(
//                             flex: 3,
//                             child: Container(
//                               alignment: Alignment.center,
//                               color: ColorsApp.darkgrey,
//                               child: const Text(
//                                 "Search",
//                                 style: TextStyle(color: ColorsApp.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const LeadForm()),
//                         ).then((_) {
//                           // Refresh the screen after returning from LeadForm
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const AllLeads()),
//                           );
//                         });
//                       },
//                       child: Container(
//                         height: 40,
//                         width: containerWidth,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(3),
//                           color: ColorsApp.darkgrey,
//                         ),
//                         child: const Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Add Lead",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: Sizes.spaceBtwSections),
//               statusFilteredLeads.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: statusFilteredLeads.length,
//                       itemBuilder: (context, index) {
//                         return LeadCard(lead: statusFilteredLeads[index]);
//                       },
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class LeadCard extends StatelessWidget {
//   final dynamic lead;

//   const LeadCard({super.key, required this.lead});

//   @override
//   Widget build(BuildContext context) {
//     return RegistrationContainer(
//       containerHeight: 250,
//       name: '${lead["name"]}',
//       phone: '${lead["mobile_no"]}',
//       city: '${lead["enquiry_city"]}',
//       vehicle: '${lead["enquiry_for"]}',
//       date: " ${lead["enquiry_date"]}",
//       id: "${lead["employee_code"]}",
//       duration: " ${lead["duration"]}",
//       comment: "${lead["comment"]}",
//       status: "${lead["lead_status"]}",
//       enquiry_id: '${lead["enquiry_id"]}',
//       email: '${lead["email"]}',
//     );
//   }
// }

// class AddTemplatesDialog extends StatefulWidget {
//   const AddTemplatesDialog({super.key});

//   @override
//   _AddTemplatesDialogState createState() => _AddTemplatesDialogState();
// }

// class _AddTemplatesDialogState extends State<AddTemplatesDialog> {
//   List<Map<String, String>> templates = [];

//   @override
//   void initState() {
//     super.initState();
//     loadTemplates();
//   }

//   Future<void> loadTemplates() async {
//     templates = await TemplateManager.getTemplates();
//     setState(() {});
//   }

//   Future<void> saveTemplates() async {
//     await TemplateManager.saveTemplates(templates);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Templates'),
//       content: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: templates.length,
//                 itemBuilder: (context, index) {
//                   final template = templates[index];
//                   return ListTile(
//                     title: Text(template['title'] ?? ''),
//                     subtitle: Text(
//                       template['subtitle'] ?? '',
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 3,
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () async {
//                             setState(() {
//                               templates.removeAt(index);
//                             });
//                             await saveTemplates();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Template deleted')),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => _AddNewTemplateDialog(
//                     onAddTemplate: (title, subtitle) async {
//                       if (title.isNotEmpty && subtitle.isNotEmpty) {
//                         setState(() {
//                           templates.add({
//                             'title': title,
//                             'subtitle': subtitle,
//                           });
//                         });
//                         await saveTemplates();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text('Template added successfully')),
//                         );
//                       }
//                     },
//                   ),
//                 );
//               },
//               child: const Text('Add Template'),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
// }

// class _AddNewTemplateDialog extends StatefulWidget {
//   final Future<void> Function(String title, String subtitle) onAddTemplate;

//   const _AddNewTemplateDialog({required this.onAddTemplate, super.key});

//   @override
//   _AddNewTemplateDialogState createState() => _AddNewTemplateDialogState();
// }

// class _AddNewTemplateDialogState extends State<_AddNewTemplateDialog> {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController subtitleController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add New Template'),
//       content: Container(
//         width: double.maxFinite,
//         constraints: const BoxConstraints(
//           maxHeight: 500, // Set the maximum height of the dialog
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Title',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0), // Rounded corners
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                       vertical: 10.0,
//                       horizontal: 12.0), // Padding inside the field
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 maxLines: null,
//                 controller: subtitleController,
//                 decoration: InputDecoration(
//                   labelText: 'Subtitle',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0), // Rounded corners
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                       vertical: 10.0,
//                       horizontal: 12.0), // Padding inside the field
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the dialog
//           },
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () async {
//             final title = titleController.text;
//             final subtitle = subtitleController.text;

//             await widget.onAddTemplate(title, subtitle);
//             Navigator.of(context).pop();
//           },
//           child: const Text('Add'),
//         ),
//       ],
//     );
//   }
// }

// class TemplateManager {
//   static Future<List<Map<String, String>>> getTemplates() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? templatesString = prefs.getString('templates');
//     if (templatesString != null) {
//       final List<dynamic> templatesList = jsonDecode(templatesString);
//       return List<Map<String, String>>.from(
//           templatesList.map((item) => Map<String, String>.from(item)));
//     }
//     return [];
//   }

//   static Future<void> saveTemplates(List<Map<String, String>> templates) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String templatesString = jsonEncode(templates);
//     await prefs.setString('templates', templatesString);
//   }
// }

// void _logout(BuildContext context) async {
//   // Obtain an instance of SharedPreferences
//   final prefs = await SharedPreferences.getInstance();

//   // Remove user session data, such as tokens
//   await prefs.remove('userToken'); // Adjust key according to your storage

//   // Optionally, remove any other data as needed
//   // await prefs.remove('anotherKey');

//   // Navigate to the login screen
//   Navigator.pushReplacementNamed(context, '/login');
// }
