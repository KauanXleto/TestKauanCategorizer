public interface IInstrumentCategorizationStrategy
{
    InstrumentValueCategory Categorize(decimal marketValue);
}