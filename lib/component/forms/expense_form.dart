
// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/model/expense.dart';
import 'package:testapp/viewmodel/database_provider.dart';
import 'package:testapp/viewmodel/expense_date_provider.dart';

import 'package:testapp/viewmodel/localization.dart';

import '../../view/budget_page.dart';

class ExpenseForm extends StatefulWidget {

  final int currentMonthIndex;
  //change constructor
  ExpenseForm({Key? key, required this.currentMonthIndex}) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();

}

class _ExpenseFormState extends State<ExpenseForm> {
  @override

  final _formKey = GlobalKey<FormState>();
  final _expenseName = TextEditingController();
  final _amount = TextEditingController();
  final _date = TextEditingController();
  DateTime selectedDate = DateTime.now();

  late Budget selectedBudget;
  String selectedBudgetId = "";


  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _date.dispose();
    _expenseName.dispose();
    _amount.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {


    print("current month index: ${Provider.of<ExpenseDateProvider>(context).month}");
    return Container(
      height: MediaQuery.of(context).size.height* 0.6,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      decoration: BoxDecoration(
        color: isDark?Color.fromRGBO(43, 40, 57, 1):Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${translation(context).addNewExpense}",
                style: TextStyle(
                    color: isDark?Colors.white:Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 20,),
              //drop down menu for selecting the budget
              Text(
                "${translation(context).budget}",
                style: TextStyle(
                    color: isDark?Colors.white:Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 10,),
              StreamBuilder<QuerySnapshot>(
                stream: Provider.of<DatabaseProvider>(context).getBudgetsByMonth(Provider.of<ExpenseDateProvider>(context).month + 1, Provider.of<ExpenseDateProvider>(context).year),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Loading...");
                  }

                  print("current month index from provider: ${Provider.of<ExpenseDateProvider>(context).month}");
                  return DropdownButtonFormField(

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: isDark?Colors.white60:Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: isDark?Colors.white60:Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                    items: snapshot.data!.docs.map((DocumentSnapshot document) {
                      return DropdownMenuItem(
                        value: document['id'],
                        child: Text(
                          document['name'],
                          style: TextStyle(
                              color: isDark?Colors.black:Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: "K2D"),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBudgetId = value.toString();
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 10,),
              Text(
                "${translation(context).day}",
                style: TextStyle(
                    color: isDark?Colors.white:Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                color: isDark?Colors.white:Colors.black,
                onPressed: () async{
                  int month =Provider.of<ExpenseDateProvider>(context,listen: false).month + 1;
                  selectedDate = (await showDatePicker(
                    context: context,
                    //the initailDate should be the date of the selected budget
                    //Provider.of<ExpenseDateProvider>(context).month
                    initialDate: DateTime.utc(2023,month, 1),
                    firstDate: DateTime(DateTime.now().year, month, 1),
                      lastDate: DateTime.utc(2023,month, 1),
                  ))!;
                }
                ,),
              SizedBox(height: 10),
              Text(
                "${translation(context).expenseName}",
                style: TextStyle(
                    color: isDark?Colors.white:Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 10,),
              TextFormField(
                cursorColor: isDark?Colors.white:Colors.black,
                cursorHeight: 20,
                controller: _expenseName,
                style: TextStyle(color: Colors.black, fontFamily: "K2D"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: isDark?Colors.white60:Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: isDark?Colors.white60:Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(color: isDark?Colors.white:Colors.black),
                  hintText: "${translation(context).enterExpenseName}",
                  hintStyle: TextStyle(color: isDark?Colors.white60:Colors.grey,),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "${translation(context).pleaseEnterExpense}";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                "${translation(context).amount}",
                style: TextStyle(
                    color: isDark?Colors.white:Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 10,),
              TextFormField(
                style: TextStyle(color: isDark?Colors.white:Colors.black, fontFamily: "K2D"),
                cursorColor: isDark?Colors.white:Colors.black,
                cursorHeight: 20,
                controller: _amount,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: isDark?Colors.white60:Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: isDark?Colors.white60:Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  hintText: "${translation(context).amount}",
                  hintStyle: TextStyle(
                    color: isDark?Colors.white60:Colors.grey,
                  )
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "${translation(context).pleaseEnterAmount}";
                  }
                  if (!RegExp(r'^\d*\.?\d*$').hasMatch(value)) {
                    return "${translation(context).pleaseEnterNumbers}";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Center(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  minWidth: 120,
                  color: isDark?Color.fromRGBO(159, 79, 248, 1):Color(0XFFFF6B35),
                  elevation: 0,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Submit the form data to firestore

                      addExpense(_expenseName,_amount,selectedDate,selectedBudgetId);
                      Navigator.pop(context);
                    }
                  },
                  child: Text("${translation(context).add}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "K2D")),
                ),
              ),
            ],
            //test comment
          ),
        ),
      ),
    );
  }

  void addExpense(name,amount,date,budgetId){
    Timestamp timestamp = Timestamp.fromDate(date);
    Expense expense = new Expense(id: "", name: name.text, amount: double.parse(amount.text), expenseDate: timestamp, budgetId: budgetId.toString() , budgetName: "");
    Provider.of<DatabaseProvider>(context, listen: false).addExpense(expense);
  }

}


