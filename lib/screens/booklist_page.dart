import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lashibo/screens/details_page.dart';
import 'package:lashibo/src/book.dart';

class BookList extends ConsumerWidget {
  final List<Book> books;
  const BookList(this.books,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(books[index]),
                    ),
                  );
                },
                child: Card(
                  elevation: 8,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Image.asset(books[index].imageAddress)),
                      const Gap(20),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(books[index].title),
                            Text(
                              books[index].author,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
