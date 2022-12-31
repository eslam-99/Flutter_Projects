import 'package:flutter/material.dart';
import 'package:library_app_interview_task/layout/books/add_book.dart';
import 'package:library_app_interview_task/layout/books/book_details.dart';
import 'package:library_app_interview_task/models/book.dart';
import 'package:library_app_interview_task/models/enums/users_role.dart';
import 'package:library_app_interview_task/shared/local/user_provider.dart';
import 'package:library_app_interview_task/shared/network/firebase_provider.dart';

class BooksScreen extends StatefulWidget {
  BooksScreen({Key? key}) : super(key: key);
  bool isLoaded = false;

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  Widget build(BuildContext context) {
    int maxGridItems = (MediaQuery.of(context).size.width / 300).round();
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Books'),
      ),
      body: FutureBuilder<List<Book>>(
        future: FirebaseProvider.instance.getAllBooks().then((value) {
          if (!widget.isLoaded) {
            setState(() {
              widget.isLoaded = true;
            });
          }
          return value;
        }),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: maxGridItems),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Book book = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  width: 300.0,
                  // height: 500.0,
                  // constraints: const BoxConstraints(
                  //   minWidth: 300.0,
                  //   maxWidth: 300.0,
                  //   minHeight: 500.0,
                  //   maxHeight: 500.0,
                  // ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                      width: 2.0,
                      color:
                      (book.borrower ?? '') == UserProvider.instance.currentUser!.uid ? Colors.green :
                          (UserProvider.instance.currentUser!.role == UserRole.admin) && ((book.borrower ?? '') != '') ? Colors.green :
                            Theme.of(context).primaryColor,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 300.0,
                          height: 200.0,
                          // constraints: const BoxConstraints(
                          //   minWidth: 300.0,
                          //   maxWidth: 300.0,
                          //   minHeight: 450.0,
                          //   maxHeight: 450.0,
                          // ),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(25.0)),
                            image: book.coverURL != null
                                ? DecorationImage(
                                    image: NetworkImage(book.coverURL ?? ''),
                                    fit: BoxFit.fitWidth,
                                  )
                                : null,
                          ),
                          child: const Center(
                              child:
                                  Icon(Icons.menu_book_outlined, size: 140.0)),
                        ),
                        Container(
                          width: 300.0,
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(25.0)),
                          ),
                          child: Text(book.name ?? 'No Name',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              )),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BookDetails(book: book)))
                          .then((value) {
                        setState(() {});
                      });
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: widget.isLoaded &&
              UserProvider.instance.currentUser!.role == UserRole.admin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (BuildContext context) => AddBookScreen()))
                    .then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Book',
              ),
            )
          : null,
    );
  }
}
