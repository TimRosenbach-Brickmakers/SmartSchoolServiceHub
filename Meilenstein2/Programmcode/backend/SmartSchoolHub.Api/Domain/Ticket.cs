namespace SmartSchoolHub.Api.Domain;

public enum TicketStatus { New, InProgress, Done, Rejected }

public class Ticket
{
    public int Id { get; set; }
    public string Subject { get; set; } = "";
    public string Description { get; set; } = "";
    public TicketStatus Status { get; set; } = TicketStatus.New;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
