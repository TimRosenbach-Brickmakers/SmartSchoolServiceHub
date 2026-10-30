using System.Globalization;
using Microsoft.AspNetCore.Localization;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();
builder.Services.AddLocalization(o => o.ResourcesPath = "Resources");

var app = builder.Build();

var cultures = new[] { new CultureInfo("de"), new CultureInfo("en") };
app.UseRequestLocalization(new RequestLocalizationOptions
{
    DefaultRequestCulture = new RequestCulture("de"),
    SupportedCultures = cultures,
    SupportedUICultures = cultures
});

app.MapControllers();
app.Run();
