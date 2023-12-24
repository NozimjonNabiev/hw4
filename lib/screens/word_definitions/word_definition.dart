import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hw4/constants.dart';
import '../../models/word.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hw4/database/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:hw4/providers/user_data_provider.dart';

class WordDefinitionPage extends StatefulWidget {
  final String word;

  const WordDefinitionPage({required this.word});

  @override
  _WordDefinitionPageState createState() => _WordDefinitionPageState();
}

class _WordDefinitionPageState extends State<WordDefinitionPage> {
  late Future<Word> _wordDefinitions;
  late AudioPlayer player;
  bool isPlaying = false;
  bool isFavorite = false;
  late int userId;

  Future<void> _playAudio(String audioUrl) async {
    if (audioUrl.isNotEmpty) {
      try {
        await player.setUrl(audioUrl);
        await player.play();
        setState(() {
          isPlaying = true;
        });
      } catch (error) {
        print('Error playing audio: $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _wordDefinitions = fetchWordDefinitions(widget.word);
    player = AudioPlayer();
    checkIfFavorite();
    userId = Provider.of<UserDataProvider>(context, listen: false).userId ?? 0;
  }

  void onPressedToggleFavorite() async {
    await toggleFavoriteStatus(userId);
  }

  Future<void> checkIfFavorite() async {
    bool favoriteStatus = await DBHelper.isWordFavorite(userId, widget.word);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  Future<void> toggleFavoriteStatus(int userId) async {
    if (isFavorite) {
      await DBHelper.deleteFavorite(userId, widget.word);
      setState(() {
        isFavorite = false;
      });
    } else {
      await DBHelper.insertFavorite(userId, widget.word);
      setState(() {
        isFavorite = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<Word> fetchWordDefinitions(String word) async {
    final response = await http.get(
      Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty) {
        return Word.fromJson(jsonResponse[0]);
      }
    }

    return Word(
      word: word,
      phonetic: '',
      phonetics: [],
      meanings: [],
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Definitions'),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: onPressedToggleFavorite),
        ],
      ),
      body: FutureBuilder<Word>(
        future: _wordDefinitions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.meanings.isEmpty) {
            return Center(child: Text('No definitions found'));
          } else {
            final word = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${word.word}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  if (word.phonetics.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final audioUrl = word.phonetics.first.audio;
                          _playAudio(audioUrl);
                        },
                        icon: Icon(Icons.volume_up),
                        label: Text('Listen Pronunciation'),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Meanings:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: word.meanings.map((meaning) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: meaning.definitions.map((definition) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ${definition.definition}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
