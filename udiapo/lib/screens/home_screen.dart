import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_signup/screens/patientdet_screen.dart';
import 'package:login_signup/screens/nfcdetailsscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTapping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "NFC TAP",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(-9, -180), // Adjust the offset to move the background image
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background_image.jpg"), // Replace "assets/background_image.jpg" with your actual image path
                  fit: BoxFit.none, // Adjust the BoxFit property to control the size of the background image
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 59, 66, 74), // Change the button color here
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20), // Adjust padding as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                    ),
                  ),
                  onPressed: () => _startTappingProcess(),
                  child: Text(
                    _isTapping ? "Tapping..." : "ENTER DETAILS", // Change the button text here
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(179, 253, 251, 251)), // Adjust text style as needed
                  ),
                ),
                SizedBox(height: 20), // Add space between buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 59, 66, 74), // Change the button color here
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20), // Adjust padding as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Adjust border radius as needed
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => NfcScreen())),
                  child: Text(
                    "NFC Entered Details", // Change the button text here
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(179, 253, 251, 251)), // Adjust text style as needed
                  ),
                ),
              ],
            ),
          ),
          if (_isTapping)
            DelayScreen(), // Display the custom delay screen when tapping
        ],
      ),
    );
  }

  void _startTappingProcess() {
    setState(() {
      _isTapping = true;
    });

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isTapping = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => PatientDetScreen()));
    });
  }
}

class DelayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Tapping...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
