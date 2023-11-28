public interface IFinancialInstrument
{
    decimal MarketValue { get; }
    string Type { get; }
}
public enum InstrumentValueCategory
{
    LowValue,
    MediumValue,
    HighValue
}