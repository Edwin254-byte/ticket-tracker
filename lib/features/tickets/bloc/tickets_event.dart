import 'package:equatable/equatable.dart';

abstract class TicketsEvent extends Equatable {
  const TicketsEvent();

  @override
  List<Object?> get props => [];
}

class TicketsFetchRequested extends TicketsEvent {
  const TicketsFetchRequested();
}

class TicketsRefreshRequested extends TicketsEvent {
  const TicketsRefreshRequested();
}

class TicketResolveRequested extends TicketsEvent {
  final int ticketId;

  const TicketResolveRequested(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}
