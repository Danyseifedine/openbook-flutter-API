import 'package:anonymy/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:anonymy/models/api_response.dart';
import 'package:anonymy/models/books.dart';
import 'package:anonymy/screens/book_detail.dart';
import 'package:anonymy/screens/login.dart';
import 'package:anonymy/services/book_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Book> _bookList = [];
  List<Book> _booksUnder100Pages = [];
  List<Book> _bookRate5 = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    ApiResponse response = await getBooks();
    if (response.error == null) {
      BookResponse bookResponse = response.data as BookResponse;
      setState(() {
        _bookList = bookResponse.books;
        _booksUnder100Pages = bookResponse.booksUnder100Pages ?? [];
        _bookRate5 = bookResponse.bookRate5 ?? [];
        _loading = false;
      });
    } else {
      print('Error: ${response.error}');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF3F51B5),
        title: Text('OpenBook', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
              );
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF3F51B5)))
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('All Books'),
            SizedBox(height: 7),
            _buildBookList(_bookList),
            SizedBox(height: 30),
            _buildSectionTitle('Books Under 100 Pages'),
            SizedBox(height: 7),
            _buildBookList(_booksUnder100Pages),
            SizedBox(height: 30),
            _buildSectionTitle('Highest Rated Books'),
            SizedBox(height: 7),
            _buildBookList(_bookRate5),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
        onTap: (index) {

          if (index == 1) { // Index 1 corresponds to the Search button
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          }else{
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Home()));
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3F51B5),
        ),
      ),
    );
  }

  Widget _buildBookList(List<Book> books) {
    return Container(
      height: 360,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          Book book = books[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => BookDetail(book: book),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = 0.0;
                      var end = 1.0;
                      var curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return ScaleTransition(scale: animation.drive(tween), child: child);
                    },
                  ),
                );
              },
              child: Hero(
                tag: 'book_${book.id}',
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: book.cover_image ?? '',
                          height: 250,
                          width: 180,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 250,
                            width: 180,
                            color: Colors.grey[300],
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 250,
                            width: 180,
                            color: Colors.grey[300],
                            child: Icon(Icons.error, size: 50),
                          ),
                        ),
                        Container(
                          width: 180,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.name ?? 'Unnamed Book',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                book.author ?? 'Unknown Author',
                                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}