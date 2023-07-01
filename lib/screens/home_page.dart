import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lashibo/dummy_data/dummy_books.dart";
import "package:lashibo/src/book.dart";
import "details_page.dart";
import 'package:lashibo/providers/book_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    Filter currentFilter = ref.watch(homeFilterProvider);
    final List<Book> stillReadingBooks = ref.watch(stillReadingBooksProvider);
    final List<Book> textBooks = ref.watch(homeFilteredTextBookProvider);
    final List<Book> audioBooks = ref.watch(homeFilteredAudioBookProvider);

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stillReadingBooks.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text("کتاب در حال خواندنی ندارید"),
                          ),
                        )
                      : Expanded(
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemCount: stillReadingBooks.length,
                            itemBuilder: (context, index) {
                              return bookBuilder(
                                  stillReadingBooks, index, 0, context);
                            },
                          ),
                        )
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: AppBar(
                centerTitle: true,
                title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButton<Filter>(
                    value: currentFilter,
                    items: const [
                      DropdownMenuItem(
                        value: Filter.bestSeller,
                        child: Text("پر فروش"),
                      ),
                      DropdownMenuItem(
                        value: Filter.highestRating,
                        child: Text("بیشترین پسند"),
                      ),
                      DropdownMenuItem(
                        value: Filter.mostRecent,
                        child: Text("جدید ترین"),
                      ),
                    ],
                    onChanged: (value) {
                      ref
                          .read(homeFilterProvider.notifier)
                          .changeFilter(value!);
                    },
                  ),
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "کتاب صوتی",
                      ),
                    ),
                    Tab(
                      child: Text(
                        "کتاب متنی",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: audioBooks.length,
                    itemBuilder: (context, index) {
                      return bookBuilder(audioBooks, index, 0, context);
                    },
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: textBooks.length,
                    itemBuilder: (context, index) {
                      return bookBuilder(textBooks, index, 0, context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  generateAudioBooks(String dropDownValue) {
    return Scrollbar(
      child: SizedBox(
        height: 450,
        child: GridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          children: List.generate(
            6,
            (index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailsPage(dummyBooks[0])));
              },
              child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Flexible(child: Image.asset("assets/images/sample.jpg")),
                    Text("$dropDownValue AudioBook $index")
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bookBuilder(List<Book> books, int currentIndex, int startIndex,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  DetailsPage(books[currentIndex - startIndex]),
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  books[currentIndex - startIndex].imageAddress,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(books[currentIndex - startIndex].title),
            ),
          ],
        ),
      ),
    );
  }
}
