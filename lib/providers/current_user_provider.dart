import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lashibo/src/book.dart";
import "package:lashibo/src/user.dart";

class CurrentUserNotifier extends StateNotifier<User?> {
  CurrentUserNotifier() : super(null);

  void setUser(
      String username, String emailAddress, int credit, int premiumMonthsLeft, List<Book> booksBought,List<Book> favoriteBooks, List<Book> stillReading, List<Book> finishedReading) {
    state = User(username, emailAddress, credit, premiumMonthsLeft,booksBought,favoriteBooks,stillReading,finishedReading);
  }

  void setUsername(String newUsername) {
    if (state != null) {
      state = User(
          newUsername,
          state!.emailAddress,
          state!.credit,
          state!.premiumMonthsLeft,
          state!.booksBought,
          state!.favoriteBooks,
          state!.stillReading,
          state!.finishedReading);
    }
  }

  void changeCredit(int change) {
    if (state != null) {
      state = User(
          state!.username,
          state!.emailAddress,
          (state!.credit + change),
          state!.premiumMonthsLeft,
          state!.booksBought,
          state!.favoriteBooks,
          state!.stillReading,
          state!.finishedReading);
    }
  }

  void changePremiumMonthsLeft(int change) {
    if (state != null) {
      state = User(
          state!.username,
          state!.emailAddress,
          state!.credit,
          (state!.premiumMonthsLeft + change),
          state!.booksBought,
          state!.favoriteBooks,
          state!.stillReading,
          state!.finishedReading);
    }
  }

  void addBoughtBook(Book book) {
    state = User(
        state!.username,
        state!.emailAddress,
        state!.credit - (state!.premiumMonthsLeft >= 1 ? 0 : book.price),
        state!.premiumMonthsLeft,
        [...state!.booksBought, book],
        state!.favoriteBooks,
        state!.stillReading,
        state!.finishedReading);
  }

  void toggleFavoriteBook(Book book) {
    if (state!.favoriteBooks.contains(book)) {
      var res = state!.favoriteBooks.where((b) => b != book).toList();
      state = User(
          state!.username,
          state!.emailAddress,
          state!.credit,
          state!.premiumMonthsLeft,
          state!.booksBought,
          res,
          state!.stillReading,
          state!.finishedReading);
    } else {
      state = User(
          state!.username,
          state!.emailAddress,
          state!.credit,
          state!.premiumMonthsLeft,
          state!.booksBought,
          [...state!.favoriteBooks, book],
          state!.stillReading,
          state!.finishedReading);
    }
  }

  void addStillReadingBook(Book book) {
    state = User(
        state!.username,
        state!.emailAddress,
        state!.credit,
        state!.premiumMonthsLeft,
        state!.booksBought,
        state!.favoriteBooks,
        [...state!.stillReading, book],
        state!.finishedReading);
  }

  void changeToFinishedReading(Book book) {
    var newStill = state!.stillReading.where((b) => b != book).toList();
    state = User(
        state!.username,
        state!.emailAddress,
        state!.credit,
        state!.premiumMonthsLeft,
        state!.booksBought,
        state!.favoriteBooks,
        newStill,
        [...state!.finishedReading, book]);
  }
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier();
});
