import "package:flutter/material.dart";
import "package:lashibo/main.dart";

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int balance = 0;

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      locale: const Locale("fa", "IR"),
      context: context,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
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
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "نام کاربری",
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
                        Text("$balance"),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
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
              const ListTile(
                trailing: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Icon(Icons.arrow_back_rounded),
                ),
                title: Text("ویرایش اطلاعات"),
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
              const ListTile(
                trailing: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Icon(Icons.arrow_back_rounded),
                ),
                title: Text("ارتقا به اکانت ویژه"),
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
                      Navigator.of(context).pop();
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
