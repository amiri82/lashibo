import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lashibo/providers/current_user_provider.dart';
import 'package:lashibo/src/book.dart';
import 'package:lashibo/src/user.dart';

class DetailsPage extends ConsumerWidget {
  final Book book;

  void onPressed() {}

  const DetailsPage(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User currentUser = ref.watch(currentUserProvider)!;

    String buttonText;

    if (currentUser.booksBought.contains(book)) {
      if (currentUser.stillReading.contains(book)) {
        buttonText = "خوانذم";
      } else {
        buttonText = "مطالعه";
      }
    } else if (book.quantityLeft == 0) {
      buttonText = "موجود نیست";
    } else if (book.price == 0 || currentUser.premiumMonthsLeft >= 1) {
      buttonText = "دریافت رایگان";
    }else if(book.isPremium && currentUser.premiumMonthsLeft == 0){
      buttonText = "فقط برای کاربر ویژه";
    }
    else {
      buttonText = "خرید |" + " ${book.price} " + "تومان";
    }
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300,
              maxWidth: MediaQuery.of(context).size.width * 0.45,
            ),
            child: Image.asset(book.imageAddress),
          ),
          const Gap(5),
          Center(
            child: Text(
              book.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Center(
            child: Text(
              book.author,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Gap(5),
          Center(
            child: RatingBarIndicator(
              rating: book.rating,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 25,
              direction: Axis.horizontal,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("رای"),
              const Gap(3),
              Text("${book.comments.length}"),
              const Gap(3),
              const Text("از"),
            ],
          ),
          Center(
              child: book.isPremium
                  ? const Text(
                      "ویژه",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(252, 3, 107, 100)),
                    )
                  : null),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: ElevatedButton(
                onPressed: buttonText.contains("موجود نیست") || buttonText.contains("ویژه")
                    ? null
                    : () {
                        onPressed();
                      },
                child: Text(buttonText),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.description,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
