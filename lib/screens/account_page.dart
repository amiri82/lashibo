import "package:flutter/material.dart";
import "package:lashibo/main.dart";
import "package:lashibo/screens/payment.dart";
import "change_info.dart";
import "dart:io";
import "package:image_picker/image_picker.dart";

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController paymentController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  bool _success = false;
  int _price = 0;
  int _premiumMonthsLeft = 0;
  File? _profileImage;

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
                        backgroundImage: (_profileImage == null) ? null : FileImage(_profileImage!),
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
                      MyApp.of(context).currentUser!.username,
                      style: TextStyle(
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
                          "${MyApp.of(context).currentUser!.credit}",
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
                          _premiumMonthsLeft.toString(),
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
                        onPressed: () {
                          showDialog(
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
                                              Navigator.of(context).pop();
                                              _success =
                                                  await Navigator.of(context)
                                                      .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentPage(
                                                    amount: int.parse(
                                                        paymentController.text),
                                                  ),
                                                ),
                                              );
                                              setState(() {
                                                MyApp.of(context).currentUser!.credit += _success //TODO
                                                    ? int.parse(
                                                        paymentController.text)
                                                    : 0;
                                              });
                                            },
                                            child: const Text("پرداخت"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          );
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
                  MyApp.of(context).changeThemeMode();
                },
                trailing: const Directionality(
                  textDirection: TextDirection.ltr,
                  child: Icon(Icons.arrow_back_rounded),
                ),
                title: const Text("تغییر تم برنامه"),
              ),
              ListTile(
                onTap: () {
                  showDialog(
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
                                    _price = int.parse(changed) * 100000;
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
                                onPressed: () {
                                  if (MyApp.of(context).currentUser!.credit >= _price) {
                                    setState(
                                      () {
                                        MyApp.of(context).currentUser!.credit -= _price;
                                        _premiumMonthsLeft +=
                                            int.parse(monthController.text);
                                      },
                                    );
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
                      MyApp.of(context).currentUser = null;
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyApp()));
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
}
