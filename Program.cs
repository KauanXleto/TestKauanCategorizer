using System.Diagnostics.Metrics;

class Program
{
    static void Main()
    {
        InstrumentCategorizer categorizer = new InstrumentCategorizer();

        //Inserindo Instruments
        var instruments = new List<FinancialInstrument>();
        instruments.Add(new FinancialInstrument(800000, "Stock"));
        instruments.Add(new FinancialInstrument(1500000, "Bond"));
        instruments.Add(new FinancialInstrument(6000000, "Derivative"));
        instruments.Add(new FinancialInstrument(300000, "Stock"));

        //Categorizando Instruments com regra padrão "BasicCategorizationStrategy.cs"
        Console.WriteLine("Categorizando Instruments com regra padrão BasicCategorizationStrategy.cs:");
        foreach (var item in instruments)
            Console.WriteLine($"instrument{instruments.IndexOf(item) + 1}: {categorizer.CategorizeInstrument(item)}");


        Console.WriteLine("");

        //Adicionando nova regra caso precise
        categorizer.AddOrUpdateCategorizationRule("OtherRule", new OtherCategorizationStrategy());

        //Categorizando Instruments com nova regra "OtherCategorizationStrategy.cs"
        Console.WriteLine("Categorizando Instruments com regra personalizada OtherCategorizationStrategy.cs:");
        foreach (var item in instruments)
            Console.WriteLine($"instrument{instruments.IndexOf(item) + 1}: {categorizer.CategorizeInstrument(item, "OtherRule")}");
    }
}