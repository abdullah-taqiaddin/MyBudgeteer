
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/model/expense.dart';
import 'package:testapp/viewmodel/database_provider.dart';

class ExpenseForm extends StatefulWidget {

  const ExpenseForm({Key? key}) : super(key: key);

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
  void budgetFormSubmit(TextEditingController budgeName,TextEditingController ){

  }


  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _date.dispose();
    _expenseName.dispose();
    _amount.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    final budgets = Provider.of<DatabaseProvider>(context).getBudgets().snapshots();
    return AddBudgetForm(budgets);
  }
  Widget AddBudgetForm(budgets) {
    return Container(
      height: MediaQuery.of(context).size.height* 0.6,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      decoration: BoxDecoration(
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
              const Text(
                "Add new Expense",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 20,),
              //drop down menu for selecting the budget
              const Text(
                "Budget",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 10,),
              StreamBuilder<QuerySnapshot>(
                stream: budgets,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Loading...");
                  }
                  return DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                    items: snapshot.data!.docs.map((DocumentSnapshot document) {
                      print(document['name']);
                      return DropdownMenuItem(
                        value: document['id'],
                        child: Text(
                          document['name'],
                          style: TextStyle(
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
              const Text(
                "Day",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
               IconButton(
                icon: Icon(Icons.calendar_today),
                tooltip: 'tap to open date picker',
                onPressed: () async{
                  selectedDate = (await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
                      lastDate: DateTime(DateTime.now().year,DateTime.now().month+1, 0),
                  ))!;
                  //print the selected date from the date picker
                }
              ,),
              SizedBox(height: 10),
              const Text(
                "Expense Name",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 10,),
              TextFormField(
                cursorColor: Colors.black,
                cursorHeight: 20,
                controller: _expenseName,
                style: TextStyle(color: Colors.black, fontFamily: "K2D"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "Enter a budget Name",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter an expense name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              const Text(
                "Amount",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 10,),
              TextFormField(
                style: TextStyle(color: Colors.black, fontFamily: "K2D"),
                cursorColor: Colors.black,
                cursorHeight: 20,
                controller: _amount,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  hintText: "Amount",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter an amount";
                  }
                  if (!RegExp(r'^\d*\.?\d*$').hasMatch(value)) {
                    return "Please enter only numbers";
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
                  color: Color(0XFFFF6B35),
                  elevation: 0,
                  onPressed: () {
                    print("pressed");
                    if (_formKey.currentState!.validate()) {
                      // Submit the form data to firestore
                      addExpense(_expenseName,_amount,selectedDate,selectedBudgetId);
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "K2D")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addExpense(TextEditingController name,TextEditingController amount,DateTime date,budgetId) async{
    //add using the budget id and the provider DatabaseProvider\
    Timestamp timestamp = Timestamp.fromDate(date);
    Expense newExpense = Expense(id:"",name: name.text,amount: double.parse(amount.text), expenseDate: timestamp, budgetId: budgetId);
    Provider.of<DatabaseProvider>(context,listen: false).addExpense(newExpense);
  }
}

