import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/model/expense.dart';

class DatabaseProvider extends ChangeNotifier{
  late String uid;
  DatabaseProvider();

  CollectionReference<Map<String, dynamic>> get budgetCollection => FirebaseFirestore.instance.collection('users').doc(uid).collection('budgets');

  ///------------------------------

  Future<String> getTotalBudgetAmount(int month, int year) async {
    double totalAmount = 0.0;
    var budgets = await getBudgetsByMonthFuture(month, year);
    for (var budget in budgets) {
      totalAmount += budget.amount;
    }

    print(totalAmount);
    return totalAmount.toString();
  }

  Future<String> getTotalSpentBudgetAmount(int month, int year) async {
    double totalSpent = 0.0;

    var budgets = await getBudgetsByMonthFuture(month, year);
    for (var budget in budgets) {
      totalSpent += budget.totalSpent!;
    }

    return totalSpent.toString();
  }

  //calculate the remaining amount for all of them and return as a string, how to calculate create a variable called remainingAmount and subtract the totalSpent from the amount, if the result is negative continue, else add it
  Future<String> getRemainingBudgetAmount(int month, int year) async {
    double remainingAmount = 0.0;
    var budgets = await getBudgetsByMonthFuture(month, year);
    for (var budget in budgets) {
      if(budget.amount - budget.totalSpent! < 0){
        continue;
      }
      remainingAmount += (budget.amount - budget.totalSpent!);

    }
    return remainingAmount.toString();
  }

  //to optimize the future builder, we combine all queries into one future and return a list of strings
  Future<List<String>> getAllAttributes(int month,int year) async{
    List<String> attributes = [];
    //each function should have two params (month and year)
    attributes.add( await getRemainingBudgetAmount(month,year));
    attributes.add( await getTotalBudgetAmount(month,year));
    attributes.add( await getTotalSpentBudgetAmount(month,year));


    return attributes;
  }



  //doesnt return a stream but a future
  Future<List<Budget>> getBudgetsByMonthFuture(int month, int year) async {
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 1);
    var budgetsSnapshot = await budgetCollection
        .where('budgetDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate), isLessThan: Timestamp.fromDate(endDate))
        .get();
    var budgets = budgetsSnapshot.docs.map((doc) => Budget.fromJson(doc.data())).toList();
    return budgets;
  }

  //-------------

  //get budgets
  CollectionReference<Map<String, dynamic>> getBudgets(){
    return budgetCollection;
  }
  //make the


  //get budgets from a certain month using the month and year of the attribute "budgetDate" from each budget and return as collectionreference so that i can use in the streambuilder
  Stream<QuerySnapshot> getBudgetsByMonth(int month, int year) {
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 1);
    return budgetCollection
        .where('budgetDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate), isLessThan: Timestamp.fromDate(endDate))
        .snapshots();
  }

  //order the expenses by day then put every expense that occure in a certain day in a list and return a list of lists

  //get a budget
  Future<DocumentSnapshot<Map<String, dynamic>>> getBudget(String id) async{
    var budget = await budgetCollection.doc(id).get();
    return budget;
  }

  //create a budget
  Future<void> addBudget(Budget budget) async{
    //get the budget id
    var docRef = await budgetCollection.add(budget.toJson());
    budget.id = docRef.id;
    await docRef.update(
        {
          'id': docRef.id,
        }
    );
    notifyListeners();
  }
  //update a budget
  Future<void> updateBudget(Budget budget, String budgetId) async {
    try {
      budget.totalSpent;
      await budgetCollection.doc(budgetId).update(budget.toJson());
      print("Updated");
      notifyListeners();
    } catch (error) {
      print("Error updating budget: $error");
    }
  }
  //delete a budget
  Future<void> deleteBudget(String budgetId) async{
    //delete all the subcollections of this budget
    var expenses = await budgetCollection.doc(budgetId).collection('Expenses').get();
    for(var expense in expenses.docs){
      await budgetCollection.doc(budgetId).collection('Expenses').doc(expense.id).delete();
    }
    await budgetCollection.doc(budgetId).delete();
    print("Deleted");
    notifyListeners();
  }

  //----------------------------------------

  // CollectionReference<Map<String, dynamic>> get budgetCollection => FirebaseFirestore.instance.collection('users').doc(uid).collection('budgets');
  //get expenses on this month
  CollectionReference<Map<String, dynamic>> getBudgetExpense(String budgetId){
    //returns all expesnes from a single budget
    return budgetCollection.doc(budgetId).collection('Expenses');
  }


  Future<List<DateTime>> getAllExpensesDates(int month) async{
    List<DateTime> dates = [];
    var budgets = await budgetCollection.get();
    for(var budget in budgets.docs){
      var expenses = await getBudgetExpense(budget.id).get();
      Map<dynamic, List<QueryDocumentSnapshot<Map<String, dynamic>>>> dateGroupedCollection;
      dateGroupedCollection = groupBy(expenses.docs, (expense) => expense.data()['expenseDate'].toDate().day);
        print("budgets: ${month}/${dateGroupedCollection.keys}");
    }
    return dates;
  }


  Future<List<Map<String, dynamic>>> getAllExpenses() async{
    List<Map<String, dynamic>> expensesList = [];
    //get all budgets
    //the .get method returns a future of QuerySnapshot that contains all the documents in the collection
    var budgets = await budgetCollection.get();

    //now loop through each budget and get its expense
    for(var budget in budgets.docs){
      //get all expenses from a budget
      var expenses = await getBudgetExpense(budget.id).get();
      //loop through each expense and add it to our list
      for(var expense in expenses.docs){
        expensesList.add(expense.data());
      }
    }
    return expensesList;
  }
  //use the "getBudgetByMonth" function to return the all the expenses in that month and year
  Future<List<Map<String, dynamic>>> getExpensesByMonth(int month, int year) async{
    List<Map<String, dynamic>> expensesList = [];
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 1);
    //get all budgets from the month
    var filteredBudgets = await budgetCollection
        .where('budgetDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate), isLessThan: Timestamp.fromDate(endDate))
        .get();
    //loop through each budget and get its expenses
    for(var budget in filteredBudgets.docs){
      //get all expenses from a budget
      var expenses = await getBudgetExpense(budget.id).get();
      //loop through each expense and add it to our list
      for(var expense in expenses.docs){
        expensesList.add(expense.data());
      }
    }
    return expensesList;
  }

  //add an expense
  Future<void> addExpense(Expense expense) async{
    //make the remaining attribute of the budget the amount of the budget minus the amount of the expense
    var docRef =  await budgetCollection.doc(expense.budgetId).collection('Expenses').add(expense.toJson());
    await docRef.update(
        {
          'id': docRef.id
        }
    );
    notifyListeners();
  }
  //delete an expense
  Future<void> deleteExpense(Expense expense) async{
    await null;
  }
  //update an expense
  Future<void> updateExpense(Expense expense) async{
    await null;
  }


}