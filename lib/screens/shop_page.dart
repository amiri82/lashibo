import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lashibo/providers/book_provider.dart';
import 'package:lashibo/screens/details_page.dart';
import 'package:lashibo/src/book.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  @override
  Widget build(BuildContext context) {
    final List<Book> selectedBooks = ref.watch(filteredBooksProvider);
    return SafeArea(
      child: Column(
        children: [
          AppBar(
            title: TextFormField(
              initialValue: ref.read(searchTextProvider),
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  ref
                      .read(searchTextProvider.notifier)
                      .update((state) => value);
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Category:"),
              const Gap(10),
              DropdownButton<Category>(
                value: ref.watch(shopCategoryProvider),
                items: Category.values
                    .map<DropdownMenuItem<Category>>(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  ref.read(shopCategoryProvider.notifier).changeCategory(value!);
                },
              ),
            ],
          ),
          const Gap(10),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300),
              scrollDirection: Axis.vertical,
              itemCount: selectedBooks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailsPage(selectedBooks[index]),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
