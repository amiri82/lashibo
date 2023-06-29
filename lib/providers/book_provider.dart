import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lashibo/dummy_data/dummy_books.dart";
import "package:lashibo/src/book.dart";

final bookProvider = Provider<List<Book>>((ref) {
  return dummyBooks;
});

class CategoryNotifier extends StateNotifier<Category?> {
  CategoryNotifier() : super(null);

  void changeCategory(Category newCategory) {
    state = newCategory;
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, Category?>((ref) {
  return CategoryNotifier();
});

final categoryFilteredProvider = Provider<List<Book>>((ref) {
  final books = ref.watch(bookProvider);
  final selectedCategory = ref.watch(categoryProvider);
  if (selectedCategory == null) {
    return books;
  } else {
    return books.where((book) => book.category == selectedCategory).toList();
  }
});
