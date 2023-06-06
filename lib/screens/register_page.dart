import "package:flutter/material.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                    const Icon(
                      Icons.account_circle,
                      size: 85,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text(
                      "ثبت نام با ایمیل",
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
                          suffixIcon: const Icon(Icons.account_circle),
                          labelText: "نام کاربری",
                          labelStyle: fieldStyle,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelStyle: floatingLabelStyle,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
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
                          floatingLabelStyle: floatingLabelStyle,
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
                            floatingLabelStyle: floatingLabelStyle,
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
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            )),
                        child: const Text("ثبت نام"),
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
