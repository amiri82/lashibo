import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lashibo/dummy_data/dummy_books.dart";
import "package:lashibo/screens/library_page.dart";
import "package:lashibo/src/book.dart";
import "package:lashibo/providers/current_user_provider.dart";

final bookProvider = Provider<List<Book>>((ref) {
  return dummyBooks;
});

class ShopCategoryNotifier extends StateNotifier<Category> {
  ShopCategoryNotifier() : super(Category.all);

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
  if (selectedCategory == Category.all) {
    return books;
  } else {
    return books.where((book) => book.category == selectedCategory).toList();
  }
});

final favoriteBooksProvider = Provider<List<Book>>((ref) {
  return ref.watch(currentUserProvider.select((user) => user!.favoriteBooks));
});

final finishedReadingBooksProvider = Provider<List<Book>>((ref) {
  return ref.watch(currentUserProvider.select((user) => user!.finishedReading));
});

final stillReadingBooksProvider = Provider<List<Book>>((ref) {
  return ref.watch(currentUserProvider.select((user) => user!.stillReading));
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
  if (sortCriteria == SortCriteria.rating) {
    result.sort((a, b) => a.rating.compareTo(b.rating));
  }
  return result;
});

final searchTextProvider = StateProvider<String>((ref) => '');

final filteredBooksProvider = Provider<List<Book>>((ref) {
  final searchText = ref.watch(searchTextProvider);
  final books = ref.watch(categoryFilteredProvider);
  if (searchText.isNotEmpty) {
    final result = books.where((element) => element.title.toLowerCase().contains(searchText.toLowerCase())).toList();
    return result;
  }
  return books;
});