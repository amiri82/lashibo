import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lashibo/providers/current_user_provider.dart';
import 'package:lashibo/src/book.dart';
import 'package:lashibo/src/user.dart';

class DetailsPage extends ConsumerWidget {
  final Book book;

  Future<String> toggleFavorite(String username, String name) async {
    Socket s = await Socket.connect("192.168.213.252", 3773);
    s.writeln("togglefavoritebook::$username::$name");
    String result = "false";
    var done = s.listen((Uint8List buffer) async {
      String response = String.fromCharCodes(buffer);
      result = response;
      s.close();
    });
    await done.asFuture<void>();
    return result;
  }

  Future<String> buyBook(String username, String name,int price) async {
    Socket s = await Socket.connect("192.168.213.252", 3773);
    s.writeln("addboughtbook::$username::$name::$price");
    String result = "false";
    var done = s.listen((Uint8List buffer) async {
      String response = String.fromCharCodes(buffer);
      result = response;
      s.close();
    });
    await done.asFuture<void>();
    return result;
  }

  Future<String> addStillReading(String username, String name) async {
    Socket s = await Socket.connect("192.168.213.252", 3773);
    s.writeln("addtostillreading::$username::$name");
    String result = "false";
    var done = s.listen((Uint8List buffer) async {
      String response = String.fromCharCodes(buffer);
      result = response;
      s.close();
    });
    await done.asFuture<void>();
    return result;
  }

  Future<String> addFinishedReading(String username, String name) async {
    Socket s = await Socket.connect("192.168.213.252", 3773);
    s.writeln("addtofinishedreading::$username::$name");
    String result = "false";
    var done = s.listen((Uint8List buffer) async {
      String response = String.fromCharCodes(buffer);
      result = response;
      s.close();
    });
    await done.asFuture<void>();
    return result;
  }

  const DetailsPage(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User currentUser = ref.watch(currentUserProvider)!;
    Status currentStatus = currentUser.stillReading.contains(book)
        ? Status.stillReading
        : currentUser.booksBought.contains(book)
            ? Status.bought
            : book.quantityLeft == 0
                ? Status.soldOut
                : currentUser.premiumMonthsLeft >= 1 || book.price == 0
                    ? Status.free
                    : book.isPremium
                        ? Status.notBoughtPremium
                        : Status.notBought;
    String buttonText;

    switch (currentStatus) {
      case Status.stillReading:
        buttonText = 'خواندم';
        break;
      case Status.bought:
        buttonText = "مطالعه";
        break;
      case Status.soldOut:
        buttonText = "موجود نیست";
        break;
      case Status.free:
        buttonText = "دریافت رایگان";
        break;
      case Status.notBoughtPremium:
        buttonText = "فقط برای کاربر ویژه";
        break;
      case Status.notBought:
        buttonText = "خرید |" + " ${book.price} " + "تومان";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              String result = await toggleFavorite(currentUser.username, book.title);
              if(result.contains("true")) {
                ref.read(currentUserProvider.notifier).toggleFavoriteBook(book);
              }
            },
            icon: currentUser.favoriteBooks.contains(book)
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
          ),
        ],
      ),
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
                        color: Color.fromRGBO(252, 3, 107, 100),
                      ),
                    )
                  : null),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: ElevatedButton(
                onPressed: currentStatus == Status.notBoughtPremium ||
                        currentStatus == Status.soldOut
                    ? null
                    : () async {
                  if(currentStatus == Status.notBought || currentStatus == Status.free){
                    String result = await buyBook(currentUser.username, book.title, currentUser.premiumMonthsLeft >= 1 ? 0 : book.price);
                    if(result.contains("true")){
                      ref.read(currentUserProvider.notifier).addBoughtBook(book);
                    }
                  }
                  if(currentStatus == Status.bought){
                    String result = await addStillReading(currentUser.username, book.title);
                    if(result.contains("true")){
                      ref.read(currentUserProvider.notifier).addStillReadingBook(book);
                    }
                  }
                  if(currentStatus == Status.stillReading){
                    String result = await addFinishedReading(currentUser.username, book.title);
                    if(result.contains("true")){
                      ref.read(currentUserProvider.notifier).changeToFinishedReading(book);
                    }
                  }
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
