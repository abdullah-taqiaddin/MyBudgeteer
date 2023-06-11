// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, annotate_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/viewmodel/database_provider.dart';
import 'package:testapp/viewmodel/date_provider.dart';

import 'package:testapp/viewmodel/localization.dart';

import '../../view/budget_page.dart';

//i guess we need to create a flag to distinguish the update from the create


class BudgetForm extends StatefulWidget {

  //if its an update, we provider this
  final Budget? initialBudget;

  BudgetForm({Key? key, this.initialBudget}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    // fill form fields with initial budget data if provided
    if (widget.initialBudget != null) {
      _budgetName.text = widget.initialBudget!.name;
      _amount.text = widget.initialBudget!.amount.toString();
    }
  }

  Widget build(BuildContext context) {
    return AddBudgetForm();
  }
  Widget AddBudgetForm() {
    print("year: ${Provider.of<DateProvider>(context).year}");

    int month = Provider.of<DateProvider>(context).month +1;

    return Container(
      height: MediaQuery.of(context).size.height* 0.7,
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
                "${translation(context).addNewBudget}",
                style: TextStyle(
                  color: isDark?Colors.white:Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "K2D"),
              ),
              SizedBox(height: 20,),
              Text(
                "${translation(context).period}",
                style: TextStyle(
                    color: isDark?Colors.white:Colors.black,
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
                initialValue: DateFormat.MMMM().format(DateTime(0,month)).toString(),
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
              Text(
                "${translation(context).budgetName}",
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
                controller: _budgetName,
                style: TextStyle(color: Colors.black, fontFamily: "K2D"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: isDark?Colors.white:Colors.black,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: isDark?Colors.white:Colors.black,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "${translation(context).enterBudgetName}",
                  hintStyle: TextStyle(color: isDark?Colors.white60:Colors.grey,),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "${translation(context).pleaseEnterBudget}";
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
                style: TextStyle(color: Colors.black, fontFamily: "K2D"),
                cursorColor: isDark?Colors.white:Colors.black,
                cursorHeight: 20,
                controller: _amount,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: isDark?Colors.white:Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: isDark?Colors.white:Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  hintText: "${translation(context).amount}",
                  hintStyle: TextStyle(color: isDark?Colors.white60:Colors.grey,),
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
                      if(widget.initialBudget == null){
                        submitBudget(_budgetName,_amount);
                      }
                      else{
                        submitUpdate(_budgetName, _amount, widget.initialBudget!.id , widget.initialBudget!.budgetDate,widget.initialBudget!);
                      }
                      Navigator.pop(context);

                    }
                  },
                  child: Text( (widget.initialBudget == null)? "${translation(context).add}": "${translation(context).update}",
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
    DateTime budgetDate = DateTime(Provider.of<DateProvider>(context, listen: false).year, Provider.of<DateProvider>(context, listen: false).month +1);
    Timestamp timestamp = Timestamp.fromDate(budgetDate);
    Budget newBudget = Budget(name: name.text.toString(),amount: double.parse(amount.text.toString(),), budgetDate: timestamp, id: "", totalSpent: 0.0);
    Provider.of<DatabaseProvider>(context, listen: false).addBudget(newBudget);
  }

  void submitUpdate(TextEditingController name, TextEditingController amount , String id, Timestamp date, Budget budget){
    Budget newBudget = Budget(name: name.text.toString(),amount: double.parse(amount.text.toString(),), budgetDate: date, id: widget.initialBudget!.id, totalSpent: budget.totalSpent);
    Provider.of<DatabaseProvider>(context, listen: false).updateBudget(newBudget, id);
  }

}

