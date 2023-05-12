import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:testapp/model/budget.dart';
import 'package:testapp/model/expense.dart';

class DatabaseProvider extends ChangeNotifier{
  late String uid;
  DatabaseProvider();

  CollectionReference<Map<String, dynamic>> get budgetCollection => FirebaseFirestore.instance.collection('users').doc(uid).collection('budgets');

  Future<String> getTotalBudgetAmount() async {
    double totalAmount = 0;
    var budgetsSnapshot = await budgetCollection.get();
    var budgets = budgetsSnapshot.docs.map((doc) => Budget.fromJson(doc.data())).toList();

    for (var budget in budgets) {
      totalAmount += budget.amount;
    }

    print(totalAmount);
    return totalAmount.toString();
  }
  //get budgets
  CollectionReference<Map<String, dynamic>> getBudgets(){
    return budgetCollection;
  }
  //get budget
  void getBudget(String id) async{
    var x = await budgetCollection.doc(id).get();
    print(x.data());
  }
  Future<List<Map<String, dynamic>>> getListBudgets() async {
    var snapshot = await budgetCollection.get();
    var budgets = snapshot.docs.map((doc) => doc.data()).toList();
    return budgets;
  }
  //create a budget
  Future<void> addBudget(Budget budget) async{
    //get the budget id
    var docRef = await budgetCollection.add(budget.toJson());
    budget.id = docRef.id;
    await docRef.update(
        {
          'id': docRef.id
        }
    );
    notifyListeners();
  }
  //update a budget
  Future<void> updateBudget(Budget budget, String budgetId) async {
    try {
      await budgetCollection.doc(budgetId).update(budget.toJson());
      print("Updated");
      notifyListeners();
    } catch (error) {
      print("Error updating budget: $error");
    }
  }
  //delete a budget
  Future<void> deleteBudget(String budgetId) async{
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

  //get expense from a single budget
  Future<List<Map<String, dynamic>>> getExpenses(String budgetId) async{
    List<Map<String, dynamic>> expensesList = [];
    var expenses = await getBudgetExpense(budgetId).get();
    for(var expense in expenses.docs){
      expensesList.add(expense.data());
    }
    return expensesList;
  }

  //add an expense
  Future<void> addExpense(Expense expense) async{
    //add an expense to the expense collection of a budget using the budget id
    print("Adding expense");
    await budgetCollection.doc(expense.budgetId).collection('Expenses').add(expense.toJson());
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