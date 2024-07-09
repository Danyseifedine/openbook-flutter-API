import 'dart:io';

import 'package:flutter/material.dart';
import 'package:anonymy/models/books.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class BookDetail extends StatefulWidget {
  final Book book;

  const BookDetail({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  bool isArabic = false;
  bool isDownloading = false; // Flag to track download state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'book_${widget.book.id}',
                    child: CachedNetworkImage(
                      imageUrl: widget.book.cover_image ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.error, size: 50, color: Colors.red),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.book.name ?? 'Unnamed Book',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.language),
                        onPressed: () {
                          setState(() {
                            isArabic = !isArabic;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.book.author ?? 'Unknown Author',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.grey[400]),
                  SizedBox(height: 16),
                  _buildInfoChip(
                    Icons.category,
                    isArabic
                        ? widget.book.category_arabic ?? 'Unknown'
                        : widget.book.category ?? 'Unknown',
                  ),
                  SizedBox(height: 8),
                  _buildInfoChip(
                    Icons.language,
                    isArabic
                        ? widget.book.language_arabic ?? 'Unknown'
                        : widget.book.language ?? 'Unknown',
                  ),
                  SizedBox(height: 24),
                  Divider(color: Colors.grey[400]),
                  SizedBox(height: 24),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    isArabic
                        ? widget.book.description_arabic ?? 'No description available.'
                        : widget.book.description ?? 'No description available.',
                    style: TextStyle(fontSize: 14, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _downloadPDF(widget.book.pdf ?? '', widget.book.name ?? ''),
            icon: Icon(Icons.download),
            label: Text(isDownloading ? 'Downloading' : 'Download Book'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPDF(String pdfUrl, String bookName) async {
    setState(() {
      isDownloading = true; // Start download, set loading state
    });

    final url = '$pdfUrl';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getDownloadsDirectory();
      final sanitizedBookName = bookName.replaceAll(RegExp(r'[^\w\s]+'), '');
      final filePath = '${directory?.path}/$sanitizedBookName.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF downloaded successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF')),
      );
    }

    setState(() {
      isDownloading = false; // Finish download, set loading state
    });
  }

  Future<void> _readBook(String pdfUrl, String bookName) async {
    final url = '$pdfUrl';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final sanitizedBookName = bookName.replaceAll(RegExp(r'[^\w\s]+'), '');
      final filePath = '${directory.path}/$sanitizedBookName.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open PDF')),
      );
    }
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blueAccent),
          SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.blueAccent)),
        ],
      ),
    );
  }
}
