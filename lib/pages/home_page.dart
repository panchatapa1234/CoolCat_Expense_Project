import 'package:flutter/material.dart';
import 'package:intern1/components/expense_summary.dart';
import 'package:intern1/components/expense_title.dart';
import 'package:intern1/data/expense_data.dart';
import 'package:intern1/models/expense_item.dart';
import 'package:provider/provider.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add your Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newExpenseNameController,
                  ),
                  TextField(
                    controller: newExpenseAmountController,
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: Text('Save'),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: Text('Cancel'),
                ),
              ],
            ));
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );
    Provider.of<ExpenseData>(context, listen: false)
        .addNewTransaction(newExpense);

    Navigator.pop(context);
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: Color.fromARGB(255, 245, 121, 195),
              floatingActionButton: FloatingActionButton(
                onPressed: addNewExpense,
                backgroundColor: Color.fromARGB(255, 14, 25, 44),
                child: Icon(Icons.add),
              ),
              body: ListView(
                children: [
                  ExpenseSummary(
                    startOfWeek: value.startofWeekDate(),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getAllExpenseList().length,
                    itemBuilder: (context, index) => ExpenseTile(
                        name: value.getAllExpenseList()[index].name,
                        amount: value.getAllExpenseList()[index].amount,
                        dateTime: value.getAllExpenseList()[index].dateTime),
                  )
                ],
              ),
            ));
  }
}
