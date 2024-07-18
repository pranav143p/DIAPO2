import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('patdet').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final documents = snapshot.data!.docs;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Age',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Gender',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Bed Number',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 14),
                  ),
                ),
              ],
              rows: documents.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return DataRow(cells: [
                  DataCell(Text('${data['username']}')),
                  DataCell(Text('${data['age']}')),
                  DataCell(Text('${data['gender']}')),
                  DataCell(Text('${data['bednumber']}')),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
