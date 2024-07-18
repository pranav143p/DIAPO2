import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:login_signup/screens/signin_screen.dart';
import 'firebase_options.dart'; // Make sure to replace this with your Firebase options file


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      // Handle NFC unavailability gracefully
      print('NFC is not available');
    }
  } catch (e) {
    print('Error checking NFC availability: $e');
    // Handle NFC availability check error gracefully
  }

  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    runUrinatedDataListener();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}

class UrinatedDataListener {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static void startListening() {
    // Subscribe to Firestore collection changes
    _firestore.collection('moisture_sensor_data').snapshots().listen((snapshot) {
      // For each new document added
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          // Send a push notification
          _sendPushNotification("Patient Urinated");
        }
      });
    });
  }

  static void _sendPushNotification(String message) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("________________________________________________________________________________________________");
    print(fcmToken);

  }
}
// Run UrinatedDataListener to start listening for Firestore changes
void runUrinatedDataListener() {
  UrinatedDataListener.startListening();
}