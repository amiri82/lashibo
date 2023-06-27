import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";

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

  Future<String?> signUp(
      String username, String emailAddress, String password) async {
    Socket socket = await Socket.connect("192.168.33.252", 3773);
    String? result;
    socket.writeln("signup $username $emailAddress $password");
    var done = socket.listen((Uint8List buffer) async {
      result = String.fromCharCodes(buffer);
      socket.close();
    });
    await done.asFuture<void>();
    print(result);
    return result!.contains("error")
        ? "خطا"
        : result!.contains("duplicate_username")
            ? "نام کاربری تکراری است"
            : null;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final illegalCharacters = [
    FilteringTextInputFormatter.deny(RegExp(r"\s"), replacementString: "")
  ];

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
                child: Form(
                  key: _formKey,
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
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 50,
                          maxHeight: 90,
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "نام کاربری نمی تواند خالی باشد";
                            }
                            return null;
                          },
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
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 50,
                          maxHeight: 90,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "ایمیل نمیتواند خالی باشد!";
                            } else {
                              RegExp emailReg =
                                  RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                              if (!emailReg.hasMatch(value)) {
                                return "لظفا یک ایمیل معتبر وارد کنید!";
                              }
                              return null;
                            }
                          },
                          inputFormatters: illegalCharacters,
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
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 50,
                          maxHeight: 100,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                          obscureText: !showPassword,
                          inputFormatters: illegalCharacters,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "رمزعبور نمی تواند خالی باشد";
                            } else {
                              RegExp passReg = RegExp(
                                  r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");
                              if (!passReg.hasMatch(value)) {
                                return "رمزعبور باید حداقل ۸ کاراکتر و شامل حداقل یک حرف بزرگ و یک عدد باشد";
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorMaxLines: 2,
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
                              child: !showPassword
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                              onTap: () {
                                setState(
                                  () {
                                    showPassword = !showPassword;
                                  },
                                );
                              },
                            ),
                          ),
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
                            if (_formKey.currentState!.validate()) {
                              String? result = await signUp(
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text);
                              if (result == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "ثبت نام با موفقیت انجام شد")));
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentMaterialBanner()
                                  ..showMaterialBanner(
                                    MaterialBanner(
                                      content: Text(result),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentMaterialBanner();
                                            },
                                            child:const Text("باشه"))
                                      ],
                                    ),
                                  );
                              }
                            }
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
      ),
    );
  }
}
