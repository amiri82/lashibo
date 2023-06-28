import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lashibo/providers/current_user_provider.dart";
import "main_page.dart";
import "register_page.dart";
import "dart:io";

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final illegalCharacters = [
    FilteringTextInputFormatter.deny(RegExp(r"\s"), replacementString: "")
  ];

  Future<String> authenticate(String username, String password) async {
    Socket s = await Socket.connect("192.168.213.252", 3773);
    s.writeln("login $username $password");
    String result = "false";
    var done = s.listen((Uint8List buffer) async {
      String response = String.fromCharCodes(buffer);
      result = response;
      s.close();
    });
    await done.asFuture<void>();
    return result;
  }

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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 85,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const Text(
                        "ورود",
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
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "ایمیل/نام کاربری نمیتواند خالی باشد!";
                            }
                            return null;
                          },
                          inputFormatters: illegalCharacters,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: const Icon(Icons.email),
                            labelText: "ایمیل/نام کاربری",
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
                            suffixIcon: GestureDetector( //TODO:IconButton
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: const Text("ورود"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String result = await authenticate(
                                  _emailController.text,
                                  _passwordController.text);
                              if (result.contains(":")) {
                                List<String> creds = result.split(":");
                                ref.read(currentUserProvider.notifier).setUser(creds[0], creds[1], int.parse(creds[2]), int.parse(creds[3]));
                                //MyApp.of(context).changeCurrentUser(creds[0], creds[1], int.parse(creds[2]),int.parse(creds[3]));
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const MainPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentMaterialBanner()
                                  ..showMaterialBanner(
                                    MaterialBanner(
                                      content: const Text(
                                          "نام کاربری یا رمزعبور اشتباه است"),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentMaterialBanner();
                                            },
                                            child: const Text("باشه"))
                                      ],
                                    ),
                                  );
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        child: const Text(
                          "ثبت نام در لشیبو",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF60c6cd),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
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
