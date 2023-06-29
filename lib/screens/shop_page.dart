import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lashibo/providers/book_provider.dart';
import 'package:lashibo/src/book.dart';

class ShopPage extends ConsumerWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Book> selectedBooks = ref.watch(categoryFilteredProvider);
    return SafeArea(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300),
        scrollDirection: Axis.vertical,
        itemCount: selectedBooks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      selectedBooks[index].imageAddress,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(selectedBooks[index].title),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
