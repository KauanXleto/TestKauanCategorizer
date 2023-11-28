public class FinancialInstrument : IFinancialInstrument
{
    public decimal MarketValue { get; }
    public string Type { get; }

    public FinancialInstrument(decimal marketValue, string type)
    {
        MarketValue = marketValue;
        Type = type;
    }
}