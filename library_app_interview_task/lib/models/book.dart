class Book {
  String? name;
  String? isbn;
  String? author;
  String? publishedIn;
  String? coverURL;
  String? borrower;
  int? numPages;

  Book({this.name, this.isbn, this.author, this.publishedIn, this.borrower, this.numPages});

  Book.fromDoc(String this.isbn, Map data) {
    name = data['name'];
    author = data['author'];
    coverURL = data['coverURL'];
    publishedIn = data['publishedIn'];
    borrower = data['borrower'];
    numPages = data['numPages'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isbn': isbn,
      'author': author,
      'coverURL': coverURL,
      'publishedIn': publishedIn,
      'borrower': borrower,
      'numPages': numPages,
    };
  }
}