import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/tickets_bloc.dart';
import '../bloc/tickets_event.dart';
import '../bloc/tickets_state.dart';
import '../widgets/ticket_card.dart';
import '../../../core/constants/app_constants.dart';

class TicketsListPage extends StatefulWidget {
  const TicketsListPage({super.key});

  @override
  State<TicketsListPage> createState() => _TicketsListPageState();
}

class _TicketsListPageState extends State<TicketsListPage> {
  String _filter = 'all'; // all, active, resolved

  @override
  void initState() {
    super.initState();
    context.read<TicketsBloc>().add(const TicketsFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Tickets')),
              const PopupMenuItem(value: 'active', child: Text('Active Only')),
              const PopupMenuItem(
                value: 'resolved',
                child: Text('Resolved Only'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<TicketsBloc, TicketsState>(
        listener: (context, state) {
          if (state is TicketResolved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(AppConstants.ticketResolvedMessage),
                backgroundColor: colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TicketsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TicketsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<TicketsBloc>().add(
                        const TicketsFetchRequested(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TicketsLoaded || state is TicketResolved) {
            final tickets = state is TicketsLoaded
                ? state.tickets
                : (state as TicketResolved).tickets;

            // Filter tickets
            final filteredTickets = tickets.where((ticket) {
              if (_filter == 'active') return !ticket.isResolved;
              if (_filter == 'resolved') return ticket.isResolved;
              return true;
            }).toList();

            if (filteredTickets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _filter == 'all'
                          ? 'No tickets found'
                          : 'No $_filter tickets',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TicketsBloc>().add(
                  const TicketsRefreshRequested(),
                );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredTickets.length,
                itemBuilder: (context, index) {
                  final ticket = filteredTickets[index];
                  return Hero(
                    tag: 'ticket-${ticket.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: TicketCard(
                        ticket: ticket,
                        onTap: () {
                          context.go('/tickets/${ticket.id}');
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
