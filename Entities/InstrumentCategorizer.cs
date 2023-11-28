using System;
using System.Collections.Generic;

public class InstrumentCategorizer
{
    private readonly Dictionary<string, IInstrumentCategorizationStrategy> categorizationRules;

    public InstrumentCategorizer()
    {
        categorizationRules = new Dictionary<string, IInstrumentCategorizationStrategy>();
        categorizationRules.Add("Default", new BasicCategorizationStrategy());
    }

    public void AddOrUpdateCategorizationRule(string ruleName, IInstrumentCategorizationStrategy strategy)
    {
        categorizationRules[ruleName] = strategy;
    }

    public InstrumentValueCategory CategorizeInstrument(IFinancialInstrument instrument, string ruleName = "Default")
    {
        if (!categorizationRules.ContainsKey(ruleName))
            throw new ArgumentException("Regra não encontrada");

        return categorizationRules[ruleName].Categorize(instrument.MarketValue);
    }
}