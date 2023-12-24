class Word {
  final String word;
  final String phonetic;
  final List<PhoneticInfo> phonetics;
  final List<Meaning> meanings;

  Word({
    required this.word,
    required this.phonetic,
    required this.phonetics,
    required this.meanings,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    final List<dynamic> phoneticsList = json['phonetics'] ?? [];
    final List<dynamic> meaningsList = json['meanings'] ?? [];

    final List<PhoneticInfo> parsedPhonetics = phoneticsList
        .map((phonetic) => PhoneticInfo.fromJson(phonetic))
        .toList();

    final List<Meaning> parsedMeanings =
        meaningsList.map((meaning) => Meaning.fromJson(meaning)).toList();

    return Word(
      word: json['word'] ?? '',
      phonetic: json['phonetic'] ?? '',
      phonetics: parsedPhonetics,
      meanings: parsedMeanings,
    );
  }
}

class PhoneticInfo {
  final String text;
  final String audio;
  final String sourceUrl;

  PhoneticInfo({
    required this.text,
    required this.audio,
    required this.sourceUrl,
  });

  factory PhoneticInfo.fromJson(Map<String, dynamic> json) {
    return PhoneticInfo(
      text: json['text'] ?? '',
      audio: json['audio'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    final List<dynamic> definitionsList = json['definitions'] ?? [];
    final List<String> synonymsList = json['synonyms'] != null
        ? List<String>.from(json['synonyms'] as List<dynamic>)
        : [];
    final List<String> antonymsList = json['antonyms'] != null
        ? List<String>.from(json['antonyms'] as List<dynamic>)
        : [];

    final List<Definition> parsedDefinitions =
        definitionsList.map((def) => Definition.fromJson(def)).toList();

    return Meaning(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions: parsedDefinitions,
      synonyms: synonymsList,
      antonyms: antonymsList,
    );
  }
}

class Definition {
  final String definition;
  final List<String> synonyms;
  final String example;
  final String audioUrl;

  Definition({
    required this.definition,
    required this.synonyms,
    required this.example,
    required this.audioUrl,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    final List<dynamic> synonymsList = json['synonyms'] ?? [];
    final List<String> parsedSynonyms = List<String>.from(synonymsList);

    return Definition(
      definition: json['definition'] ?? '',
      synonyms: parsedSynonyms,
      example: json['example'] ?? '',
      audioUrl: json['audio'] ?? '',
    );
  }
}
