import 'package:flutter/foundation.dart';

import '../model/ticket.dart';
import '../service/api_client.dart';

class TicketController extends ChangeNotifier {
  List<Ticket> tickets = [];

  Future<void> loadTickets() async {
    // TODO: Fehlerbehandlung, Ladezustand
    final data = await ApiClient.instance.get('/tickets') as List;
    tickets = data.map((e) => Ticket.fromJson(e as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  Future<void> submitTicket(String subject, String description) async {
    // TODO: Validierung, Raum und Priorität mitschicken
    await ApiClient.instance.post('/tickets', {'subject': subject, 'description': description});
    await loadTickets();
  }
}
