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
  List<dynamic> pokemonMap = [];
  String nextURL = '';
  String prevURL = '';

  main(String url) async {
    List results = await fetchAllPokemon(url);

    dynamic pokemonData =
        await Future.wait(results.map((result) => fetchPokemon(result['url'])));

    setState(() {
      pokemonMap =
          pokemonData.map((pokemon) => PokemonMap.fromMap(pokemon)).toList();
    });
  }

  Future<dynamic> fetchAllPokemon(String url) async {
    Response response = await Dio().get(url);
    print(response);
    setState(() {
      nextURL = response.data['next'];
    });
    print(nextURL);
    return response.data['results'];
  }

  Future<dynamic> fetchPokemon(String url) async {
    Response response = await Dio().get(url);
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    main('https://pokeapi.co/api/v2/pokemon/');
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
          itemCount: pokemonMap.length,
          itemBuilder: (content, index) {
            PokemonMap pokemon = pokemonMap[index];
            return Card(
                child: Stack(children: [
              Center(child: Image.network(pokemon.frontURL)),
              Align(
                  alignment: Alignment.bottomCenter, child: Text(pokemon.name))
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

class PokemonMap {
  final String frontURL;
  final String name;

  PokemonMap({required this.frontURL, required this.name});

  factory PokemonMap.fromMap(Map<String, dynamic> map) {
    return PokemonMap(
        frontURL: map['sprites']['front_default'], name: map['name']);
  }
}
