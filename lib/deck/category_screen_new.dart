import 'package:flutter/material.dart';
import 'package:managestudents/deck/category_card_new.dart';
import 'package:managestudents/deck/deck_list_item_new.dart';
import 'package:managestudents/config/di.dart';
import 'package:managestudents/deck/firebase_service.dart';

class CategoryScreenNew extends StatefulWidget {
  const CategoryScreenNew();

  @override
  _CategoryScreenNewState createState() => _CategoryScreenNewState();
}

class _CategoryScreenNewState extends State<CategoryScreenNew> {
  late FirebaseService _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = getIt<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getFoldersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No folders found'));
          }

          final folders = snapshot.data ?? [];

          return LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the number of columns based on screen width
              int crossAxisCount = constraints.maxWidth > 600
                  ? 2
                  : 1; // Example breakpoint at 600px

              // Calculate the width of each child based on the number of columns
              double width =
                  (constraints.maxWidth - (crossAxisCount - 1) * 10) /
                      crossAxisCount;

              return SingleChildScrollView(
                child: Wrap(
                  spacing: 10, // Horizontal space between items
                  runSpacing: 10, // Vertical space between items
                  children: List.generate(folders.length, (index) {
                    final folder = folders[index];
                    if (folder['type'] != 'card') {
                      return SizedBox(
                        width: width,
                        child: CategoryCardNew(
                          category: folder['id'],
                          parentPath: 'folder/${folder['id']}',
                          subFolders: folder['subFolders'] ?? [],
                          folderId: folder['id'],
                          isPublic: folder['isPublic'] ?? true,
                        ),
                      );
                    } else {
                      final leafNode = {
                        'title': folder['title'] ?? 'Untitled',
                        'deckId': folder['deckId'],
                        'videoUrl': folder['videoUrl'],
                        'mapUrl': folder['mapUrl'],
                        'type': 'card',
                        'isPublic': folder['isPublic'] ?? false,
                      };
                      return SizedBox(
                        width: width,
                        child: DeckListItemNew(deck: leafNode),
                      );
                    }
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
