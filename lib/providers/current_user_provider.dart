import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lashibo/src/book.dart";
import "package:lashibo/src/user.dart";

class CurrentUserNotifier extends StateNotifier<User?> {
  CurrentUserNotifier() : super(null);

  void setUser(
      String username, String emailAddress, int credit, int premiumMonthsLeft) {
    state = User(username, emailAddress, credit, premiumMonthsLeft);
  }

  void setUsername(String newUsername) {
    if (state != null) {
      state = User(newUsername, state!.emailAddress, state!.credit,
          state!.premiumMonthsLeft);
    }
  }

  void changeCredit(int change) {
    if (state != null) {
      state = User(state!.username, state!.emailAddress,
          (state!.credit + change), state!.premiumMonthsLeft);
    }
  }

  void changePremiumMonthsLeft(int change) {
    if (state != null) {
      state = User(state!.username, state!.emailAddress, state!.credit,
          (state!.premiumMonthsLeft + change));
    }
  }

  void addBook(Book book){
    state = User(state!.username, state!.emailAddress, state!.credit, state!.premiumMonthsLeft, [...state!.booksBought,book]);
  }

  void addFavoriteBook(Book book){
    state = User(state!.username, state!.emailAddress, state!.credit, state!.premiumMonthsLeft, state!.booksBought, [...state!.favoriteBooks,book]);
  }
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier();
});
