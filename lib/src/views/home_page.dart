import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> _image = [];

  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });

    createPDF();
    savePDF();
  }

  createPDF() async {
    for (var img in _image) {
      final image = pw.MemoryImage(
        img.readAsBytesSync());
      // var image = PdfImage.file(
      //   pdf.document,
      //   bytes: img.readAsBytesSync(),
      // );

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context contex) {
            return pw.Center(child: pw.Image(image));
          }));
    }
  }

  savePDF() async {
    try {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir!.path}/scantoPdf.pdf');
      await file.writeAsBytes(await pdf.save());
      // showPrintedMessage('success', 'saved to documents');
      print("::::::::::::success::::::::::::::::");
      OpenFile.open('${dir.path}/scantoPdf.pdf');
    } catch (e) {
      // showPrintedMessage('error', e.toString());
      print("::::::::::::fail::::::::::::::::");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Scan To Pdf",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            getImageFromGallery();
          },
          child: Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [
                  Colors.purple,
                  Color.fromARGB(255, 235, 125, 255),
                ])),
            alignment: Alignment.center,
            child: const Text(
              "Scan for PDF",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
