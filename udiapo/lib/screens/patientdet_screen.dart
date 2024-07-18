import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_signup/screens/showdetailscreen.dart';
import 'package:login_signup/utils/color_utils.dart';

class PatientDetScreen extends StatefulWidget {
  const PatientDetScreen({Key? key}) : super(key: key);

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetScreen> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  final TextEditingController _genderTextController = TextEditingController();
  final TextEditingController _bednoTextController = TextEditingController();

  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Patient Details",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                // Username TextField
                TextField(
                  controller: _userNameTextController,
                  decoration: InputDecoration(
                    labelText: "Patient Name",
                    prefixIcon: Icon(Icons.person_outline),
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Age TextField
                TextField(
                  controller: _ageTextController,
                  decoration: InputDecoration(
                    labelText: "Age",
                    prefixIcon: Icon(Icons.person_outline),
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Gender TextField
                TextField(
                  controller: _genderTextController,
                  decoration: InputDecoration(
                    labelText: "Gender",
                    prefixIcon: Icon(Icons.person_outlined),
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Bed Number TextField
                TextField(
                  controller: _bednoTextController,
                  decoration: InputDecoration(
                    labelText: "Bed Number",
                    prefixIcon: Icon(Icons.person_outlined),
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 50),
                // Submit Button Container
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Check if any of the fields are empty
                          if (_userNameTextController.text.isEmpty ||
                              _ageTextController.text.isEmpty ||
                              _genderTextController.text.isEmpty ||
                              _bednoTextController.text.isEmpty) {
                            // Show a dialog indicating fields are empty
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Error"),
                                content: Text("Please fill all the fields"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                            return; // Do not proceed if any field is empty
                          }

                          try {
                            // Check if the document with the same bed number already exists
                            final bedNumber = _bednoTextController.text;
                            final existingDoc = await FirebaseFirestore.instance
                                .collection('patdet')
                                .where('bednumber', isEqualTo: bedNumber)
                                .get();

                            if (existingDoc.docs.isNotEmpty) {
                              // If document with same bed number exists, show error message
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("A patient with the same bed number already exists"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              return; // Do not proceed further
                            }

                            // Add data to Firestore
                            Map<String, dynamic> datatosave = {
                              'username': _userNameTextController.text,
                              'age': _ageTextController.text,
                              'gender': _genderTextController.text,
                              'bednumber': _bednoTextController.text,
                            };
                            await FirebaseFirestore.instance.collection('patdet').add(datatosave);
                            print('Data added successfully');
                            
                            // Update the message
                            setState(() {
                              _message = 'Data saved successfully';
                            });
                          } catch (e) {
                            print('Error adding data: $e');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 67, 75, 80), // Change the button color here
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Adjust padding as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Adjust border radius as needed
                          ),
                        ),
                        child: Text(
                          'SUBMIT', // Change the button text here
                          style: TextStyle(fontSize: 18, color: Color.fromARGB(179, 252, 251, 251)), // Adjust text style as needed
                        ),
                      ),
                      SizedBox(height: 20), // Add space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the NameScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowDetailsScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 67, 75, 80), // Change the button color here
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Adjust padding as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Adjust border radius as needed
                          ),
                        ),
                        child: Text(
                          'Full Patient Details', // Change the button text here
                          style: TextStyle(fontSize: 18, color: Color.fromARGB(179, 252, 251, 251)), // Adjust text style as needed
                        ),
                      ),
                      if (_message.isNotEmpty)
                        SizedBox(height: 20), // Add space if message is shown
                      if (_message.isNotEmpty)
                        Text(
                          _message,
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
