import "package:flutter/material.dart";
import "main_page.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  static const TextStyle fieldStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: Colors.black54,
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: "Iranyekan",
      ),
      child: Scaffold(
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
                      const Icon(
                        Icons.account_circle,
                        size: 85,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const Text(
                        "ورود با ایمیل",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: const Icon(Icons.email),
                            labelText: "ایمیل",
                            labelStyle: fieldStyle,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          obscureText: showPassword,
                          decoration: InputDecoration(
                              filled: true,
                              labelText: "رمز عبور",
                              labelStyle: fieldStyle,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              suffixIcon: GestureDetector(
                                child: showPassword
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                                onTap: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "فراموشی رمز عبور",
                            style: TextStyle(
                                fontSize: 13.5, color: Color(0xFF60c6cd)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              )),
                          child: const Text("ورود"),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "ثبت نام در لشیبو",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF60c6cd),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
