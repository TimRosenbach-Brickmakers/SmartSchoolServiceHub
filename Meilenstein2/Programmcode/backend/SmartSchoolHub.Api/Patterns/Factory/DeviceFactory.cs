namespace SmartSchoolHub.Api.Patterns.Factory;

public abstract class Device
{
    public string Name { get; set; } = "";
}

public class Display : Device { }
public class Printer3D : Device { }

public static class DeviceFactory
{
    public static Device Create(string type) => type switch
    {
        "display" => new Display(),
        "printer3d" => new Printer3D(),
        _ => throw new ArgumentException("unbekannter Typ")
    };
}
