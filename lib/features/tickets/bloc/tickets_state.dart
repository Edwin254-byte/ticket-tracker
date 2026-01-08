import 'package:equatable/equatable.dart';
import '../../../data/models/ticket_model.dart';

abstract class TicketsState extends Equatable {
  const TicketsState();

  @override
  List<Object?> get props => [];
}

class TicketsInitial extends TicketsState {
  const TicketsInitial();
}

class TicketsLoading extends TicketsState {
  const TicketsLoading();
}

class TicketsLoaded extends TicketsState {
  final List<Ticket> tickets;

  const TicketsLoaded(this.tickets);

  @override
  List<Object?> get props => [tickets];
}

class TicketsError extends TicketsState {
  final String message;

  const TicketsError(this.message);

  @override
  List<Object?> get props => [message];
}

class TicketResolving extends TicketsState {
  final int ticketId;

  const TicketResolving(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class TicketResolved extends TicketsState {
  final int ticketId;
  final List<Ticket> tickets;

  const TicketResolved(this.ticketId, this.tickets);

  @override
  List<Object?> get props => [ticketId, tickets];
}
