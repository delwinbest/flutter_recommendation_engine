import 'package:flutter_recommendation_engine/components/film_cell.dart';
import 'package:flutter_recommendation_engine/main.dart';
import 'package:flutter_recommendation_engine/models/film.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final filmsFuture = supabase
      .from('films')
      .select()
      .withConverter<List<Film>>((data) => data.map(Film.fromJson).toList());

// .select<List<Map<String, dynamic>>>()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Films'),
      ),
      body: FutureBuilder(
          future: filmsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final films = snapshot.data!;
            return ListView.builder(
              itemBuilder: (context, index) {
                final film = films[index];
                return FilmCell(film: film);
              },
              itemCount: films.length,
            );
          }),
    );
  }
}
