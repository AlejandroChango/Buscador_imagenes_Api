import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './models/dinosaur_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dinosaur Images App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DinosaurPage(),
    );
  }
}

class DinosaurPage extends StatefulWidget {
  @override
  _DinosaurPageState createState() => _DinosaurPageState();
}

class _DinosaurPageState extends State<DinosaurPage> {
  List<Map<String, dynamic>>? dinoImagesData;
  TextEditingController searchController = TextEditingController();

  Future<void> searchDinosaurImages(String query) async {
    try {
      final data = await DinosaurService.getDinosaurImages(query);
      setState(() {
        dinoImagesData = data;
      });
    } catch (e) {
      setState(() {
        dinoImagesData = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscador de Imagenes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscador de imagenes',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchDinosaurImages(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: dinoImagesData == null
                ? Center(child: Text('Buscador de Imagenes'))
                : dinoImagesData!.isEmpty
                    ? Center(child: Text('No se encontro ninguna imagen'))
                    : ListView.builder(
                        itemCount: dinoImagesData!.length,
                        itemBuilder: (context, index) {
                          final imageData = dinoImagesData![index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(imageData['url']),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Text('Descripción:'),
                                      Text(
                                        imageData['description'],
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text('Fotografo: ${imageData['photographer']}'),
                                      Text('Likes: ${imageData['likes']}'),
                                      SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () {
                                          // Abre el perfil del fotógrafo en el navegador
                                          _launchURL(imageData['photographerProfile']);
                                        },
                                        child: Text(
                                          'Profile: ${imageData['photographerProfile']}',
                                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

 
   void _launchURL(String url) {
    final Uri uri = Uri.parse(url);
    // Usa url_launcher para abrir el enlace en un navegador
    // Añade `url_launcher` como dependencia en `pubspec.yaml`
    // import 'package:url_launcher/url_launcher.dart';
    launchUrl(uri);
  }
}
