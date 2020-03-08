import 'package:daily_manager/ui/screens/newNote.dart';
import 'package:daily_manager/ui/screens/notesScreen.dart';
import 'package:daily_manager/ui/screens/tasksScreen.dart';
import 'package:daily_manager/utility/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/screens/HomeScreen.dart';
import 'ui/screens/newTask.dart';
import 'ui/screens/welcomeScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:AppTheme.lightTheme ,
      darkTheme:AppTheme.darkTheme ,
      home: WelcomeScreen(),
      routes: {
        '/homeScreen':(context) => HomeScreen(),
        '/newNoteScreen':(context) => NewNote(),
        '/newTaskScreen':(context) => NewTask(),
        '/noteScreen':(context) => NotesScreen(),
        '/taskScreen':(context) => TasksScreen(),

      },
    );
  }
}
