
import 'package:flutter/material.dart';

class Allsessions extends StatefulWidget {
  const Allsessions({super.key});

  @override
  State<Allsessions> createState() => _AllsessionsState();
}

class _AllsessionsState extends State<Allsessions> {
  @override
  Widget build(BuildContext context) {
    return  Center( 
      child: Text('All Sessions',style: TextStyle(color:Theme.of(context).colorScheme.secondary ),),
    );
  }
}