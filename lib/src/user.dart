import 'package:lashibo/dummy_data/dummy_books.dart';
import 'package:lashibo/src/book.dart';

class User{
    String username;
    String emailAddress;
    int credit;
    int premiumMonthsLeft;
    List<Book> booksBought;
    List<Book> favoriteBooks;
    List<Book> stillReading;
    User(this.username,this.emailAddress,this.credit,this.premiumMonthsLeft,[this.booksBought = const [],this.favoriteBooks = const[],this.stillReading = const[]]){
        booksBought = dummyBooks.getRange(0, 6).toList();
    }

}