import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/blocs/class_cubit.dart';
import 'package:managestudents/blocs/student_cubit.dart';
import 'package:managestudents/blocs/test_cubit.dart';
import 'package:managestudents/deck/category_screen_new.dart';
import 'package:managestudents/models/class_data.dart';
import 'package:managestudents/models/student_data.dart';
import 'package:managestudents/screens/test_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFabOpen = false;

  @override
  void initState() {
    super.initState();
    // Four tabs: index 0 for Students, index 1 for Classes, index 2 for Categories, and index 3 for Tests.
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Students'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Students'),
            Tab(text: 'Classes'),
            Tab(text: 'Tests'),
            Tab(text: 'Decks'),
            // Add the new tab here
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Students Tab
          BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.students.isEmpty) {
                return const Center(child: Text('There are no students.'));
              }
              return _buildGrid(context, state.students,
                  (student) => _buildStudentCard(student));
            },
          ),
          // Classes Tab
          BlocBuilder<ClassCubit, ClassState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.classes.isEmpty) {
                return const Center(
                  child: Text('There are no classes.'),
                );
              }
              return _buildGrid(context, state.classes,
                  (classItem) => _buildClassCard(classItem));
            },
          ),
          // Tests Tab
          TestPage(),
          // Categories Tab
          CategoryScreenNew(),
        ],
      ),
      floatingActionButton: _buildCollapsibleFab(),
    );
  }

  Widget _buildGrid<T>(
      BuildContext context, List<T> items, Widget Function(T) itemBuilder) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        final crossAxisCount = isDesktop ? 4 : 1;
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: isDesktop ? 3 : 2,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemBuilder(items[index]);
          },
        );
      },
    );
  }

  Widget _buildStudentCard(Student student) {
    return Card(
      child: ListTile(
        title: Text(student.name),
        subtitle: Text('Code: ${student.code}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: student.code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code copied to clipboard')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/student',
                  arguments: student,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<StudentCubit>().deleteStudent(student.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(Class classItem) {
    return Card(
      child: ListTile(
        title: Text(classItem.name),
        subtitle: Text('Students: ${classItem.studentIds.length}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/class',
                  arguments: classItem,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<ClassCubit>().deleteClass(classItem.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the collapsible FAB that shows two mini-FABs when expanded.
  Widget _buildCollapsibleFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isFabOpen) ...[
          // Mini FAB for adding a student
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: FloatingActionButton.small(
              heroTag: 'addStudent',
              onPressed: () {
                // Switch to the Students tab and navigate to the Create Student page.
                _tabController.animateTo(0);
                Navigator.of(context).pushNamed('/student');
                setState(() {
                  _isFabOpen = false;
                });
              },
              child: const Icon(Icons.person_add),
            ),
          ),
          // Mini FAB for adding a class
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: FloatingActionButton.small(
              heroTag: 'addClass',
              onPressed: () {
                // Switch to the Classes tab and navigate to the Create Class page.
                _tabController.animateTo(1);
                Navigator.of(context).pushNamed('/class');
                setState(() {
                  _isFabOpen = false;
                });
              },
              child: const Icon(Icons.class_),
            ),
          ),
        ],
        // Main FAB that toggles the expansion
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _isFabOpen = !_isFabOpen;
            });
          },
          child: Icon(_isFabOpen ? Icons.close : Icons.add),
        ),
      ],
    );
  }
}
