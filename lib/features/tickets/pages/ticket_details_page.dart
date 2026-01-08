import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/ticket_model.dart';
import '../bloc/tickets_bloc.dart';
import '../bloc/tickets_event.dart';
import '../bloc/tickets_state.dart';

class TicketDetailsPage extends StatelessWidget {
  final int ticketId;

  const TicketDetailsPage({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Ticket #$ticketId')),
      body: BlocBuilder<TicketsBloc, TicketsState>(
        builder: (context, state) {
          Ticket? ticket;

          if (state is TicketsLoaded) {
            try {
              ticket = state.tickets.firstWhere((t) => t.id == ticketId);
            } catch (e) {
              ticket = null;
            }
          } else if (state is TicketResolved) {
            try {
              ticket = state.tickets.firstWhere((t) => t.id == ticketId);
            } catch (e) {
              ticket = null;
            }
          }

          if (ticket == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text('Ticket not found', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.go('/tickets'),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Tickets'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero animation wrapper
                Hero(
                  tag: 'ticket-$ticketId',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ticket.isResolved
                                ? colorScheme.primaryContainer
                                : colorScheme.secondaryContainer,
                            ticket.isResolved
                                ? colorScheme.primaryContainer.withOpacity(0.7)
                                : colorScheme.secondaryContainer.withOpacity(
                                    0.7,
                                  ),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: ticket.isResolved
                                  ? colorScheme.primary
                                  : colorScheme.secondary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  ticket.isResolved
                                      ? Icons.check_circle
                                      : Icons.pending,
                                  size: 18,
                                  color: ticket.isResolved
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  ticket.isResolved ? 'RESOLVED' : 'ACTIVE',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: ticket.isResolved
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSecondary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Ticket ID
                          Text(
                            'Ticket #${ticket.id}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: ticket.isResolved
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // User info
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 18,
                                color: ticket.isResolved
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSecondaryContainer,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'User ${ticket.userId}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: ticket.isResolved
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title section
                      Text(
                        'Title',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          ticket.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: ticket.isResolved
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description section
                      Text(
                        'Description',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          ticket.body,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Action button
                      if (!ticket.isResolved)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Mark as Resolved'),
                                  content: const Text(
                                    'Are you sure you want to mark this ticket as resolved?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        context.read<TicketsBloc>().add(
                                          TicketResolveRequested(ticketId),
                                        );
                                        Navigator.of(dialogContext).pop();
                                      },
                                      child: const Text('Resolve'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Mark as Resolved'),
                          ),
                        ),

                      if (ticket.isResolved)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'This ticket has been resolved',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}
