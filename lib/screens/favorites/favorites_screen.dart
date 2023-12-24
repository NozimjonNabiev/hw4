import 'package:flutter/material.dart';
import 'package:hw4/constants.dart';
import 'package:provider/provider.dart';
import 'package:hw4/providers/user_data_provider.dart';
import '../word_definitions/word_definition.dart';
import 'package:hw4/database/db_helper.dart';
import 'package:hw4/models/favorite.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final userId = userDataProvider.userId;

    Future<List<Favorite>> getFavorites() async {
      if (userId != null) {
        return await DBHelper.getFavorites(userId);
      }
      return [];
    }

    Future<void> toggleFavorite(int userId, String word) async {
      final isFavorite = await DBHelper.isWordFavorite(userId, word);
      if (isFavorite) {
        await DBHelper.deleteFavorite(userId, word);
      } else {
        await DBHelper.insertFavorite(userId, word);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: kPrimaryColor,
      ),
      body: FutureBuilder<List<Favorite>>(
        future: getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final word = favorites[index].word;
                return ListTile(
                  title: Text(
                    word,
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      toggleFavorite(userId!, word);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordDefinitionPage(word: word),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
