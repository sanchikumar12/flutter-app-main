import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:grocapp/widgets/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PdfView extends StatefulWidget {
  final String url, name;
  PdfView(this.name, this.url);
  @override
  _PdfViewState createState() => new _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  String pathPDF;

  Future<String> createFileOfPdfUrl() async {
    final url = widget.url;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    String dir = (await getApplicationDocumentsDirectory()).path;
    String path = '$dir/$filename';
    if (!(await File(path).exists())) {
      print("Downloading $path");
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      File file = new File(path);
      await file.writeAsBytes(bytes);
      return file.path;
    } else {
      print("File Already Exists $path");
      return path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<String>(
      create: (_) {
        return createFileOfPdfUrl();
      },
      child: Consumer<String>(
        builder: (context, pdfPath, _) {
          if (pdfPath == null)
            return Scaffold(
              body: Center(
                child:loader(),
              ),
            );
          return PDFViewerScaffold(
            path: pdfPath,
          );
        },
      ),
    );
  }
}
