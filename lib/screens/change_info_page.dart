import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lashibo/providers/current_user_provider.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChangeInfoPage extends ConsumerStatefulWidget {
  const ChangeInfoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangeInfoPage> createState() => _ChangeInfoPageState();
}

class _ChangeInfoPageState extends ConsumerState<ChangeInfoPage> {
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
  final TextEditingController _usernameController = TextEditingController();
  final illegalCharacters = [
    FilteringTextInputFormatter.deny(RegExp(r"\s"), replacementString: "")
  ];

  Future<String> changeUsername(String oldUsername, String newUsername) async {
    Socket s = await Socket.connect("192.168.213.252", 3773);
    s.writeln("changeusername::$oldUsername::$newUsername");
    String result = "false";
    var done = s.listen((Uint8List buffer) async {
      String response = String.fromCharCodes(buffer);
      result = response;
      s.close();
    });
    await done.asFuture<void>();
    return result;
  }

  Future<String> changePassword(String username, String newPassword) async {
    Socket s = await Socket.connect("192.168.213.252", 3773);
    s.writeln("changepassword::$username::$newPassword");
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
    _emailController.text = ref.read(currentUserProvider)!.emailAddress;
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
                        Icons.change_circle,
                        size: 85,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const Text(
                        "ویرایش اطلاعات",
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
                          controller: _emailController,
                          enabled: false,
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
                          controller: _usernameController,
                          inputFormatters: illegalCharacters,
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            filled: true,
                            labelText: "نام کاربری",
                            labelStyle: fieldStyle,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            floatingLabelStyle: floatingLabelStyle,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            suffixIcon: const Icon(Icons.account_circle),
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
                            if (value != null && value.isNotEmpty) {
                              RegExp passReg = RegExp(
                                  r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");
                              if (!passReg.hasMatch(value)) {
                                return "رمزعبور باید حداقل ۸ کاراکتر و شامل حداقل یک حرف بزرگ و یک عدد باشد";
                              }
                              if(_usernameController.text.isNotEmpty){
                                if (value.contains(_usernameController.text)) {
                                  return "رمز عبور نمی تواند شامل نام کاربری باشد";
                                }
                              }
                              else if(value.contains(ref.read(currentUserProvider)!.username)) {
                                return "رمز عبور نمی تواند شامل نام کاربری باشد";
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            filled: true,
                            labelText: "رمز عبور",
                            labelStyle: fieldStyle,
                            floatingLabelStyle: floatingLabelStyle,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                        height: 30,
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
                          child: const Text("ثبت"),
                          onPressed: () async {
                            String currentUsername = ref.read(currentUserProvider)!.username;
                            String newUsername = _usernameController.text;
                            if (_formKey.currentState!.validate()) {
                              bool isUsernameChanged = _usernameController.text.isNotEmpty;
                              bool isPasswordChanged =
                                  _passwordController.text.isNotEmpty;
                              bool changePasswordResult = true;
                              bool changeUsernameResult = true;
                              String results = "";
                              if (isUsernameChanged) {
                                String result = await changeUsername(
                                    currentUsername, newUsername);
                                if (result.contains("duplicate_username")) {
                                  results += "نام کاربری تکراری است! ";
                                  changeUsernameResult = false;
                                } else if (result.contains("false")) {
                                  results += "خطا در تغییر نام کاربری ";
                                  changeUsernameResult = false;
                                } else {
                                  results +=
                                      "نام کاربری با موفقیت تغییر یافت ";
                                  ref.read(currentUserProvider.notifier).setUsername(newUsername);
                                  _usernameController.text = newUsername;
                                }
                              }
                              if (isPasswordChanged) {
                                if(results.isNotEmpty){
                                  results += "\n";
                                }
                                currentUsername = ref.read(currentUserProvider)!.username;
                                String result = await changePassword(
                                    currentUsername, _passwordController.text);
                                if (result.contains("false")) {
                                  results += "خطا در تغییر رمزعبور";
                                  changePasswordResult = false;
                                } else {
                                  results += "رمز عبور با موفقیت تغییر یافت";
                                }
                              }
                              if (changePasswordResult &&
                                  changeUsernameResult) {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentMaterialBanner()
                                  ..showMaterialBanner(
                                    MaterialBanner(
                                      content: Text((isPasswordChanged || isUsernameChanged) ? results : "تغییری انجام نشد"),
                                      overflowAlignment: OverflowBarAlignment.center,
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .removeCurrentMaterialBanner();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("باشه"),
                                        ),
                                      ],
                                    ),
                                  );
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentMaterialBanner()
                                  ..showMaterialBanner(
                                    MaterialBanner(
                                      content: Text(results),
                                      overflowAlignment: OverflowBarAlignment.center,
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentMaterialBanner();
                                          },
                                          child: const Text("باشه"),
                                        ),
                                      ],
                                    ),
                                  );
                              }
                            }
                          },
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
