import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:lashibo/providers/current_user_provider.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final int amount;

  const PaymentPage({required this.amount, Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  bool showPassword = false;
  static const TextStyle fieldStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: Colors.black54,
  );
  static const floatingLabelStyle = TextStyle(
    color: Colors.grey,
    fontSize: 15,
  );

  Future<String> addCredit(String username, int amount) async {
    Socket socket = await Socket.connect("192.168.213.252", 3773);
    socket.writeln("addcredit::$username::$amount");
    String result = "";
    var done = socket.listen((Uint8List buffer) {
      String response = String.fromCharCodes(buffer);
      result = response;
      socket.close();
    });
    await done.asFuture<void>();
    return result;
  }

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Localizations.override(
                context: context,
                locale: const Locale("fa", "IR"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: CreditCardWidget(
                        cardNumber: "4494218125210453",
                        expiryDate: "07/2025",
                        cardHolderName: "Amirhossein Zeinali",
                        cvvCode: "***",
                        showBackView: false,
                        onCreditCardWidgetChange: (brand) {},
                        isHolderNameVisible: true,
                        labelValidThru: "",
                        labelExpiredDate: "Exp.",
                        cardBgColor: Colors.grey,
                        cardType: CardType.mastercard,
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text(
                      "افزایش اعتبار",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.amount.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "تومان",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: passwordController,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: "رمز کارت",
                            labelStyle: fieldStyle,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            floatingLabelStyle: floatingLabelStyle,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            suffixIcon: GestureDetector(
                              child: const Icon(Icons.password),
                              onTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          String currentUsername =
                              ref.read(currentUserProvider)!.username;
                          String serverRes =
                              await addCredit(currentUsername, widget.amount);
                          bool success = serverRes.contains("true") &&
                              passwordController.text == '3056';
                          if (success) {
                            ref
                                .read(currentUserProvider.notifier)
                                .changeCredit(widget.amount);
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            )),
                        child: const Text("خرید"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
