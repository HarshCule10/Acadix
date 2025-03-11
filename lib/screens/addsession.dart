import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({Key? key}) : super(key: key);

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _createdBy = '';
  String _subject = '';
  String _detail = '';
  int _validity = 0;

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      await FirebaseFirestore.instance.collection('testsessions').add({
        'CreatedBy': _createdBy,
        'Subject': _subject,
        'Detail': _detail,
        'Validity': _validity,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session added successfully!')),
      );

  Navigator.pop(context,true);
      
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add session: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Session'),
      ),
      body: Column(
        children: [ 
          const SizedBox(height: 20),
          Text(
                'Acadix',
                style: TextStyle(
                  fontSize: 40, // Adjust font size
                  
                  color: Theme.of(context).colorScheme.primary // White color for text
                ),
              ),
             const SizedBox(height: 8), // Space between title and welcome message
              Text(
                "Start with your own Study Sessions Now!",
                style: TextStyle(
                  fontSize: 20, // Adjust font size for the welcome message
                  color: Theme.of(context).colorScheme.secondary// White color for text
                ),
              ),
             const SizedBox(height: 4),
          
          Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Created By',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter the creator's name.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _createdBy = value!;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a subject.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _subject = value!;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Detail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      
                      ),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter session details.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _detail = value!;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Validity (in days)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _validity = int.parse(value!);
                    },
                  ),
                  const SizedBox(height: 22),
                   SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 36, 35, 35),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 0,
                            ), 
                            child: const Text('Add Session',style: TextStyle(fontSize: 17),),
                          ),
                   ),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
       
    );
  }
}
