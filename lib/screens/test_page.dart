import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/blocs/test_cubit.dart';
import 'package:managestudents/models/test_data.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    // Fetch tests when the widget is initialized
    context.read<TestCubit>().fetchTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Small screen layout
            return BlocBuilder<TestCubit, List<Test>>(
              builder: (context, tests) {
                if (tests.isEmpty) {
                  return const Center(child: Text('There are no tests.'));
                }
                return ListView.builder(
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final test = tests[index];
                    return Card(
                      child: ListTile(
                        title: Text(test.title),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            // Large screen layout
            return BlocBuilder<TestCubit, List<Test>>(
              builder: (context, tests) {
                if (tests.isEmpty) {
                  return const Center(child: Text('There are no tests.'));
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                  ),
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final test = tests[index];
                    return Card(
                      child: ListTile(
                        title: Text(test.title),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
