import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:testapp/pages/budget_page.dart';
import 'package:testapp/pages/expense_page.dart';


class BottomContainer extends StatefulWidget {
  final Color color;
  BottomContainer({Key? key, required this.color})  : super(key: key);

  @override
  State<BottomContainer> createState() => _BottomContainerState();
}

class _BottomContainerState extends State<BottomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Indexer(
        children: [
          Indexed(
            index: 1,
            child: Positioned(
              bottom: 20,
              left: 25,
              child: Container(
                width: 170,
                height: 70,
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(58, 67, 94, 1),
                      ),

                      elevation: MaterialStateProperty.all<double>(2),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Budget',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BudgetPage()),


                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Indexed(
            index: 2,
            child: Positioned(
                right: 170,
                left: 170,
                bottom: 1,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 101, 129, 168)),
                  child: Center(
                    child: Text(
                      "+",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                )),
          ),
          Indexed(
            index: 1,
            child: Positioned(
              right: 25,
              bottom: 20,
              child: Container(
                width: 170,
                height: 70,
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,

                      ),

                      elevation: MaterialStateProperty.all<double>(2),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Color.fromRGBO(58, 67, 94, 1)),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Expense',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExpensePage()),
                      );
                    },
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
