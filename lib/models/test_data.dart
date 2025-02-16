class Test {
  final String id;
  final String title;
  final String deckId;

  Test({
    required this.id,
    required this.title,
    required this.deckId,
  });

  factory Test.fromFirestore(String id, Map<String, dynamic> data) {
    return Test(
      id: id,
      title: data['title'],
      deckId: data['deckId'],
    );
  }
}
