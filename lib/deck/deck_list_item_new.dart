import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/blocs/class_cubit.dart';
import 'package:managestudents/blocs/test_cubit.dart';

class DeckListItemNew extends StatefulWidget {
  final Map<String, dynamic> deck;

  DeckListItemNew({required this.deck});

  @override
  _DeckListItemNewState createState() => _DeckListItemNewState();
}

class _DeckListItemNewState extends State<DeckListItemNew> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        title: Text(widget.deck['title'],
            style: Theme.of(context).textTheme.titleLarge),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _showAddTestDialog(context),
        ),
      ),
    );
  }

  void _showAddTestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => context.read<ClassCubit>(),
          child: AddTestDialog(
              deckTitle: widget.deck['title'], deckId: widget.deck['deckId']),
        );
      },
    );
  }
}

class AddTestDialog extends StatefulWidget {
  final String deckTitle;
  final String deckId;

  AddTestDialog({required this.deckTitle, required this.deckId});

  @override
  _AddTestDialogState createState() => _AddTestDialogState();
}

class _AddTestDialogState extends State<AddTestDialog> {
  String? _selectedClassId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Test'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              text: 'Add ',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: widget.deckTitle,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' to the selected class for examination'),
              ],
            ),
          ),
          SizedBox(height: 16),
          BlocBuilder<ClassCubit, ClassState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const CircularProgressIndicator();
              }
              return DropdownButton<String>(
                hint: Text('Select Class'),
                value: _selectedClassId,
                items: state.classes.map((classData) {
                  return DropdownMenuItem<String>(
                    value: classData.id,
                    child: Text(classData.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClassId = value;
                  });
                },
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_selectedClassId != null) {
              context
                  .read<TestCubit>()
                  .addTest(_selectedClassId!, widget.deckTitle, widget.deckId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Test added successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
