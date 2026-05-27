import 'dart:convert';
import 'package:http/http.dart' as http;

class VersionApiService {
  Future<String?> checkVersion() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.2/helaruthapi/api/version.php'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['version'];
      }
    } catch (e) {
      print('Error checking version: $e');
    }
    return null;
  }
}