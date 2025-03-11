import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionDetailsScreen extends StatefulWidget {
  final String sessionId; // Pass this from the previous screen

  SessionDetailsScreen({required this.sessionId});

  @override
  _SessionDetailsScreenState createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  final TextEditingController _replyController = TextEditingController();
  String? currentQuestionId; // To store the question ID when a reply is being written

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Session Details")),
      body: Column(
        children: [
          // Questions and Replies Section
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Questions & Replies",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('testsessions')
                          .doc(widget.sessionId)
                          .collection('questions')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("No questions yet."));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var question = snapshot.data!.docs[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      question['text'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: question.reference
                                          .collection('replies')
                                          .snapshots(),
                                      builder: (context, replySnapshot) {
                                        if (!replySnapshot.hasData ||
                                            replySnapshot.data!.docs.isEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text("No replies yet.", style: TextStyle(color: Colors.grey)),
                                          );
                                        }
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: replySnapshot.data!.docs.map((reply) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 4),
                                              child: Text(reply['text']),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 8),
                                    IconButton(
                                      icon: Icon(Icons.reply, color: Theme.of(context).primaryColor),
                                      onPressed: () {
                                        // Open reply text field for this specific question
                                        setState(() {
                                          currentQuestionId = question.id;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          // Resources Section
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Resources",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('testsessions')
                          .doc(widget.sessionId)
                          .collection('resources')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("No resources uploaded."));
                        }
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var resource = snapshot.data!.docs[index];
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_present, size: 40),
                                  SizedBox(height: 8.0),
                                  Text(resource['name']),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Open resource in browser or download it
                                    },
                                    child: Text("View"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Display text field for writing a reply
      bottomSheet: currentQuestionId != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: 'Type your reply...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                    onPressed: () async {
                      if (_replyController.text.isNotEmpty && currentQuestionId != null) {
                        // Submit the reply to Firestore
                        await FirebaseFirestore.instance
                            .collection('testsessions')
                            .doc(widget.sessionId)
                            .collection('questions')
                            .doc(currentQuestionId)
                            .collection('replies')
                            .add({
                          'text': _replyController.text,
                          'createdAt': Timestamp.now(),
                        });

                        // Clear the text field after sending the reply
                        _replyController.clear();

                        // Reset the current question ID to hide the text field
                        setState(() {
                          currentQuestionId = null;
                        });
                      }
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
