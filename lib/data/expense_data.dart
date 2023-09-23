import 'package:flutter/material.dart';
import 'package:intern1/data/hive_database.dart';
import 'package:intern1/datetime/date_time_helper.dart';
import 'package:intern1/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  List<ExpenseItem> overallExpenseList = [];
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  final db = HiveDataBase();

  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  void addNewTransaction(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  String getDayName(DateTime date) {
    switch (DateTime.daysPerWeek) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thurs';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  DateTime startofWeekDate() {
    DateTime? startofWeek;

    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startofWeek = today.subtract(Duration(days: i));
      }
    }
    return startofWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String data = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);
      if (dailyExpenseSummary.containsKey(data)) {
        double currentAmount = dailyExpenseSummary[data]!;
        currentAmount += amount;
        dailyExpenseSummary[data] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({data: amount});
      }
    }
    return dailyExpenseSummary;
  }
}
