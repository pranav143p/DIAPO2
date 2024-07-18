import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NfcScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('nfc_tag_data').snapshots(),
        builder: (context, nfcSnapshot) {
          if (nfcSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (nfcSnapshot.hasError) {
            return Center(
              child: Text('Error: ${nfcSnapshot.error}'),
            );
          }
          // Merge the NFC and moisture sensor data
          final nfcDocs = nfcSnapshot.data!.docs;
          return ListView.builder(
            itemCount: nfcDocs.length,
            itemBuilder: (context, index) {
              final nfcDocument = nfcDocs[index];
              final nfcData = nfcDocument.data() as Map<String, dynamic>;
              final dataList = (nfcData['data'] as String).split(';');
              final name = dataList[0].trim();
              final gender = dataList[1].trim();
              final age = dataList[2].trim();

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('moisture_sensor_data')
                    .where('name', isEqualTo: name) // Filter by name
                    .snapshots(),
                builder: (context, moistureSnapshot) {
                  if (moistureSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (moistureSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${moistureSnapshot.error}'),
                    );
                  }
                  final moistureDocs = moistureSnapshot.data!.docs;
                  var moistureValue = 'N/A';
                  // Check if 'urine' value exists in moisture sensor data
                  if (moistureDocs.isNotEmpty) {
                    final moistureData = moistureDocs.first.data() as Map<String, dynamic>;
                    final value = moistureData['value'];
                    if (value == 'Urine detected') {
                      moistureValue = 'Urine Detected';
                    }
                  }
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: $name", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("Gender: $gender"),
                          SizedBox(height: 5),
                          Text("Age: $age"), // Removed the symbol after Age
                          SizedBox(height: 5),
                          Text("Bed Number: 46"), // New line for Bed Number
                          SizedBox(height: 5),
                          if (moistureValue == 'Urine detected') Text("Moisture Value: $moistureValue"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
