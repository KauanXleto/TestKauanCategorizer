use  testKauan
go

INSERT INTO InstrumentCategory (Name)
VALUES
    ('Low Value'),
    ('Medium Value'),
    ('High Value')

-- Parametrização dos valores maximos
INSERT INTO ParameterMaxMarketValue (MaxMarketValue, InstrumentCategoryId)
select 
		(case 
			when Name = 'Low Value'		then 999999
			when Name = 'Medium Value'	then 5000000
			when Name = 'High Value'	then null
			else 0
		end)					as 'MaxMarketValue',
		InstrumentCategory.Id	as 'InstrumentCategoryId'

		from InstrumentCategory
GO

--Caso necessite adicionar novas regras ou remover, basta alterar na tabela ParameterMaxMarketValue