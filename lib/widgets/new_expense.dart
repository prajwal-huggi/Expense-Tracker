import 'dart:ffi';
import 'dart:io';

import 'package:expense_tracker/component/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

final formatter = DateFormat('dd-MM-yyyy');

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  Logger logger = Logger();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  
  void _showDialog(){
    if(Platform.isIOS){
      showCupertinoDialog(context: context, builder: (ctx)=> CupertinoAlertDialog(
        title: const Text('Invalid Input'),
        content: const Text('Please make sure input has valid title, amount, date and category'),
        actions:[
          TextButton(
            onPressed:(){Navigator.pop(ctx);},
            child: const Text('Okay'),
          ),
        ],
      ));
    }
    else{
      showDialog(context: context, builder: (ctx)=> AlertDialog(
        title: const Text('Invalid Input'),
        content: const Text('Please make sure input has valid title, amount, date and category'),
        actions:[
          TextButton(
            onPressed:(){Navigator.pop(ctx);},
            child: const Text('Okay'),
          ),
        ],
      ));
    }
  }

  void _submitExpense(){
    final double? enteredAmount= double.tryParse(_amountController.text);
    // final bool amountValid= (enteredAmount== null? false: true)&& (enteredAmount<0? false: true);
    final bool amountIsInvalid= enteredAmount== null || enteredAmount< 0;

    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate== null){
      _showDialog();
      return;
    }
    widget.onAddExpense(Expense(title: _titleController.text, amount: enteredAmount, date: _selectedDate!, category: _selectedCategory));
    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime firstdate = DateTime(now.year - 1, now.month, now.day);
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstdate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace= MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, contraints){
      final width= contraints.maxWidth;
      return Padding(
      padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace+16),
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: [
            if(width >= 500)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                Expanded(
                  child: TextField( 
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text('Name'),),),
                ),
                const SizedBox(width: 24),
                Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefix: Text('\$ '),
                        label: Text('Amount'),
                      ),
                    ),
                  ),
              ],)
            else 
            TextField( 
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name'))),
                const SizedBox(width: 24),
            if(width>= 500)
              Row(children:[
                DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  logger.i(value);
                  setState(
                    () {
                      if (value == null) {
                        return;
                      }
                      _selectedCategory = value;
                    },
                  );
                },
              ),
              const SizedBox(width: 24),
              Expanded(
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(
                        _selectedDate == null
                            ? 'No date selected yet'
                            : formatter.format(_selectedDate!),
                      ),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ]),
                  ),
              ])
            else
            Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefix: Text('\$ '),
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(
                        _selectedDate == null
                            ? 'No date selected yet'
                            : formatter.format(_selectedDate!),
                      ),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ]),
                  ),
                ]),
          
                const SizedBox(height: 16),
            if(width>= 500)
              Row(children:[
                const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpense,
                child: const Text('Save Expense'),
              ),
              ])
            else
            Row(children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  logger.i(value);
                  setState(
                    () {
                      if (value == null) {
                        return;
                      }
                      _selectedCategory = value;
                    },
                  );
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpense,
                child: const Text('Save Expense'),
              ),
            ]),
          ]),
        ),
      ),
    );
    });
    
  }
}
