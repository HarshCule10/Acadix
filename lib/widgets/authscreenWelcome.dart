import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20,bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
                'Acadix',
                style: TextStyle(
                  fontSize: 40, // Adjust font size
                  
                  color: Theme.of(context).colorScheme.primary // White color for text
                ),
              ),
             const SizedBox(height: 8), // Space between title and welcome message
              Text(
                "Welcome back",
                style: TextStyle(
                  fontSize: 20, // Adjust font size for the welcome message
                  color: Theme.of(context).colorScheme.secondary// White color for text
                ),
              ),
             const SizedBox(height: 4), // Space between messages
              Text(
                "Let's get you in to Acadix",
                style: TextStyle(
                  fontSize: 16, // Adjust font size
                  color: Theme.of(context).colorScheme.secondary, // White color for text
                ),
                textAlign: TextAlign.center,
              ),
      ],),
    );
  }
}