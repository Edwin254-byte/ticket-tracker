import '../datasources/ticket_datasource.dart';
import '../models/ticket_model.dart';
import '../../core/storage/local_storage_service.dart';

class TicketRepository {
  final TicketDataSource dataSource;
  final LocalStorageService storageService;

  TicketRepository({
    required this.dataSource,
    required this.storageService,
  });

  Future<List<Ticket>> getTickets() async {
    final tickets = await dataSource.fetchTickets();
    final resolvedTickets = storageService.getResolvedTickets();
    
    // Mark tickets as resolved based on local storage
    return tickets.map((ticket) {
      return ticket.copyWith(
        isResolved: resolvedTickets.contains(ticket.id),
      );
    }).toList();
  }

  Future<Ticket?> getTicketById(int id) async {
    final tickets = await getTickets();
    try {
      return tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> markTicketAsResolved(int ticketId) async {
    await storageService.addResolvedTicket(ticketId);
  }

  bool isTicketResolved(int ticketId) {
    return storageService.isTicketResolved(ticketId);
  }
}
