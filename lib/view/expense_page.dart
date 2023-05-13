import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:testapp/viewmodel/database_provider.dart';

class expenseTab extends StatefulWidget {
  const expenseTab({Key? key}) : super(key: key);

  @override
  State<expenseTab> createState() => _expenseTabState();
}

int currentMonthIndex = DateTime.now().month +1 ;
String _selectedYear = DateFormat.y().format(DateTime.now()).toString();

class _expenseTabState extends State<expenseTab> {
  void initState() {
    super.initState();
    _selectedYear = DateFormat.y().format(DateTime.now()).toString();
  }


  @override
  Widget build(BuildContext context) {
    print("current index: ${currentMonthIndex}");
    return StreamBuilder<List<Map<String,dynamic>>>(
      stream: Provider.of<DatabaseProvider>(context).getExpensesByMonth(currentMonthIndex + 1 ,int.parse(_selectedYear!)).asStream() ,
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasError){
          return Center(child: Text('Error'),);
        }
        print(snapshot.data);
        return Column(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top:20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.primaryVelocity! > 0) {
                          setState(() {
                            currentMonthIndex = (currentMonthIndex - 1) % 12;
                          });
                        } else if (details.primaryVelocity! < 0) {
                          setState(() {
                            currentMonthIndex = (currentMonthIndex + 1) % 12;
                          });
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromRGBO(123, 203, 201, 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  currentMonthIndex = (currentMonthIndex - 1) % 12;
                                });
                              },
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Center(
                              child: Text(
                                DateFormat.MMMM()
                                    .format(DateTime(
                                        DateTime.now().month, currentMonthIndex + 1))
                                    .toString(),
                                style: TextStyle(
                                  fontFamily: "K2D",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  currentMonthIndex = (currentMonthIndex + 1) % 12;
                                });
                              },
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 10,
                    ),
                    //Years
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color.fromRGBO(123, 203, 201, 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.teal[100],

                                    value: _selectedYear,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        newValue = newValue;
                                      });
                                    },
                                    items: <String>[
                                      DateFormat.y()
                                          .format(DateTime.now())
                                          .toString(),
                                      (DateTime.now().year + 1).toString(),
                                    ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontFamily: "K2D",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.2,
          ),
          Container(
              width: 344,
              height: 485,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                print(snapshot.data);
                Color c3 = const Color.fromRGBO(33, 137, 118, 1);
                Color c4 = const Color.fromRGBO(52, 207, 179, 1);

                return Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildExpenseCard(c4, c3,
                DateTime(DateTime.daysPerWeek), "Food", "100000", "KFC"),
                );
                },

              )
          ),
        ]);
      }
    );
  }
}

Widget buildExpenseCard(Color color1, Color color2, DateTime dateTime,
    String budgetCategory, String total, String description) {
  return Container(
    width: 500,
    decoration: BoxDecoration(
      // gradient: gradient,
      color: color1,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //date
        Container(
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color2,
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                DateFormat('E, d/M/y').format(dateTime).toString(),
                style: TextStyle(
                  fontFamily: "K2D",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Text(
                    "Total:",
                    style: TextStyle(
                        fontFamily: "K2D",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "$total\$",
                    style: TextStyle(
                        fontFamily: "K2D",
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white),
                  )
              ],
              )
    ),
        Container(
          height: 25,
          child: IconButton(
            color: Colors.white,
            onPressed: (){
              //expand and show all the expenses of that date
            },
            icon: Icon(Icons.expand_more,),
          ),
        ),
      ],
    ),
  );
}
