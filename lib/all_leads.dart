import 'dart:convert';

import 'package:crm_app/Login.dart';
import 'package:crm_app/Utils/Constants/Colors.dart';
import 'package:crm_app/Utils/Constants/Helpers/helper_functions.dart';
import 'package:crm_app/Utils/Sizes.dart';
import 'package:crm_app/Widgets/card_container.dart';
import 'package:crm_app/Widgets/drawerwidget.dart';
import 'package:crm_app/Widgets/global%20_state.dart';
import 'package:crm_app/Widgets/registration_container.dart';
import 'package:crm_app/app.dart';
import 'package:crm_app/leads_form.dart';
import 'package:crm_app/potentilal_leads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllLeads extends StatefulWidget {
  const AllLeads({super.key});

  @override
  State<AllLeads> createState() => _AllLeadsState();
}

class _AllLeadsState extends State<AllLeads> {
  List<dynamic> leads = [];
  List<dynamic> filteredLeads = [];
  List<dynamic> statusFilteredLeads = [];
  String selectedStatus = "Created";
  int convertedCount = 0;
  int notConvertedCount = 0;
  int closedCount = 0;
  int created = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLeads();
    _searchController.addListener(() {
      _filterLeads(_searchController.text);
    });
  }

  Future<void> _fetchLeads() async {
    try {
      final response = await http.get(
          Uri.parse("https://ridobiko.in/crm/mobile_app_apis/getlead.php"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> fetchedLeads = jsonResponse['leads'];

        setState(() {
          leads = fetchedLeads;
          filteredLeads = leads;
          _updateCounts();
          _storeLeadsByStatus();
          _filterLeadsByStatus();
        });
      } else {
        if (kDebugMode) {
          print("Failed to fetch leads: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching leads: $e");
      }
    }
  }

  void _updateCounts() {
    setState(() {
      convertedCount =
          leads.where((lead) => lead["lead_status"] == "Contacted").length;
      notConvertedCount =
          leads.where((lead) => lead["lead_status"] == "Not Converted").length;
      closedCount =
          leads.where((lead) => lead["lead_status"] == "Closed").length;
      created = leads.where((lead) => lead["lead_status"] == "Created").length;
    });
  }

  Future<void> _storeLeadsByStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, List<dynamic>> categorizedLeads = {
      "Created":
          leads.where((lead) => lead["lead_status"] == "Created").toList(),
      "Contacted":
          leads.where((lead) => lead["lead_status"] == "Contacted").toList(),
      "Closed": leads.where((lead) => lead["lead_status"] == "Closed").toList(),
      "Not Converted": leads
          .where((lead) => lead["lead_status"] == "Not Converted")
          .toList(),
    };

    categorizedLeads.forEach((status, leadsList) async {
      final String leadsString = jsonEncode(leadsList);
      await prefs.setString('leads_$status', leadsString);
    });
  }

  Future<List<dynamic>> _getLeadsByStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final String? leadsString = prefs.getString('leads_$status');
    if (leadsString != null) {
      return jsonDecode(leadsString);
    }
    return [];
  }

  Future<void> _filterLeadsByStatus() async {
    final leadsByStatus = await _getLeadsByStatus(selectedStatus);

    setState(() {
      statusFilteredLeads = leadsByStatus;
      // Reapply search filter on newly filtered leads
      _filterLeads(_searchController.text);
    });
  }

  void _filterLeads(String query) {
    setState(() {
      filteredLeads = leads.where((lead) {
        final name = lead["name"].toLowerCase();
        final mobileNo = lead["mobile_no"].toLowerCase();
        final city = lead["enquiry_city"].toLowerCase();
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) ||
            mobileNo.contains(searchQuery) ||
            city.contains(searchQuery);
      }).toList();

      // Update statusFilteredLeads based on filteredLeads
      statusFilteredLeads = filteredLeads
          .where((lead) => lead["lead_status"] == selectedStatus)
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool dark = HelperFunctions.isDarkMode(context);
    final size = MediaQuery.of(context).size;
    final double containerWidth = size.width * 0.4;
  final globalState = Provider.of<GlobalState>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: dark ? Colors.white : Colors.black,
        ),
        title: const Text("All Leads"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              margin:
                  EdgeInsets.only(top: HelperFunctions.screenHeight() * 0.06),
              decoration: const BoxDecoration(
                color: ColorsApp.greycon,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                              "assets/images/facebook-female-profile-icon-16.png"),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          globalState.username,
                          style: const TextStyle(color: Colors.white),
                        ),
                    
                      ],
                    ),
   
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: HelperFunctions.screenHeight() * 0.05,
                  left: HelperFunctions.screenWidth() * .01),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
      
                  const DrawerWidget(
                    heading: "All Leads",
                    subheading: "Overall Leads",
                    widget: AllLeads(),
                  ),
                  const DrawerWidget(
                      heading: "Today's Potential Leads",
                      subheading: "Overall Potential Leads",
                      widget: PotentialLeads()),
       
                  const DrawerWidget(
                      heading: "Add new Template",
                      subheading: "",
                      widget: AddTemplatesDialog()),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: ListTile(
                        title: const Text(
                          'Logout',
                          style: TextStyle(fontSize: Sizes.iconSm),
                        ),
                        onTap: () {
                          _logout(context);
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedStatus = "Created";
                    _filterLeadsByStatus();
                  });
                },
                child: CardContainer(
                  c1: const Color.fromARGB(255, 222, 174, 150),
                  c2: const Color.fromARGB(255, 222, 68, 155),
                  days: "Created",
                  numbers: created.toString(),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedStatus = "Contacted";
                    _filterLeadsByStatus();
                  });
                },
                child: CardContainer(
                  c1: const Color.fromARGB(255, 123, 162, 220),
                  c2: const Color.fromARGB(255, 15, 135, 205).withOpacity(0.9),
                  days: "Contacted",
                  numbers: convertedCount.toString(),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedStatus = "Closed";
                    _filterLeadsByStatus();
                  });
                },
                child: CardContainer(
                  c1: const Color.fromARGB(250, 14, 240, 179).withOpacity(0.9),
                  c2: const Color.fromARGB(255, 7, 188, 139),
                  days: "Closed",
                  numbers: closedCount.toString(),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedStatus = "Not Converted";
                    _filterLeadsByStatus();
                  });
                },
                child: CardContainer(
                  c1: const Color.fromARGB(255, 40, 39, 39).withOpacity(0.8),
                  c2: const Color.fromARGB(66, 51, 47, 47),
                  days: "Not Converted",
                  numbers: notConvertedCount.toString(),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              Container(
                width: double.infinity,
                color: dark
                    ? const Color.fromARGB(255, 48, 44, 44)
                    : ColorsApp.white2,
                height: 160,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Search (Name/Mobile/City)",
                      style: TextStyle(fontSize: Sizes.smmd),
                    ),
                    Container(
                      color: dark
                          ? ColorsApp.darkgrey
                          : const Color.fromARGB(255, 190, 190, 190),
                      height: 40,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.search,
                                size: Sizes.iconXs,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.center,
                              color: ColorsApp.white,
                              child: TextFormField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 10),
                                  border: InputBorder.none,
                                  hintText: "Search Name/Mobile/City",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Sizes.smmd,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.center,
                              color: ColorsApp.darkgrey,
                              child: const Text(
                                "Search",
                                style: TextStyle(color: ColorsApp.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeadForm()),
                        ).then((_) {
                          // Refresh the screen after returning from LeadForm
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllLeads()),
                          );
                        });
                      },
                      child: Container(
                        height: 40,
                        width: containerWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: ColorsApp.darkgrey,
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Add Lead",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              statusFilteredLeads.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: statusFilteredLeads.length,
                      itemBuilder: (context, index) {
                        return LeadCard(lead: statusFilteredLeads[statusFilteredLeads.length - index - 1]);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  final dynamic lead;

  const LeadCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return RegistrationContainer(
      containerHeight: 250,
      name: '${lead["name"]}',
      phone: '${lead["mobile_no"]}',
      city: '${lead["enquiry_city"]}',
      vehicle: '${lead["enquiry_for"]}',
      date: " ${lead["enquiry_date"]}",
      id: "${lead["employee_code"]}",
      duration: " ${lead["duration"]}",
      comment: "${lead["comment"]}",
      status: "${lead["lead_status"]}",
      enquiry_id: '${lead["enquiry_id"]}',
      email: '${lead["email"]}',
    );
  }
}

