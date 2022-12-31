import 'package:flutter/material.dart';
import 'package:library_app_interview_task/models/book.dart';
import 'package:library_app_interview_task/shared/local/components/custom_text_field.dart';
import 'package:library_app_interview_task/shared/local/components/do_action_with_loading.dart';
import 'package:library_app_interview_task/shared/network/firebase_provider.dart';

class AddBookScreen extends StatelessWidget {
  AddBookScreen({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController pubAtController = TextEditingController();
  final TextEditingController numPagesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          // constraints: const BoxConstraints(
          //   // minWidth: 200.0,
          //     maxWidth: 600.0,
          //     // minHeight: 400,
          //     maxHeight: 800),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
          ),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(
                  //   width: 300.0,
                  //   height: 300.0,
                  //   decoration: BoxDecoration(
                  //     image:
                  //   ),
                  // )
                  const SizedBox(height: 20.0),
                  buildTextField(
                    controller: nameController,
                    hintText: 'Book Name',
                  ),
                  const SizedBox(height: 20.0),
                  buildTextField(
                    controller: isbnController,
                    hintText: 'Book ISBN',
                  ),
                  const SizedBox(height: 20.0),
                  buildTextField(
                    controller: authorController,
                    hintText: 'Author Name',
                  ),
                  const SizedBox(height: 20.0),
                  buildTextField(
                    controller: pubAtController,
                    hintText: 'Published At',
                  ),
                  const SizedBox(height: 20.0),
                  buildTextField(
                    controller: numPagesController,
                    hintText: 'Number of Pages',
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      doActionWithLoading(context, () async {
                        if (nameController.text.isEmpty) {
                          throw 'Please enter the book name';
                        }
                        if (isbnController.text.isEmpty) {
                          throw 'Please enter the isbn';
                        }
                        if (isbnController.text.isEmpty) {
                          throw 'Please enter the author name';
                        }
                        if (pubAtController.text.isEmpty) {
                          throw 'Please enter the location of publication';
                        }
                        if (numPagesController.text.isEmpty) {
                          throw 'Please enter pages count';
                        }
                        if (int.tryParse(numPagesController.text) == null) {
                          throw 'Please enter a valid pages count';
                        }
                        await FirebaseProvider.instance.addBook(Book(
                          name: nameController.text.trim(),
                          isbn: isbnController.text.trim(),
                          author: authorController.text.trim(),
                          publishedIn: pubAtController.text.trim(),
                          numPages: int.tryParse(numPagesController.text.trim()) ?? 0,
                          borrower: '',
                        ));
                        Navigator.of(context).pop();
                      }, successMsg: 'Book is added successfully');
                    },
                    child: const Text('Add Book'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
