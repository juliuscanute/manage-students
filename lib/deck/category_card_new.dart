import 'package:flutter/material.dart';
import 'package:managestudents/deck/firebase_service.dart';
import 'package:managestudents/config/di.dart';

class CategoryCardNew extends StatefulWidget {
  final String parentPath;
  final List<Map<String, dynamic>> subFolders;
  final String folderId;
  final String category;
  final bool isPublic;

  CategoryCardNew({
    required this.parentPath,
    required this.subFolders,
    required this.folderId,
    required this.category,
    required this.isPublic,
  });

  @override
  _CategoryCardNewState createState() => _CategoryCardNewState();
}

class _CategoryCardNewState extends State<CategoryCardNew> {
  late FirebaseService _firebaseService;
  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    _firebaseService = getIt<FirebaseService>();
    isPublic = widget.isPublic;
  }

  Future<void> _fetchSubFolders() async {
    final nextPath = '${widget.parentPath}/subfolders';
    final subFolders = await _firebaseService.getSubFolders(nextPath);
    Navigator.pushNamed(
      context,
      "/category-screen-new",
      arguments: {
        'parentPath': nextPath,
        'subFolders': subFolders,
        'folderId': widget.folderId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(widget.category, style: const TextStyle(fontSize: 18.0)),
        onTap: () async {
          _fetchSubFolders();
        },
      ),
    );
  }
}
