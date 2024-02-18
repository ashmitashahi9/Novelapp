// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//
// class EpubViewer extends StatefulWidget {
//   final String url;
//   final String title;
//
//   const EpubViewer({required this.url, required this.title});
//
//   @override
//   _EpubViewerState createState() => _EpubViewerState();
// }
//
// class _EpubViewerState extends State<EpubViewer> {
//   bool _isLoading = true;
//   File? _file;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEpub();
//   }
//
//   Future<void> _loadEpub() async {
//     try {
//       final cacheManager = DefaultCacheManager();
//       final file = await cacheManager.getSingleFile(widget.url);
//       final directory = await getTemporaryDirectory();
//       final filePath = '${directory.path}/${widget.title}.epub';
//       await file.copy(filePath);
//       setState(() {
//         _isLoading = false;
//         _file = File(filePath);
//       });
//     } catch (e) {
//       print(e.toString());
//       setState(() {
//         _isLoading = false;
//       });
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Failed to load epub file.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             )
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _file == null
//           ? Center(child: Text('Failed to load epub file.'))
//           : SfPdfViewer.file(
//         _file!,
//         enableDoubleTapZooming: true,
//       ),
//     );
//   }
// }
