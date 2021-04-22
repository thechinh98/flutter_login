import 'package:flutter/material.dart';

class BottomSheetModal extends StatelessWidget {
  List<int> indexQuestion = [1,2,3,4,5,6,7,8,9,10];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Sheet"),
      ),
      body: GridView.count(crossAxisCount: 5, crossAxisSpacing: 10.0, mainAxisSpacing: 8.0,padding: EdgeInsets.symmetric(horizontal: 10), children: List.generate(indexQuestion.length, (index) => QuestionIndexItem(index: indexQuestion[index])),)
    );
  }
}

class QuestionIndexItem extends StatelessWidget {
  final int index;
  const QuestionIndexItem({
    Key? key,required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          "$index",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
