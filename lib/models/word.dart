class Word {
  int? id;
  String word;
  String translation;
  int groupId;

  Word({
    this.id,
    required this.word,
    required this.translation,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'translation': translation,
      'groupId': groupId,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      word: map['word'],
      translation: map['translation'],
      groupId: map['groupId'],
    );
  }
}
