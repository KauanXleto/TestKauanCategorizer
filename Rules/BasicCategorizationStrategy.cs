public class BasicCategorizationStrategy : IInstrumentCategorizationStrategy
{
    public InstrumentValueCategory Categorize(decimal marketValue)
    {
        if (marketValue < 1000000)
        {
            return InstrumentValueCategory.LowValue;
        }
        else if (marketValue >= 1000000 && marketValue <= 5000000)
        {
            return InstrumentValueCategory.MediumValue;
        }
        else
        {
            return InstrumentValueCategory.HighValue;
        }
    }
}