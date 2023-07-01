import 'package:lashibo/src/book.dart';

class User{
    String username;
    String emailAddress;
    int credit;
    int premiumMonthsLeft;
    List<Book> booksBought;
    List<Book> favoriteBooks;
    List<Book> stillReading;
    List<Book> finishedReading;
    User(this.username,this.emailAddress,this.credit,this.premiumMonthsLeft,[this.booksBought = const [],this.favoriteBooks = const[],this.stillReading = const[],this.finishedReading = const []]);

}