import 'package:flutter/material.dart';
import 'package:hw4/constants.dart';
import '../word_definitions/word_definition.dart';
import 'dart:convert';
import '../favorites/favorites_screen.dart';
import 'package:hw4/screens/account/account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  late List<String> _words;
  late List<String> _filteredWords;
  int _currentIndex = 0;

  Future<List<String>> _loadWordsFromFile(BuildContext context) async {
    String data =
        await DefaultAssetBundle.of(context).loadString('words/words.txt');
    List<String> words = LineSplitter().convert(data);
    return words;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _words = [];
    _filteredWords = [];
    _loadWords();
  }

  void _loadWords() async {
    List<String> words = await _loadWordsFromFile(context);
    setState(() {
      _words = words.where((word) => !word.startsWith('#')).toList();
      _filteredWords = _words;
    });
  }

  void _searchWords(String keyword) {
    setState(() {
      _filteredWords = _words
          .where((word) => word.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary App'),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            onPressed: () {
              _searchController.clear();
              _searchWords('');
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchWords,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredWords.isEmpty
                ? Center(child: Text('No words available'))
                : ListView.builder(
                    itemCount: _filteredWords.length,
                    itemBuilder: (context, index) {
                      final word = _filteredWords[index];
                      return Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ListTile(
                          title: Text(
                            word,
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WordDefinitionPage(word: word),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: kPrimaryColor,
        backgroundColor: Colors.white,
        iconSize: 20,
        unselectedItemColor: Colors.grey.withOpacity(0.7),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
