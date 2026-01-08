import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../models/ticket_model.dart';

class TicketDataSource {
  final http.Client client;

  TicketDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<List<Ticket>> fetchTickets() async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.ticketsEndpoint}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Ticket.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tickets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
