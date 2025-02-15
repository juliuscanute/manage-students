class Test {
  final String id;
  final String teacherId;
  final String classId;
  final String title;
  final String deckId;

  Test({
    required this.id,
    required this.teacherId,
    required this.classId,
    required this.title,
    required this.deckId,
  });

  factory Test.fromFirestore(String id, Map<String, dynamic> data) {
    return Test(
      id: id,
      teacherId: data['teacherId'],
      classId: data['classId'],
      title: data['title'],
      deckId: data['deckId'],
    );
  }
}
