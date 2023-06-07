import "package:flutter/material.dart";
import "details_page.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropDownValue = "علاقه مندی ها";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: const Center(
                    child: Text("کتاب در حال خواندنی ندارید"),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: AppBar(
                    bottom: const TabBar(
                      tabs: [
                        Tab(
                          child: Text("کتاب متنی"),
                        ),
                        Tab(
                          child: Text("کتاب صوتی"),
                        ),
                      ],
                      isScrollable: false,
                    ),
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          DropdownButton<String>(
                            // Step 3.
                            value: dropDownValue,
                            items: <String>[
                              'علاقه مندی ها',
                              'پر فروش ها',
                              'جدید ترین ها'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }).toList(),
                            // Step 5.
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: 15),
                          generateBooks(dropDownValue),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          DropdownButton<String>(
                            // Step 3.
                            value: dropDownValue,
                            items: <String>[
                              'علاقه مندی ها',
                              'پر فروش ها',
                              'جدید ترین ها'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }).toList(),
                            // Step 5.
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: 15),
                          generateAudioBooks(dropDownValue),
                        ],
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  generateAudioBooks(String dropDownValue) {
    return Scrollbar(
      child: SizedBox(
        height: 450,
        child: GridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          children: List.generate(
            6,
            (index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DetailsPage()));
              },
              child: Container(
                height: 100,
                child: Column(
                  children: [
                    Flexible(child: Image.asset("assets/images/sample.jpg")),
                    Text("$dropDownValue AudioBook $index")
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  generateBooks(String dropDownValue) {
    return Scrollbar(
      child: SizedBox(
        height: 450,
        child: GridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          children: List.generate(
            6,
                (index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DetailsPage()));
              },
              child: Container(
                height: 100,
                child: Column(
                  children: [
                    Flexible(child: Image.asset("assets/images/sample.jpg")),
                    Text("$dropDownValue Book Name $index")
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
