import 'package:flutter/material.dart';
import 'upload_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://pzcgqvnuhijbvwcorlmk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6Y2dxdm51aGlqYnZ3Y29ybG1rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwOTg3NTQsImV4cCI6MjA3MDY3NDc1NH0.QdK9FEuV4TuLfflxRyePM733VrtPg_pRijbqxpEqVVY',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Uploader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UploadScreen(),
    );
  }
}

