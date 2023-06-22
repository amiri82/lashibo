import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isAvailable = false;
  int currentRating = 0;
  int numberOfRatings = 0;
  bool _isBought = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset("assets/images/sample.jpg"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text("کتاب بر منشا گونه ها"),
                    Text("چارلز داروین"),
                    SizedBox(
                      height: 15,
                    ),
                    Text(_isAvailable
                        ? "کتاب موجود است"
                        : "موجودی کتتاب به پایان رسیده است"),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: _isBought
                      ? ElevatedButton(
                          onPressed: () {}, child: Text("مطالعه کتاب"))
                      : ElevatedButton(
                          onPressed: _isAvailable ? () {} : null,
                          child: Text("خرید کتاب"),
                        ),
                ),
              ),
              Center(
                child: Text(
                  getDescription()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDescription(){
    return "Lorem Ipsum";
  }

}
