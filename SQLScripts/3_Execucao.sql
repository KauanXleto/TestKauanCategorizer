use  testKauan
go

--Insert dos intruments
exec proc_insert_categorize_instruments @MarketValue = 800000, @Type = 'Stock', @AddInstrument = 1, @ReallyExecute = 1
exec proc_insert_categorize_instruments @MarketValue = 1500000, @Type = 'Bond', @AddInstrument = 1, @ReallyExecute = 1
exec proc_insert_categorize_instruments @MarketValue = 6000000, @Type = 'Derivative', @AddInstrument = 1, @ReallyExecute = 1
exec proc_insert_categorize_instruments @MarketValue = 300000, @Type = 'Stock', @AddInstrument = 1, @ReallyExecute = 1
GO

--Execução dos valores
exec proc_insert_categorize_instruments @ExecuteValidation = 1

--Caso queira limpar os dados da tabela instruments
--exec proc_insert_categorize_instruments @CleanData = 1, @ReallyExecute = 1