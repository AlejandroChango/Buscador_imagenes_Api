import 'dart:convert';
import 'package:http/http.dart' as http;

class DinosaurService {
  static const String unsplashBaseUrl = 'https://api.unsplash.com/search/photos';
  static const String unsplashAccessKey = 'yY5UkQhD7fAgNein0tXFWyXCyKTMMCcBhXlOKgTmOzo'; // Reemplaza con tu clave de acceso de Unsplash

  // Obtener imágenes de dinosaurios desde Unsplash
  static Future<List<Map<String, dynamic>>> getDinosaurImages(String query) async {
    final response = await http.get(
      Uri.parse('$unsplashBaseUrl?query=$query&per_page=5'),
      headers: {
        'Authorization': 'Client-ID $unsplashAccessKey',
      },
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<dynamic> results = body['results'];
      return results.map((item) => {
        'url': item['urls']['regular'],
        'description': item['alt_description'] ?? 'No description',
        'photographer': item['user']['name'] ?? 'Unknown',
        'photographerProfile': item['user']['links']['html'] ?? 'No profile link',
        'likes': item['likes'] ?? 0
      }).toList();
    } else {
      throw Exception('Failed to load dinosaur images');
    }
  }
}
