import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testapp/model/budget.dart';

class DatabaseProvider{

  final String uid;

  DatabaseProvider({
    required this.uid
  });

  //now we have a list of the budgets
  CollectionReference<Map<String, dynamic>> get budgetCollection => FirebaseFirestore.instance.collection('users').doc(uid).collection('budgets');

  //get budgets
  CollectionReference<Map<String, dynamic>> GetBudgets(){
    return budgetCollection;
  }
  //create a budget
  Future<void> addBudget(Budget budget) async{
    //get the budget id
    budget.id = budgetCollection.doc().id;
    await budgetCollection.doc(budget.id).set(budget.toJson());
  }
  //update a budget
  Future<void> updateBudget(Budget budget, String budgetId) async{
    await budgetCollection.doc(budget.id).update(budget.toJson());
  }
  //delete a budget
  Future<void> deleteBudget(String budgetId) async{
    await budgetCollection.doc(budgetId).delete();
  }
  //get expenses
  CollectionReference<Map<String, dynamic>> getExpenses(String budgetId){
    return budgetCollection.doc(budgetId).collection('expense');
  }
  //add an expense
  //delete an expense
  //update an expense


}