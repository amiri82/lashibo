import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lashibo/main.dart";
import "package:lashibo/screens/payment.dart";
import "change_info.dart";
import "dart:io";
import "package:image_picker/image_picker.dart";
import "package:lashibo/providers/themedata_provider.dart";
import "package:lashibo/providers/current_user_provider.dart";

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final TextEditingController paymentController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  int _price = 0;
  File? _profileImage;

  Future<String> addPremiumMonths(String username, int months) async {
    Socket s = await Socket.connect("192.168.213.252", 3773);
    s.writeln("addpremiummonths $username $months");
    String result = "false";
    var done = s.listen((Uint8List buffer) async {
      String response = String.fromCharCodes(buffer);
      result = response;
      s.close();
    });
    await done.asFuture<void>();
    return result;
  }

  void _imageSelector() async {
    final imagePicker = ImagePicker();
    final takenImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (takenImage == null) {
        _profileImage = null;
        return;
      }
      _profileImage = File(takenImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget profileCircle = const Icon(
      Icons.account_circle,
      size: 100,
    );
    return Localizations.override(
      locale: const Locale("fa", "IR"),
      context: context,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.375,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Colors.blue,
                      Colors.lightBlueAccent,
                    ])),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: (_profileImage == null)
                            ? null
                            : FileImage(_profileImage!),
                        child: _profileImage == null ? profileCircle : null,
                      ),
                      onTap: () {
                        _imageSelector();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      ref.watch(
                          currentUserProvider.select((user) => user!.username)),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "اعتبار: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "${ref.watch(currentUserProvider.select((user) => user!.credit))}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "اکانت ویژه : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${ref.watch(currentUserProvider.select((user) => user!.premiumMonthsLeft))}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          " ماه",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          var x = showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("مبلغ مورد نظر را وارد کنید"),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: paymentController,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentPage(
                                                    amount: int.parse(
                                                        paymentController.text),
                                                  ),
                                                ),
                                              );
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("پرداخت"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                          await x;
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "افزایش اعتبار",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChangeInfoPage(),
                    ),
                  );
                },
                trailing: const Directionality(
                  textDirection: TextDirection.ltr,
                  child: Icon(Icons.arrow_back_rounded),
                ),
                title: const Text("ویرایش اطلاعات"),
              ),
              ListTile(
                onTap: () {
                  ref.read(themeDataProvider.notifier).changeTheme();
                },
                trailing: const Directionality(
                  textDirection: TextDirection.ltr,
                  child: Icon(Icons.arrow_back_rounded),
                ),
                title: const Text("تغییر تم برنامه"),
              ),
              ListTile(
                onTap: () async {
                  var x = showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setSt) => AlertDialog(
                          title: const Center(
                            child: Text("تعداد ماه های مورد نطر"),
                          ),
                          actions: [
                            TextField(
                              controller: monthController,
                              onChanged: (changed) {
                                if (changed.isNotEmpty) {
                                  setSt(() {
                                    _price = int.parse(changed) * 10000;
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("قیمت"),
                                Text(_price.toString()),
                                const Text("تومان"),
                              ],
                            ),
                            SizedBox(
                              width: 70,
                              child: ElevatedButton(
                                child: const Text("تایید"),
                                onPressed: () async {
                                  String currentUsername =
                                      ref.read(currentUserProvider)!.username;
                                  String serverRes =
                                      await addCredit(currentUsername, -_price);
                                  bool success1 = serverRes.contains("true");
                                  String serverRes2 = await addPremiumMonths(
                                      currentUsername,
                                      int.parse(monthController.text));
                                  bool success2 = serverRes2.contains("true");
                                  if (success1 && success2) {
                                    ref
                                        .read(currentUserProvider.notifier)
                                        .changeCredit(-_price);
                                    ref
                                        .read(currentUserProvider.notifier)
                                        .changePremiumMonthsLeft(
                                            int.parse(monthController.text));
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                  await x;
                },
                trailing: const Directionality(
                  textDirection: TextDirection.ltr,
                  child: Icon(Icons.arrow_back_rounded),
                ),
                title: const Text("ارتقا به اکانت ویژه"),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.invalidate(currentUserProvider);
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyApp()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "خروج از حساب کاربری",
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> addCredit(String username, int amount) async {
    Socket socket = await Socket.connect("192.168.213.252", 3773);
    socket.writeln("addcredit $username $amount");
    String result = "";
    var done = socket.listen((Uint8List buffer) {
      String response = String.fromCharCodes(buffer);
      result = response;
      socket.close();
    });
    await done.asFuture<void>();
    return result;
  }
}
