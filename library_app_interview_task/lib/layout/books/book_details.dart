import 'package:flutter/material.dart';
import 'package:library_app_interview_task/models/book.dart';
import 'package:library_app_interview_task/models/enums/users_role.dart';
import 'package:library_app_interview_task/shared/local/components/do_action_with_loading.dart';
import 'package:library_app_interview_task/shared/local/user_provider.dart';
import 'package:library_app_interview_task/shared/network/firebase_provider.dart';

class BookDetails extends StatelessWidget {
  const BookDetails({Key? key, required this.book}) : super(key: key);
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AboutBook'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  image: book.coverURL != null
                      ? DecorationImage(
                          image: NetworkImage(book.coverURL!),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                '< Name >',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 10.0),
              Text(
                book.name!,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 30.0),
              Text(
                '< ISBN >',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 10.0),
              Text(
                book.isbn!,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 30.0),
              Text(
                '< Author >',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 10.0),
              Text(
                book.author!,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 30.0),
              Text(
                '< Published At >',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 10.0),
              Text(
                book.publishedIn!.toString(),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      floatingActionButton: getFloatingActionButton(context),
    );
  }

  FloatingActionButton? getFloatingActionButton(BuildContext context) {
    switch (UserProvider.instance.currentUser!.role) {
      case UserRole.admin:
        return FloatingActionButton.extended(
          label: const Text('Delete'),
          icon: const Icon(Icons.delete_forever),
          onPressed: () async {
            doActionWithLoading(context, () async {
              await FirebaseProvider.instance.deleteBook(book.isbn!, book.coverURL ?? '');
            }, successMsg: 'Book deleted successfully');
            Navigator.of(context).pop();
          },
          backgroundColor: Theme.of(context).errorColor,
        );
      case UserRole.student:
        if ((book.borrower ?? '') == UserProvider.instance.currentUser!.uid) {
          return FloatingActionButton.extended(
            label: const Text('Return'),
            icon: const Icon(Icons.keyboard_return),
            onPressed: () async {
              doActionWithLoading(context, () async {
                await FirebaseProvider.instance.addReturnRequest(
                    UserProvider.instance.currentUser!.uid!, book.isbn!);
              }, successMsg: 'Returning request sent successfully');
              Navigator.of(context).pop();
            },
            backgroundColor: Theme.of(context).primaryColor,
          );
        } else {
          return FloatingActionButton.extended(
            label: const Text('Borrow'),
            icon: const Icon(Icons.add_shopping_cart_outlined),
            onPressed: () async {
              doActionWithLoading(context, () async {
                await FirebaseProvider.instance.addBorrowRequest(
                    UserProvider.instance.currentUser!.uid!, book.isbn!);
              }, successMsg: 'Borrowing request sent successfully');
              Navigator.of(context).pop();
            },
            backgroundColor: Theme.of(context).primaryColor,
          );
        }
      default:
        return null;
    }
  }
}
