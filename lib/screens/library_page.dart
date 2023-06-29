import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lashibo/providers/book_provider.dart";
import "package:lashibo/src/book.dart";
import "details_page.dart";
import 'package:gap/gap.dart';

enum SortCriteria {
  lastRead,
  audioBook,
  textBook,
  rating,
}

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    SortCriteria dropDownValue = ref.watch(librarySortCriteriaProvider);
    final List<Book> libraryBooks = ref.watch(libraryBooksProvider)!;
    return SafeArea(
      child: ListView.builder(
        itemCount: libraryBooks.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<SortCriteria>(
                  value: dropDownValue,
                  items: const <DropdownMenuItem<SortCriteria>>[
                    DropdownMenuItem(
                      value: SortCriteria.textBook,
                      child: Text("کتاب متنی"),
                    ),
                    DropdownMenuItem(
                      value: SortCriteria.audioBook,
                      child: Text("کتاب صوتی"),
                    ),
                    DropdownMenuItem(
                      value: SortCriteria.lastRead,
                      child: Text("تاریخ مطالعه"),
                    ),
                    DropdownMenuItem(
                      value: SortCriteria.rating,
                      child: Text("امتیاز"),
                    ),
                  ],
                  onChanged: (value) {
                    ref
                        .read(librarySortCriteriaProvider.notifier)
                        .changeCriteria(value!);
                  },
                ),
              ],
            );
          }
          return Card(
            elevation: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(libraryBooks[index - 1]),
                  ),
                );
              },
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.asset(libraryBooks[index - 1].imageAddress)),
                  const Gap(20),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(libraryBooks[index - 1].title),
                        Text(
                          libraryBooks[index - 1].author,
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
    );
  }
}
