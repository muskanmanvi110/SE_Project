import 'package:flutter/material.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
           Navigator.pop(context);
        }, icon: const  Icon(Icons.arrow_back_ios_new)
        ),
      ),
      body: const Center(
        child: Text("muskan manvi")
      ),
    );
  }
}