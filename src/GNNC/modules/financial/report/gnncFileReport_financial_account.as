package GNNC.modules.financial.report
{
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.gnncDate;
	import GNNC.data.file.gnncFileReport;

	public class gnncFileReport_financial_account extends gnncFileReport
	{

		static internal var   border:uint 		= 0x222222;
		static internal const bg:uint 			= 0xFFFFFF;
		static internal const font:uint 		= 9;
		static internal const row:uint 			= 4;
		
		static internal const borderAlt:uint 	= 0x999999;
		static internal const bgAlt:uint 		= 0xEEEEEE;
		static internal const fontSmall:uint 	= 7;
		static internal const fontBig:uint 		= 10;
		
		private var _beforeTotal:Boolean = false;
		private var _nameAccount:String = '';
		private var _rowResume:Number = 10;
		
		private var valueInTotal:Number = 0;
		private var valueOutTotal:Number = 0;
		private var valueAccountTotal:Number = 0;
		
		private var showHeader:Boolean = false;

		public function gnncFileReport_financial_account()
		{
		}
		
		override protected function __addHeader(e:*=null):void
		{
			/**A4 wth margin = 190 or 260 **/
			if(showHeader==false)
			{
				addCellTitle(
					'Saldo das Contas Cadastradas',
					'Período do Demonstrativo - Mês de '+getDateEndMonth()+' '+_dateEnd.fullYear+' (emissão '+gnncDate.__date2Legend('',new Date())+')'
				);

				_gnncFilePdf.__setFontStyle(font-1); //FONT
				//_gnncFilePdf.__addCell("Saldo Anterior",45,"L",row+2,0xDDDDDD,border);
				_nameAccount = Number(_object['idAccount'])>0?_object['nameAccount']:'Todas as Contas';
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(_nameAccount),25,"C",row+2,bgAlt,border);
				
				if(Number(_object['idDepartament'])>0)
					_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(_object['nameDepartament']),25,"C",row+2,bgAlt,border);
				
				//_gnncFilePdf.__addCell(gnncDate.__date2Legend('',DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart)),25,"C",row+2,bgAlt,border);
				_gnncFilePdf.__breakLine(row+3);

				_beforeTotal = true;
			}
			
			addCellHeader(
				['Conta','Tipo','Movimento Receita','Movimento Despesa','Saldo até '+getDateEndMonth()+' '+_dateEnd.fullYear],
				[50,15,40,40,45]
			);
			

		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			var r:uint = 8;
			
			/**A4 wth margin = 190 or 260 **/
			_gnncFilePdf.__setFontWeight(false,10);
			_gnncFilePdf.__addCell(' '+gnncData.__firstLetterUpperCase(object_.NAME),50,'L',r,0xf7f7f7,0xcccccc);
			
			_gnncFilePdf.__setFontWeight(true,7);
			_gnncFilePdf.__addCell(object_.ACCOUNT_TYPE,15,'L',r,0xeeeeee,0xcccccc);

			_gnncFilePdf.__setFontWeight(true,9);
			_gnncFilePdf.__addCell(Number(object_.VALUE_IN)==0?'-':gnncDataNumber.__safeReal(object_.VALUE_IN),40,'R',r,0xffffff,0xcccccc);
			_gnncFilePdf.__addCell(Number(object_.VALUE_IN)==0?'-':gnncDataNumber.__safeReal(object_.VALUE_OUT),40,'R',r,0xffffff,0xcccccc);
			_gnncFilePdf.__setFontWeight(false,9);
			_gnncFilePdf.__addCell(Number(object_.VALUE_ACCOUNT)==0?'-':gnncDataNumber.__safeReal(object_.VALUE_ACCOUNT),45,'R',r,0xffffff,0xcccccc);
			
			_gnncFilePdf.__breakLine(r);
			
			valueInTotal  += Number(object_.VALUE_IN); 
			valueOutTotal += Number(object_.VALUE_OUT);
			valueAccountTotal += Number(object_.VALUE_ACCOUNT);
		}
		
		override protected function __addResume(object_:Object):void
		{
			/**A4 wth margin = 190 or 260 **/
			
			addCellResume(
				[
					'Resumo',
					gnncDataNumber.__safeReal(valueInTotal,2),
					gnncDataNumber.__safeReal(valueOutTotal,2),
					gnncDataNumber.__safeReal(valueAccountTotal,2)
				],
				[65,40,40,45],
				null,null,
				['L','R','R','R']
			);
		}

		override protected function __finalReport(e:*=null):void
		{
			/**A4 wth margin = 190 or 260 **/
		}

		override protected function __setValues():void
		{
			_fileName 		= "DAYBYDAY - MONEY - Contas";
			_documentTitle 	= "Contas Financeiras - "+getDateEndMonth()+' '+_dateEnd.fullYear
			
			var idAccount:String 		= _object['idAccount']		? " AND ID_FINANCIAL_ACCOUNT = '" 	+ _object['idAccount'] 		+ "' " : '' ;
			var idDepartament:String 	= _object['idDepartament']	? " AND ID_DEPARTAMENT = '" 		+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= _object['idGroup']		? " AND ID_GROUP = '" 				+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= _object['idCategory']		? " AND ID_CATEGORY = '" 			+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= _object['documentType']	? " AND DOCUMENT_TYPE = '" 			+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= _object['payType']		? " AND PAY_TYPE = '" 				+ _object['payType'] 		+ "' " : '' ;
			
			var _filter:String = idAccount + idDepartament + idGroup + idCategory + documentType + payType;
			
			/*var _WHERE:String = " " +
				"DATE_FINAL >= '"+dateStartCurrent+" 00:00:00' AND " +
				"DATE_FINAL <= '"+dateEndCurrent+" 23:59:59' "+
				"" + _filter;*/
			
			var limit:String = gnncDate.__date2String(_dateEnd);
			
			var columns:Array = new Array
				([
					'ID',
					'NAME',
					'BANK',
					'ACCOUNT_TYPE',
					'ALLOW_NEGATIVE', //permitir saldos negativos
					/*
					"coalesce((select round(SUM(VALUE_IN_PAY),2)  from dbd_financial  				   where LEFT(DATE_END,7)  like LEFT('"+limit+"',7)  AND ID_FINANCIAL_ACCOUNT = dbd_financial_account.ID "+_filter+" ),0) as VALUE_IN_MONTH ",
					"coalesce((select round(SUM(VALUE_OUT_PAY),2) from dbd_financial 				   where LEFT(DATE_END,7)  like LEFT('"+limit+"',7)  AND ID_FINANCIAL_ACCOUNT = dbd_financial_account.ID "+_filter+" ),0) as VALUE_OUT_MONTH ",
					"coalesce((select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where LEFT(DATE_FINAL,7) <=  LEFT('"+limit+"',7)  AND ID_FINANCIAL_ACCOUNT = dbd_financial_account.ID "+_filter+" ),0) as VALUE_ACCOUNT_MONTH ",
					*/
					"coalesce((select round(SUM(VALUE_IN_PAY),2)  from dbd_financial  				   where LEFT(DATE_END,7) like LEFT('"+limit+"',7) AND ID_FINANCIAL_ACCOUNT = dbd_financial_account.ID "+_filter+" ),0) as VALUE_IN ",
					"coalesce((select round(SUM(VALUE_OUT_PAY),2) from dbd_financial 				   where LEFT(DATE_END,7) like LEFT('"+limit+"',7) AND ID_FINANCIAL_ACCOUNT = dbd_financial_account.ID "+_filter+" ),0) as VALUE_OUT ",
					"coalesce((select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where LEFT(DATE_FINAL,7) <= LEFT('"+limit+"',7) AND ID_FINANCIAL_ACCOUNT = dbd_financial_account.ID "+_filter+" ),0) as VALUE_ACCOUNT ",
					//"coalesce((select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial   ),0) as VALUE_TOTAL",
					
					"(select "+
					"(CASE round(coalesce(SUM(x.VALUE_IN_PAY)-SUM(x.VALUE_OUT_PAY),0),2) "+
					"WHEN NULL   THEN '0' "+
					"WHEN ''     THEN '0' "+
					"WHEN 0      THEN '0' "+
					"WHEN -0     THEN '0' "+
					"WHEN '0.00' THEN '0' "+
					"ELSE '1' "+
					"END) from dbd_financial x where LEFT(x.DATE_FINAL,7) <= LEFT('"+limit+"',7) AND x.ID_FINANCIAL_ACCOUNT = dbd_financial_account.ID) as UP "
				]);			
			
			
			_sql = " select "+columns.join(',')+" from  dbd_financial_account where visible = 1 order by UP desc, NAME asc, ID ASC ";
		}
		
		
		
	}
}