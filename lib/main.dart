import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_task/layout/home_layout.dart';
import 'package:todo_task/views/edit_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDSVftHb4a2XhgFFzR38R9HP-d4-3fE3iw',
      appId: '1:704950840436:android:bdef62ce53ff76df9fb521',
      messagingSenderId: '704950840436',
      projectId: 'todo-app-task-1',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomeLayout.routeName,
      routes: {
        HomeLayout.routeName : (context)=> HomeLayout(),
        EditView.routeName : (context)=> EditView(),
      },
    );
  }
}
