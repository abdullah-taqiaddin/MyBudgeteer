import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:testapp/model/budget.dart';

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
    var x = await FirebaseFirestore.instance.collection('users').doc(uid).collection('budgets').doc(id).get();
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
  //get expenses
  CollectionReference<Map<String, dynamic>> getExpenses(String budgetId){
    return budgetCollection.doc(budgetId).collection('expense');
  }
  //add an expense
  //delete an expense
  //update an expense


}