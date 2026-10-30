enum TicketStatus { newTicket, inProgress, done, rejected }

enum Priority { low, normal, high, urgent }

class Ticket {
  final int id;
  final String subject;
  final String description;
  final TicketStatus status;
  final Priority priority;

  Ticket({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json['id'] as int,
        subject: json['subject'] as String,
        description: json['description'] as String? ?? '',
        status: json['status'] == 'new'
            ? TicketStatus.newTicket
            : TicketStatus.values.byName(json['status'] as String),
        priority: Priority.values.byName(json['priority'] as String),
      );
}
