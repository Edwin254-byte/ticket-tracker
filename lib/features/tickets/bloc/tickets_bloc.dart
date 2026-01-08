import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/ticket_repository.dart';
import 'tickets_event.dart';
import 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final TicketRepository ticketRepository;

  TicketsBloc({required this.ticketRepository}) : super(const TicketsInitial()) {
    on<TicketsFetchRequested>(_onFetchRequested);
    on<TicketsRefreshRequested>(_onRefreshRequested);
    on<TicketResolveRequested>(_onResolveRequested);
  }

  Future<void> _onFetchRequested(
    TicketsFetchRequested event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());
    try {
      final tickets = await ticketRepository.getTickets();
      emit(TicketsLoaded(tickets));
    } catch (e) {
      emit(TicketsError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRefreshRequested(
    TicketsRefreshRequested event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      final tickets = await ticketRepository.getTickets();
      emit(TicketsLoaded(tickets));
    } catch (e) {
      emit(TicketsError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onResolveRequested(
    TicketResolveRequested event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      await ticketRepository.markTicketAsResolved(event.ticketId);
      final tickets = await ticketRepository.getTickets();
      emit(TicketResolved(event.ticketId, tickets));
    } catch (e) {
      emit(TicketsError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
