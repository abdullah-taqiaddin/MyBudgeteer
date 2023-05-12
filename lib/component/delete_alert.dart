import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/viewmodel/database_provider.dart';

import '../model/budget.dart';

class DeletePopup extends StatefulWidget {


  final String id;

  DeletePopup({super.key, required this.id});

  @override
  State<DeletePopup> createState() => _DeletePopupState();
}

class _DeletePopupState extends State<DeletePopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,

      elevation: 250,
      backgroundColor: Colors.white,

      title: Text(
        'Delete Budget?',
        style: TextStyle(
          color: Colors.black,
          fontFamily: "K2D",
          fontSize: 25,
          fontWeight: FontWeight.bold,

        ),
        textAlign: TextAlign.left,
      ),
      content: Container(
        width: 220,
        child: Text(
          'The {budget.name} will be permanently delete',
          style: TextStyle(
            color: Color(0XFF145756),
            fontFamily: "K2D",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 130,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 107, 53, 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: TextButton(
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "K2D",
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      deleteBudget(widget.id);
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 3,),
                Container(
                  width: 130,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),),
                  child: TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0XFF145756),
                        fontFamily: "K2D",
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          )
      ],
    );
  
  }
  Future<void> deleteBudget(String id) async{
    print(id);
    await Provider.of<DatabaseProvider>(context, listen: false).deleteBudget(id);
  }
  
}
