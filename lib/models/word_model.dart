import 'package:helaruth/services/encryption_service.dart';

class WordModel {
  final int id;
  final String word;
  final String meanings;
  final String pronunciation;

  WordModel({
    required this.id,
    required this.word,
    required this.meanings,
    required this.pronunciation,
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'],
      word: EncryptionService.decrypt(map['word']),
      meanings: EncryptionService.decrypt(map['meanings']),
      pronunciation: map['pronunciation'] != null
          ? EncryptionService.decrypt(map['pronunciation'])
          : '',
    );
  }
}