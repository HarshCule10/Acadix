import 'package:acadix/screens/addsession.dart';
import 'package:acadix/screens/interestedsessions.dart';
import 'package:acadix/screens/userdetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:acadix/widgets/sessioncard.dart';
class Allsessions extends StatefulWidget {
  const Allsessions({super.key});
  @override
  State<Allsessions> createState() => _AllsessionsState();
}
class _AllsessionsState extends State<Allsessions> {
 

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to InterestedScreen when the second tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Interestedsessions()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchSessions();
  }
Future<void> _navigateToFormScreen() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>AddSessionScreen()),
  );

  if (result != null && result) {
    // Data has been added, refresh the data
    fetchSessions();  // Call a method to refresh the data (e.g., from Firestore)
    setState(() {
      
    });
  }
}


  List<Map<String, dynamic>> sessions = [];
  void fetchSessions() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('testsessions').get();

    sessions.clear(); // Clear the list before adding new data

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      sessions.add({
        'CreatedBy': data['CreatedBy'] ?? '',
        'Detail': data['Detail'] ?? '',
        'Subject': data['Subject'] ?? '',
        'Validity': data['Validity'] ?? 0, // Default to 0 if null
        'id': doc.id, // Include the document ID
      });
    }

    setState(() {}); // Trigger UI update
  } catch (error) {
    print('Error fetching sessions: $error');
  }
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('All Sessions'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserDetailsPage()),
            );
          },
          icon: Icon(Icons.account_box,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    ),
    body: ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (ctx, index) {
        return SessionCard(
          createdBy: sessions[index]['CreatedBy'],
          detail: sessions[index]['Detail'],
          subject: sessions[index]['Subject'],
          validity: sessions[index]['Validity'],
          sessionid: sessions[index]['id'],
        );
      },
    ),
    bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'All Sessions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.interests_outlined),
          label: 'Interested Sessions',
        ),
      ],
      currentIndex: _selectedIndex,
      unselectedItemColor: Theme.of(context).colorScheme.secondary,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      onTap: _onItemTapped,
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddSessionScreen()),
            );
          },
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.add),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}
}
