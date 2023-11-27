import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PokemonHome());
  }
}

class PokemonHome extends StatefulWidget {
  const PokemonHome({super.key});

  @override
  State<PokemonHome> createState() => _PokemonHomeState();
}

class _PokemonHomeState extends State<PokemonHome> {
  List pokeList = [];
  Future<void> fetchAllPokemon() async {
    Response response = await Dio().get('https://pokeapi.co/api/v2/pokemon/');
    List results = response.data['results'];

    dynamic pokemonData =
        await Future.wait(results.map((result) => fetchPokemon(result['url'])));

    setState(() {
      pokeList = pokemonData;
      // .map((pokemon) => pokemon['sprites']['front_default'])
      // .toList();
    });
  }

  Future<dynamic> fetchPokemon(String url) async {
    Response response = await Dio().get(url);
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    fetchAllPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ポケモン図鑑',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.blue[300],
      ),
      body: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: pokeList.length,
          itemBuilder: (content, index) {
            dynamic pokemon = pokeList[index];
            print(pokeList[index].toString());
            return Card(
                child: Stack(children: [
              Center(child: Image.network(pokemon['sprites']['front_default'])),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(pokemon['name']))
            ]));
          }),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'ポケモン',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                )),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('メッセージ'),
              onTap: () {
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('プロフィール'),
              onTap: () {
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('設定'),
              onTap: () {
                setState(() {});
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_left), label: 'back'),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_circle_right),
          label: 'next',
        ),
      ]),
    );
  }
}
