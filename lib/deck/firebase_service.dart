import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Deck {
  final String id;
  final String title;
  final List<Map<String, dynamic>> cards;
  final List<String> tags; // Add tags field

  Deck({
    required this.id,
    required this.title,
    required this.cards,
    required this.tags, // Add tags to the constructor
  });
}

class FirebaseService {
  late FirebaseFirestore _firestore;
  late FirebaseAnalytics _analytics;

  Map<String, dynamic> _originalCardsState = <String, dynamic>{};

  final StreamController<void> _changeController =
      StreamController<void>.broadcast();

  Stream<void> get changeStream => _changeController.stream;

  FirebaseService(FirebaseFirestore firestore, FirebaseAnalytics analytics) {
    _firestore = firestore;
    _analytics = analytics;
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  void notifyListeners() {
    _changeController.add(null);
  }

  Future<void> logAnalyticsEvent(
      String eventName, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters.cast<String, Object>(),
    );
  }

  Stream<List<Map<String, dynamic>>> getFoldersStream() {
    return _firestore.collection('folder').snapshots().map((snapshot) {
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'isPublic': data['isPublic'] ?? true
        };
      }).toList();
      items.sort((a, b) => a['name'].compareTo(b['name']));
      logAnalyticsEvent(
          "getFoldersStream", {"collection": "folder", "size": items.length});
      return items;
    });
  }

// Method to read subfolders of a folder from Firestore
// /folder/{folderId}/subfolder/ - Returns subfolder in this collection
// /folder/{folderId}/subfolder/{subfolderId}/subfolder - Returns subfolder in this collection
// Input will contain the parent path with id
  Future<List<Map<String, dynamic>>> getSubFolders(String parentPath) async {
    try {
      var subFolders = <Map<String, dynamic>>[];
      var subFolderSnapshot = await _firestore.collection(parentPath).get();

      for (var subFolder in subFolderSnapshot.docs) {
        var folderData = subFolder.data();
        if (folderData['hasSubfolders'] == true) {
          subFolders.add({
            'id': subFolder.id,
            'name': folderData['name'] ?? '',
            'hasSubfolders': true,
            'isPublic': folderData['isPublic'] ?? true,
          });
        } else {
          subFolders.add({
            'id': subFolder.id,
            'name': folderData['name'] ?? '',
            'deckId': folderData['deckId'] ?? '',
            'title': folderData['title'] ?? '',
            'isPublic': folderData['isPublic'] ?? false,
            'type': 'card',
            'hasSubfolders': false,
          });
        }
      }

      logAnalyticsEvent("getSubFolders", {
        "collection": "folder",
        "parentPath": parentPath,
        "size": subFolders.length
      });

      // Ensure all names and titles are strings and handle null values
      subFolders.sort((a, b) {
        bool hasADeckId = a.containsKey('deckId') && a['deckId'] != null;
        bool hasBDeckId = b.containsKey('deckId') && b['deckId'] != null;

        if (hasADeckId && hasBDeckId) {
          String titleA = (a['title'] ?? '').toString().toLowerCase();
          String titleB = (b['title'] ?? '').toString().toLowerCase();
          return titleA.compareTo(titleB);
        } else if (hasADeckId && !hasBDeckId) {
          return 1;
        } else if (!hasADeckId && hasBDeckId) {
          return -1;
        } else {
          String idA = (a['id'] ?? '').toString().toLowerCase();
          String idB = (b['id'] ?? '').toString().toLowerCase();
          return idA.compareTo(idB);
        }
      });

      return subFolders;
    } catch (error) {
      print('Error reading subfolders from Firestore: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> getDeckData(String deckId) async {
    try {
      var deckRef = _firestore.collection('decks').doc(deckId);
      var deckSnapshot = await deckRef.get();
      if (!deckSnapshot.exists) {
        throw Exception("Deck not found");
      }
      var deckData = deckSnapshot.data()!;
      deckData['id'] = deckSnapshot.id;

      // Fetch the cards ordered by 'position'
      var cardsSnapshot =
          await deckRef.collection('cards').orderBy('position').get();
      var cards = cardsSnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      deckData['cards'] = cards;
      _originalCardsState = deckData;
      logAnalyticsEvent(
          "getDeckData", {"collection": "decks", "deckId": deckId});
      return deckData;
    } catch (error) {
      throw Exception("Error fetching deck data: $error");
    }
  }
}
