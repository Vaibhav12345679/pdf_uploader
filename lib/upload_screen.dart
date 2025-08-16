import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final supabase = Supabase.instance.client;
  bool uploading = false;
  String status = '';

  Future<void> pickAndUploadPDF() async {
    setState(() {
      uploading = true;
      status = 'Picking file...';
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      setState(() {
        uploading = false;
        status = 'No file selected';
      });
      return;
    }

    final fileName = result.files.first.name;
    final fileBytes = result.files.first.bytes;

    if (fileBytes == null) {
      setState(() {
        uploading = false;
        status = 'Cannot read file';
      });
      return;
    }

    setState(() {
      status = 'Uploading $fileName...';
    });

    try {
      await supabase.storage.from('pdf-notes').uploadBinary(fileName, fileBytes);

      final fileUrl = supabase.storage.from('pdf-notes').getPublicUrl(fileName);

      await supabase.from('notes').insert({
        'name': fileName,
        'url': fileUrl,
      });

      setState(() {
        uploading = false;
        status = 'Uploaded successfully!\n$fileUrl';
      });
    } catch (e) {
      setState(() {
        uploading = false;
        status = 'Upload failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Uploader')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: uploading ? null : pickAndUploadPDF,
                    child: Text(uploading ? 'Uploading...' : 'Select and Upload PDF'),
                  ),
                  SizedBox(height: 20),
                  Text(status, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[200],
            width: double.infinity,
            child: Text(
              'Made by Tech of the World',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
