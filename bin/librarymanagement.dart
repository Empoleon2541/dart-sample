import 'dart:io';

// List of allowable genres to be included in the library
final List genreList = ["Computer Science", "Philosophy", "Pure Science", "Art and Recreation", "History"];
// Define a class for Book
class Borrower {
  final String name; 
  final String borrowerID;
  Borrower(this.name, this.borrowerID);
  
}
class borrowersList{
  final List<Borrower> borrowers=[];
  void addBorrower(Borrower borrower){
    borrowers.add(borrower);
  }
}
class Book {
  final String title;
  final String author;
  final List genre;
  final String isbn;
  bool isBorrowed = false; // Track if the book is borrowed by a user

  Book(this.title, this.author, this.genre, this.isbn);
}
class Onloan {
  final String isbn;
  final String borrowerID;
  final String returnDate;
  Onloan(this.isbn,this.borrowerID,this.returnDate);
}
// Define a class for Library
class Library {
  final List<Book> books = []; // Collection of books in the library
  final List<Onloan> onLoanBooks = [];
  // Method to add a new book to the library
  void addBook(Book book) {

    List bookToBeAddedGenres = book.genre;
    bookToBeAddedGenres.retainWhere((element) => genreList.contains(element));
    if (bookToBeAddedGenres.isEmpty) {
      print("${book.title} does not fit to any genres the library caters to. The book will not be added.");
    } else{
      books.add(Book(book.title,book.author,bookToBeAddedGenres,book.isbn));
    }
  }

  // Functions for displaying books based on which category the user selected
  void displayBookList(library){
    print("All Books:");
    var allBooks = books.toList();
    for (final book in allBooks) {
      print("${book.title} by ${book.author} (ISBN: ${book.isbn})");
    }
      print("\n");
      print("There are currently ${allBooks.length} books int the system\n");
  }
  void displayAvailableBookList(library){
    print("Available Books:");
    var availableBooks = books.where((book) => !book.isBorrowed).toList();
    if (availableBooks.isEmpty){
      print("All books are on loan: No available Books at the moment.\n");
    }else{
      for (final book in availableBooks) {
      print("${book.title} by ${book.author} (ISBN: ${book.isbn})");}
      print("\n");
      print("There are currently ${availableBooks.length} books available for borrowing.\n");}
  }
  void displayBorrowedBookList(library){
    print("Borrowed Books:");
    var borrowedBooks = books.where((book) => book.isBorrowed).toList();
    if (borrowedBooks.isEmpty){
      print("No Books are on loan at the moment.\n");
    }else{
      for (final book in borrowedBooks) {
      print("${book.title} by ${book.author} (ISBN: ${book.isbn})");}
      print("\n");
      print("There are currently ${borrowedBooks.length} books currently on loan.\n");}
  }

  //  Menu to select which books to display 
  void displayBooksMenu(library){
    var displayBooksMenuFlag = 1;
    while (displayBooksMenuFlag==1){
      print("Which books to display?:\n");
      print("1 - All");
      print("2 - Available");
      print("3 - On Loan");
      var decision2 = stdin.readLineSync();
      displayBooksMenuFlag = 0;
      switch (decision2){
          case "1":{displayBookList(library);}
          case "2":{displayAvailableBookList(library);}
          case "3":{displayBorrowedBookList(library);}
          default :{print("Please select from the options below only"); displayBooksMenuFlag = 1;}
      }
    }
  }
  // Function for borrowing
  void loanBook(books, listedBorrowers){
    print("Please enter your Library Membership ID:");
    String loanerId = stdin.readLineSync()!;
    if (!listedBorrowers.map((borrower)=>borrower.borrowerID).contains(loanerId)){
      print("You are not registered in the library: Please register first before loaning a book.");
      return;
    }
    print("Please enter the ISBN of the book you want to loan:");
    String bookisbn = stdin.readLineSync()!;
    if (!books.map((book)=>book.isbn).contains(bookisbn)){
      print("The book is not in the system");
      return;
    }
    var dateToday = DateTime.now();
    String returnDate= "${dateToday.add(Duration(days:7)).day}-${dateToday.add(Duration(days:7)).month}-${dateToday.add(Duration(days:7)).year}";
    final onLoanBook = Onloan(bookisbn,loanerId,returnDate);
    final book = books.firstWhere((book) => book.isbn == bookisbn);
    if (book.isBorrowed){
      print("The book ${book.title} is currently borrowed and will be returned on ${(onLoanBooks.firstWhere((onLoanBook) => onLoanBook.isbn == bookisbn)).returnDate}");
      return;
    }
    onLoanBooks.add(onLoanBook);
    book.isBorrowed = true;
  }
  // Function for returning books
  void returnBook(books){
    print("Please enter the ISBN of the book you are returning:");
    String bookisbn = stdin.readLineSync()!;
    if (!onLoanBooks.map((onloan)=>onloan.isbn).contains(bookisbn)){
      print("There is no book with the ISBN currently on loan.");
      return;
    }
    final onLoanBook = onLoanBooks.firstWhere((onloan) => onloan.isbn == bookisbn);
    onLoanBooks.remove(onLoanBook);
    final book = books.firstWhere((book) => book.isbn == bookisbn);
    book.isBorrowed = false;
  }
}
// Function for getting the info for the book to be added
getBookInfo(){

  print("Please Input Book Name");
  String bookTitle = stdin.readLineSync()!;
  print("Please Inpt Book Author");
  String bookAuthor = stdin.readLineSync()!;
  print("Please Inpt Book Genres (Separate by comma if more than one)");
  String bookGenres = stdin.readLineSync()!;
  print("Please Inpt Book ISBN");
  String isbn = stdin.readLineSync()!;
  final bookToBeAdded = Book(bookTitle,bookAuthor,bookGenres.split(','),isbn);  
  return bookToBeAdded;
}

