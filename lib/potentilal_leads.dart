import 'dart:convert';

import 'package:crm_app/Utils/Constants/Helpers/helper_functions.dart';
import 'package:crm_app/Utils/Sizes.dart';
import 'package:crm_app/Widgets/card_container.dart';
import 'package:crm_app/Widgets/registration_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PotentialLeads extends StatefulWidget {
  const PotentialLeads({
    super.key,
  });

  @override
  State<PotentialLeads> createState() => _PotentialLeadsState();
}

class _PotentialLeadsState extends State<PotentialLeads> {
  List<dynamic> startingLeads = [];
  List<dynamic> notContactedLeads = [];
  List<dynamic> monthlyLeads = [];
  List<dynamic> dailyLeads = [];
  int variable = 1;

  @override
  void initState() {
    super.initState();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    try {
      final response =
          await http.get(Uri.parse("https://ridobiko.in/crm/mobile_app_apis/potentialleads.php"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          startingLeads = jsonResponse['starting_data'] ?? [];
          notContactedLeads = jsonResponse['not_contacted_data'] ?? [];
          monthlyLeads = jsonResponse['monthly_data'] ?? [];
          dailyLeads = jsonResponse['daily_data'] ?? [];
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

  Widget buildCard(String title, String numbers, Color c1, Color c2) {
    return CardContainer(
      c1: c1,
      c2: c2,
      days: title,
      numbers: numbers,
    );
  }

  Widget buildLeadList(List<dynamic> leads) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];
        return RegistrationContainer(
          containerHeight: 200,
          name: lead['name'] ?? 'Name not available',
          phone: lead['mobile_no'] ?? 'Phone not available',
          city: lead['enquiry_city'] ?? 'City not available',
          vehicle: lead['enquiry_for'] ?? 'Vehicle not available',
          date: lead['start_date'] ?? 'Date not available',
          id: lead['created_by'] ?? 'ID not available',
          duration: lead['duration'] ?? 'Duration not available',
          comment: lead['comment'] ?? 'Comment not available',
          status: lead['lead_status'] ?? 'Status not available',
          enquiry_id: lead['enquiry_id'] ?? 'Enquiry ID not available',
          email: lead['email'] ?? 'Email not available',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool dark = HelperFunctions.isDarkMode(context);
    List<dynamic> currentLeads;
    if (variable == 1) {
      currentLeads = startingLeads;
    } else if (variable == 2) {
      currentLeads = notContactedLeads;
    } else {
      currentLeads = monthlyLeads;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        title: const Text('Potential Leads'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:0.0,left:20, right:20),
        child: Column(
          children: [
            
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        variable = 1;
                      });
                    },
                    child: potentail_card(
                      title: "Starting 3 Days",
                      number: startingLeads.length.toString(),
                      c1: const Color.fromARGB(255, 222, 174, 150),
                      c2: const Color.fromARGB(255, 222, 68, 155),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Add spacing between cards

                // Second Card
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        variable = 2;
                      });
                    },
                    child: potentail_card(
                      title: "Not Contacted in 3 Days",
                      number: notContactedLeads.length.toString(),
                      c1: const Color.fromARGB(255, 123, 162, 220),
                      c2: const Color.fromARGB(255, 15, 135, 205)
                          .withOpacity(0.9),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Add spacing between cards

                // Third Card
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        variable = 3;
                      });
                    },
                    child: potentail_card(
                      title: "Monthly Leads in 30 Days",
                      number: monthlyLeads.length.toString(),
                      c1: const Color.fromARGB(249, 226, 237, 95)
                          .withOpacity(0.9),
                      c2: const Color.fromARGB(255, 216, 239, 47),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            Expanded(
              child: buildLeadList(currentLeads),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable, camel_case_types
class potentail_card extends StatelessWidget {
  String title;
  String number;
  Color c1;
  Color c2;

  potentail_card({
    super.key,
    required this.title,
    required this.number,
    required this.c1,
    required this.c2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            c1, c2
            // End color
          ],
          begin: Alignment.topLeft, // Gradient start point
          end: Alignment.bottomRight, // Gradient end point
        ),
        borderRadius: BorderRadius.circular(8.0), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center content horizontally
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white), // Text color for better contrast
            ),
            Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                  color: Colors.white), // Text color for better contrast
            ),
          ],
        ),
      ),
    );
  }
}
