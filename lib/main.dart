import 'package:acadix/screens/allsessions.dart';
import 'package:acadix/screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acadix',
      theme: ThemeData().copyWith(
        textTheme: GoogleFonts.openSansTextTheme( // Change to Open Sans
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white, // Set body text color
            displayColor: Colors.white, // Set heading text color
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFF848482),
          surface: Colors.black,   
        ),
        scaffoldBackgroundColor: Colors.black, 
        dialogBackgroundColor: Colors.black,  
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black), 
        cardColor: Colors.black,
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasData){
          return Allsessions();
        }
        return AuthScreen();      
      }),
    );
  }
}
