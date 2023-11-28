public class OtherCategorizationStrategy : IInstrumentCategorizationStrategy
{
    public InstrumentValueCategory Categorize(decimal marketValue)
    {
        if (marketValue < 500)
        {
            return InstrumentValueCategory.LowValue;
        }
        else if (marketValue >= 500 && marketValue <= 1000)
        {
            return InstrumentValueCategory.MediumValue;
        }
        else
        {
            return InstrumentValueCategory.HighValue;
        }
    }
}