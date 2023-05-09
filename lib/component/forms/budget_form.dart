import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/viewmodel/database_provider.dart';

class BudgetForm extends StatefulWidget {

  final DatabaseProvider dbProvider;

  BudgetForm({ required this.dbProvider });

  @override
  State<BudgetForm> createState() => _BudgetFormState();

}

class _BudgetFormState extends State<BudgetForm> {
  @override

  final _formKey = GlobalKey<FormState>();
  final _budgetName = TextEditingController();
  final _amount = TextEditingController();


  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _budgetName.dispose();
    _amount.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return AddBudgetForm();
  }
  Widget AddBudgetForm() {
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
                "Add new budget",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 20,),
              const Text(
                "Period",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 10,),
              TextFormField(
                textAlign: TextAlign.center,
                //READ ONLY AND WILL GET DATA FROM DATETIME
                style: TextStyle(color: Colors.white, fontFamily: "K2D", fontSize: 20,fontWeight: FontWeight.bold),
                enabled: false,
                initialValue: DateFormat.MMMM().format(DateTime.now()).toString(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  filled: true,
                  fillColor: Colors.grey[400],
                  labelStyle: TextStyle(color: Colors.white),
                ),
                readOnly: true,
              ),
              SizedBox(height: 10),
              const Text(
                "Budget Name",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 10,),
              TextFormField(
                cursorColor: Colors.black,
                cursorHeight: 20,
                controller: _budgetName,
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
                    return "Please enter a budget name";
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
                      submitBudget(_budgetName,_amount);
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


  void submitBudget(TextEditingController name, TextEditingController amount){
    DateTime budgetDate = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(budgetDate);

    Budget newBudget = Budget(name: name.text.toString(),amount: double.parse(amount.text.toString(),), budgetDate: timestamp, id: "");
    widget.dbProvider.addBudget(newBudget);

    print("FUNCTION RAN!");
  }
}

