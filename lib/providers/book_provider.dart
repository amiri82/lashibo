import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lashibo/dummy_data/dummy_books.dart";
import "package:lashibo/screens/library_page.dart";
import "package:lashibo/src/book.dart";
import "package:lashibo/providers/current_user_provider.dart";

final bookProvider = Provider<List<Book>>((ref) {
  return dummyBooks;
});

class ShopCategoryNotifier extends StateNotifier<Category?> {
  ShopCategoryNotifier() : super(null);

  void changeCategory(Category newCategory) {
    state = newCategory;
  }
}

class LibrarySortCriteriaNotifier extends StateNotifier<SortCriteria> {
  LibrarySortCriteriaNotifier() : super(SortCriteria.textBook);

  void changeCriteria(SortCriteria newSortCriteria) {
    state = newSortCriteria;
  }
}

final librarySortCriteriaProvider =
    StateNotifierProvider<LibrarySortCriteriaNotifier, SortCriteria>((ref) {
  return LibrarySortCriteriaNotifier();
});

final shopCategoryProvider =
    StateNotifierProvider<ShopCategoryNotifier, Category?>((ref) {
  return ShopCategoryNotifier();
});

final categoryFilteredProvider = Provider<List<Book>>((ref) {
  final books = ref.watch(bookProvider);
  final selectedCategory = ref.watch(shopCategoryProvider);
  if (selectedCategory == null) {
    return books;
  } else {
    return books.where((book) => book.category == selectedCategory).toList();
  }
});

final favoriteBooksProvider = Provider<List<Book>>((ref) {
  return ref.watch(currentUserProvider.select((user) => user!.favoriteBooks));
});

final libraryBooksProvider = Provider<List<Book>>((ref) {
  final boughtBooks =
      ref.watch(currentUserProvider.select((user) => user!.booksBought));
  final sortCriteria = ref.watch(librarySortCriteriaProvider);
  List<Book> result = boughtBooks;
  if (sortCriteria == SortCriteria.textBook) {
    result = boughtBooks
        .where((book) => book.bookType == BookType.textBook)
        .toList();
    result.sort((a, b) => a.title.compareTo(b.title));
  }
  if (sortCriteria == SortCriteria.audioBook) {
    result = boughtBooks
        .where((book) => book.bookType == BookType.audioBook)
        .toList();
    result.sort((a, b) => a.title.compareTo(b.title));
  }
  if(sortCriteria == SortCriteria.rating){
    result.sort((a, b) => a.rating.compareTo(b.rating));
  }
  return result;
});
