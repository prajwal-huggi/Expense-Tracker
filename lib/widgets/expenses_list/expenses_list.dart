import 'package:expense_tracker/component/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_items.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        onDismissed: (dicrection){
          onRemoveExpense(expenses[index]);
        },
        key: ValueKey(expenses[index].id),
        child: ExpensesItems(expenses[index]),
      ),
    );
  }
}
