import "package:flutter/material.dart";

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String dropDownValue = 'کتاب';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 15,)
          ,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: dropDownValue,
                  items: <String>[
                    'تاریخ مطالعه',
                    'فایل صوتی',
                    'کتاب' ,
                    'بیشترین پسند'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 13),
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
                const Text("مرتب سازی بر اساس"),
              ],
            ),
          ),
          SizedBox(height: 15,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            child: Scrollbar(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(
                  10,
                  (index) => Container(
                    width: 100,
                    child: Column(
                      children: [
                        Flexible(child: Image.asset("assets/images/sample.jpg")),
                        Text("Book Name index:$index")
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
