// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/viewmodel/database_provider.dart';
import 'package:testapp/view/budget_page.dart';
import 'package:testapp/viewmodel/localization.dart';

class DeletePopup extends StatefulWidget {
  final String id;
  final String name;

  DeletePopup({super.key, required this.id, required this.name});

  @override
  State<DeletePopup> createState() => _DeletePopupState();
}

class _DeletePopupState extends State<DeletePopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 250,
      backgroundColor: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
      title: Text(
        '${translation(context).deleteBudget}',
        style: TextStyle(
          color: isDark?Colors.white:Color(0XFF145756),
          fontFamily: "K2D",
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
      content: Container(
        width: 220,
        child: Text(
          "${translation(context).budget} ${widget.name.toUpperCase()} ${translation(context).budgetDeleteMessage}",
          style: TextStyle(
            color: isDark?Colors.white:Color(0XFF145756),
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
                  color: isDark?Color.fromRGBO(159, 79, 248, 1):Color.fromRGBO(255, 107, 53, 1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: TextButton(
                  child: Text(
                    '${translation(context).delete}',
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
              SizedBox(
                width: 3,
              ),
              Container(
                width: 130,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: TextButton(
                  child: Text(
                    '${translation(context).cancel}',
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

  void deleteBudget(String id) {
    print(id);
    Provider.of<DatabaseProvider>(context, listen: false).deleteBudget(id);
  }
}