class AddTemplatesDialog extends StatefulWidget {
  const AddTemplatesDialog({super.key});

  @override
  _AddTemplatesDialogState createState() => _AddTemplatesDialogState();
}

class _AddTemplatesDialogState extends State<AddTemplatesDialog> {
  List<Map<String, String>> templates = [];

  @override
  void initState() {
    super.initState();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    templates = await TemplateManager.getTemplates();
    setState(() {});
  }

  Future<void> saveTemplates() async {
    await TemplateManager.saveTemplates(templates);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Templates'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final template = templates[index];
                  return ListTile(
                    title: Text(template['title'] ?? ''),
                    subtitle: Text(
                      template['subtitle'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            setState(() {
                              templates.removeAt(index);
                            });
                            await saveTemplates();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Template deleted')),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _AddNewTemplateDialog(
                    onAddTemplate: (title, subtitle) async {
                      if (title.isNotEmpty && subtitle.isNotEmpty) {
                        setState(() {
                          templates.add({
                            'title': title,
                            'subtitle': subtitle,
                          });
                        });
                        await saveTemplates();
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Template added successfully')),
                        );
                      }
                    },
                  ),
                );
              },
              child: const Text('Add Template'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _AddNewTemplateDialog extends StatefulWidget {
  final Future<void> Function(String title, String subtitle) onAddTemplate;

  const _AddNewTemplateDialog({required this.onAddTemplate, super.key});

  @override
  _AddNewTemplateDialogState createState() => _AddNewTemplateDialogState();
}

class _AddNewTemplateDialogState extends State<_AddNewTemplateDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Template'),
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(
          maxHeight: 500, // Set the maximum height of the dialog
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0), // Padding inside the field
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: null,
                controller: subtitleController,
                decoration: InputDecoration(
                  labelText: 'Subtitle',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0), // Padding inside the field
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final title = titleController.text;
            final subtitle = subtitleController.text;

            await widget.onAddTemplate(title, subtitle);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class TemplateManager {
  static Future<List<Map<String, String>>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final String? templatesString = prefs.getString('templates');
    if (templatesString != null) {
      final List<dynamic> templatesList = jsonDecode(templatesString);
      return List<Map<String, String>>.from(
          templatesList.map((item) => Map<String, String>.from(item)));
    }
    return [];
  }

  static Future<void> saveTemplates(List<Map<String, String>> templates) async {
    final prefs = await SharedPreferences.getInstance();
    final String templatesString = jsonEncode(templates);
    await prefs.setString('templates', templatesString);
  }
}

void _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(MyApp.KEYLOGIN, false);
  Navigator.pushReplacement(
    // ignore: use_build_context_synchronously
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}
