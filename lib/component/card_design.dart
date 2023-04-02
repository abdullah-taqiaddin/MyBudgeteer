// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CardDesign extends StatefulWidget {
  const CardDesign({Key? key}) : super(key: key);

  @override
  State<CardDesign> createState() => _CardDesignState();
}

class _CardDesignState extends State<CardDesign> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        height: 107,
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(101, 129, 168, 1)),

            color: Colors.white, borderRadius: BorderRadius.circular(23)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Text
                  Text("T Y P E"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.edit_outlined)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete_outline,
                            size: 24,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Spent"),
                        SizedBox(height: 4),
                        Text("200")
                      ],
                    ),
                  ),
                  Center(
                    child: LinearPercentIndicator(
                      width: 250.0,
                      lineHeight: 20.0,
                      barRadius: Radius.circular(40),
                      percent: 0.7,
                      center: Text(
                        "",
                        style: TextStyle(fontSize: 12.0),
                      ),
                      backgroundColor: Color.fromRGBO(235, 235, 235, 1),
                      progressColor: Color.fromRGBO(188, 188, 188, 1),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("total"),
                        SizedBox(height: 4),
                        Text(
                          "300",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
