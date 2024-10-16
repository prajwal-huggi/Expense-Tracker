import 'package:expense_tracker/component/expense.dart';
import 'package:flutter/material.dart';

class ExpensesItems extends StatelessWidget {
  const ExpensesItems(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(expense.title),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('\$ ${expense.amount.toStringAsFixed(2)}'),
                Row(
                  children:[
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 5),
                    Text(expense.formatDate),
                    // Text(expense.category.toString()),
                  ]
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }
}