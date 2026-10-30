using Microsoft.AspNetCore.Mvc;
using SmartSchoolHub.Api.Domain;

namespace SmartSchoolHub.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TicketsController : ControllerBase
{
    [HttpGet]
    public ActionResult<IEnumerable<Ticket>> GetAll()
    {
        // TODO: aus Service / Repository laden
        return Ok(new List<Ticket>());
    }

    [HttpPost]
    public IActionResult Create(Ticket ticket)
    {
        // TODO: validieren und speichern
        return Created("", ticket);
    }
}