// Function for Book rental Menu:
void rentalMenu(library, borrowerslist){
  print("Please select from the following");
  print("1 - Loan");
  print("2 - Return");
  var decision = stdin.readLineSync();
  switch (decision){
    case "1":{library.loanBook(library.books, borrowerslist.borrowers);}
    case "2":{library.returnBook(library.books);}
    default: {print("Error: Please Select from the options only");}
  
  }
}
// Function for getting the New Member's Name
getNewMemberName(){
  print("Please enter your name:");
  var newMemberName = stdin.readLineSync()!;
  return newMemberName;
}

void registerMember(name, borrowerslist){
  var membersNumberString = (borrowerslist.borrowers.length+1).toString();
  final borrowerRegister = Borrower(name, membersNumberString.padLeft(6-membersNumberString.length,'0'));
  borrowerslist.addBorrower(borrowerRegister);
  print("Welcome $name! Your library ID is ${borrowerRegister.borrowerID}");
}

void main() {
  
  final library = Library();
  final borrowerslist = borrowersList();
  final borrower1 = Borrower("Frances Banaag","2014-09236");
  borrowerslist.addBorrower(borrower1);
  // Add initial books to the library
  var initialBook = Book("Introduction to Python", "John Smith", ["Computer Science"], "978-1234567890");
  library.addBook(initialBook);
  initialBook = Book("Computer Organization and Design: The Hardware/Software Interface", "David A. Patterson and John L. Hennessy", ["Computer Science"], "978-0128122754");
  library.addBook(initialBook);
  initialBook = Book("A Brief History of Time", "Stephen Hawking", ["Pure Science"], "978-0553380163");
  library.addBook(initialBook);
  initialBook = Book("Cosmos", "Carl Sagan", ["Pure Science"], "978-0345539434");
  library.addBook(initialBook);
  initialBook = Book("Meditations", "Marcus Aurelius", ["Philosophy"], "978-0140449334");
  library.addBook(initialBook);
  initialBook = Book("Critique of Pure Reason", "Immanuel Kant", ["Philosophy"], "978-0486432557");
  library.addBook(initialBook);
  initialBook = Book("A History of the Philippines: From Indios Bravos to Filipinos", "Luis H. Francia", ["History"], "978-1468308570");
  library.addBook(initialBook);
  initialBook = Book("Conjugal Dictatorship", "Primitivo Mijares", ["History"], "978-1523292196");
  library.addBook(initialBook);
  initialBook = Book("The Photographer's Eye: Composition and Design for Better Digital Photos", "Michael Freeman", ["Art and Recreation","Photography"], "978-1234567890");
  library.addBook(initialBook);
  initialBook = Book("Understanding Exposure: How to Shoot Great Photographs with Any Camera", "Bryan Peterson", ["Art and Recreation","Photography"], "978-0817439392");
  library.addBook(initialBook);

  while (true){
    print("Please Select from the list below:");
    print("1 - List Books in the Library");
    print("2 - Book Rental");
    print("3 - Add/Donate a Book");
    print("4 - Register as a library Member");
    var decision = stdin.readLineSync();

    switch(decision){
      case "1":{library.displayBooksMenu(library);}
      case "2":{rentalMenu(library,borrowerslist);}
      case "3":{final bookToBeAdded = getBookInfo();library.addBook(bookToBeAdded);}
      case "4":{final newMemberName = getNewMemberName(); registerMember(newMemberName, borrowerslist);}
      default :{print("Please select from the options below only");}
    }
  }
}
