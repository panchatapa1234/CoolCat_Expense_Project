import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intern1/models/expense_item.dart';

class HiveDataBase {
  final myBox = Hive.box("Expense_Database");

  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];
    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    myBox.put("All Expenses", allExpensesFormatted);
  }

  List<ExpenseItem> readData() {
    List savedExpenses = myBox.get("All Expenses") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseItem expense =
          ExpenseItem(name: name, amount: amount, dateTime: dateTime);
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
