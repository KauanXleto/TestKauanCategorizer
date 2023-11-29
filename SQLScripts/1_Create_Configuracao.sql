Create database testKauan
go

use  testKauan
go

--Tabela de instruments
IF OBJECT_ID('FinancialInstrument') IS NULL 
begin
   CREATE TABLE FinancialInstrument (
		Id INT PRIMARY KEY identity,
		MarketValue DECIMAL(18, 2),
		Type VARCHAR(50)
	);
end

--Tabela de Categoria de instrument ("Low Value", "Medium Value", "High Value")
IF OBJECT_ID('InstrumentCategory') IS NULL  
begin
   CREATE TABLE InstrumentCategory (
    Id INT PRIMARY KEY identity,
    Name VARCHAR(50)
	);
end

--Tabela de parametro de valor maximo com base na categoria
IF OBJECT_ID('ParameterMaxMarketValue') IS NULL  
begin
   CREATE TABLE ParameterMaxMarketValue (
		Id INT PRIMARY KEY identity,
		MaxMarketValue DECIMAL(18, 2),
		InstrumentCategoryId int,

		Foreign key (InstrumentCategoryId) references InstrumentCategory(Id)
	);
end


--Procedure proc_insert_categorize_instruments
--Funções:

--Inserir os instruments
--Lipar instruments
--Executar valição dos tipos de instruments

--Parametros:

--@MarketValue			-> (Valor do Instrument) "Apenas deve ser informado caso o seja @AddInstrument = 1"
--@Type					-> (tipo do Instrument) "Apenas deve ser informado caso o seja @AddInstrument = 1"

--@AddInstrument		-> "Inserção de novo Instrument" caso valor seja "1" irá inserir na tabela FinancialInstrument se @MarketValue e @Type forrem informados

--@ExecuteValidation	-> Caso seja passado com valor "1" sera executado a classificação dos Instrument com base no valor maximo dos Instrument ja cadastrados
--@CleanData			-> Caso seja passado com valor "1" irá limpar as informações da tabela FinancialInstrument

--@ReallyExecute		-> Apenas executa os insersts/delete caso seja passado com valor "1" caso contrario, irá dar roolback na transação

IF OBJECT_ID('proc_insert_categorize_instruments', 'P') IS NOT NULL  
   DROP PROCEDURE proc_insert_categorize_instruments
GO  

CREATE PROCEDURE proc_insert_categorize_instruments
	@MarketValue DECIMAL(18, 2) = null,
	@Type VARCHAR(50) = null,
	@AddInstrument bit = 0,
	@ExecuteValidation bit = 0,
	@CleanData bit = 0,

	@ReallyExecute bit = 0
AS
BEGIN
	
	BEGIN TRANSACTION
	BEGIN TRY
	  
	  
		if @AddInstrument = 1
		begin
			if @MarketValue is null
			begin
				Print('Deve ser informado o @MarketValue')
			end

			if @Type is null or @Type = ''
			begin
				Print('Deve ser informado o @Type')
			end
			
			if @MarketValue is not null and ( @Type is not null or @Type <> '')
			begin
			
				INSERT INTO FinancialInstrument (MarketValue, Type)
				VALUES (@MarketValue, @Type)
			
				Print('FinancialInstrument inserido: MarketValue - ' + convert(varchar(50), @MarketValue) + ' Type - ' + @Type)	
			end
		end
	
		if @ExecuteValidation = 1
		begin

			SELECT 
				'Instrument' + convert(varchar(50), FinancialInstrument.Id) as 'Instrument',
				FinancialInstrument.Type,
				IC.Name as 'Category'

			FROM FinancialInstrument 
			
			left join(
                select ROW_NUMBER() OVER(PARTITION BY FinancialInstrument.Id ORDER BY (case when auxpmmv.MaxMarketValue is null then 0 else null end) asc, auxpmmv.MaxMarketValue asc) as RowNumber, 
				auxpmmv.Id,
				FinancialInstrument.Id as 'FinancialInstrumentId'
                from FinancialInstrument with(nolock)
				
				join ParameterMaxMarketValue auxpmmv
				on isNull(auxpmmv.MaxMarketValue,0) > MarketValue and auxpmmv.MaxMarketValue is not null
				
			) as auxpmmv
            on auxpmmv.FinancialInstrumentId = FinancialInstrument.Id
			and auxpmmv.RowNumber = 1

			join ParameterMaxMarketValue pmmv
			on pmmv.Id = auxpmmv.Id 
			or (auxpmmv.Id is null and pmmv.MaxMarketValue is null)
			
			join InstrumentCategory IC
			on IC.Id = pmmv.InstrumentCategoryId

			order by FinancialInstrument.Id

		end

		if @CleanData = 1
		begin
			truncate table FinancialInstrument

			Print('Instrument Clean')
			
		end

		if @ReallyExecute = 1
		begin
			COMMIT TRANSACTION;		
			Print('Execução com sucesso')	
		end
		else
		begin
			Print('ROLLBACK, motivo @ReallyExecute = 0')
			ROLLBACK TRANSACTION;
		end
			
		Print('Execução finalizada')
	END TRY
	BEGIN CATCH
	  ROLLBACK TRANSACTION;
	  
	  Print('Erro execução')
	  SELECT -- As many or few of these as you care to return
		ERROR_NUMBER() AS ErrorNumber
	   ,ERROR_SEVERITY() AS ErrorSeverity
	   ,ERROR_STATE() AS ErrorState
	   ,ERROR_PROCEDURE() AS ErrorProcedure
	   ,ERROR_LINE() AS ErrorLine
	   ,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END;
