import 'package:acadix/screens/userdetails.dart';
import 'package:flutter/material.dart';

class Interestedsessions extends StatefulWidget {
  const Interestedsessions({super.key});

  @override
  State<Interestedsessions> createState() => _InterestedsessionsState();
}

class _InterestedsessionsState extends State<Interestedsessions> {
  @override
  Widget build(BuildContext context) {
    return  AppBar(
      title: const Text('Interested Sessions'),
      actions: [
          IconButton(
            icon:  Icon(Icons.account_box,color: Theme.of(context).colorScheme.primary,),
            onPressed: () {
             Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => UserDetailsPage()),
);} ),
      ],
    );
  }
}