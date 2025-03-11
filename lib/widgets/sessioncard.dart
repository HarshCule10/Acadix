import 'package:acadix/screens/sessiondetails.dart';
import 'package:flutter/material.dart';

class SessionCard extends StatelessWidget {
 const SessionCard({super.key,required this.createdBy, required this.detail,required this.subject,required this.validity,
 
 required this.sessionid
 });
 final String createdBy;
  final String detail;
 final String subject;
 final int validity;
 final String sessionid;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SessionDetailsScreen(
      sessionId: sessionid,
    )),
);
      },
      child: Card(
        color: Colors.grey[900], // Darker grey for the card background
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0), // Rounded corners
        ),
        elevation: 4, // Subtle shadow for depth
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
      padding: const EdgeInsets.all(16.0), // Padding inside the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subject,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Validity: $validity days',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0), // Spacing between rows
          Text(
            detail,
            style: const TextStyle(
              color: Colors.white70, // Slightly lighter text
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 16.0), // Spacing before footer
          Text(
            'Created by: $createdBy',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
        ),
      ),
    );

  }
}