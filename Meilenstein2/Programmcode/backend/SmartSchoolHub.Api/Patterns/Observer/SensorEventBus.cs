namespace SmartSchoolHub.Api.Patterns.Observer;

public interface ISensorListener
{
    void OnReading(int sensorId, double value);
}

public class SensorEventBus
{
    private readonly List<ISensorListener> _listeners = new();

    public void Subscribe(ISensorListener l) => _listeners.Add(l);

    public void Publish(int sensorId, double value)
    {
        foreach (var l in _listeners) l.OnReading(sensorId, value);
    }
}
