package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.DateUtils;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.file.gnncFileReport;
	
	import mx.collections.ArrayCollection;

	public class gnncFileReport_financial_clients extends gnncFileReport
	{
		public function gnncFileReport_financial_clients()
		{
		}
		
		private var _totalRowsIn:uint = 0;
		private var _totalRowsOut:uint = 0;
		private var _nameGroup:String = '';
		
		override protected function __addHeader(e:*=null):void
		{
			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();

			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle(_headerFont); //FONT
			_gnncFilePdf.__addCell("ID"														,10,"L",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("NOME DO CLIENTE"										,60,"L",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("GRUPO"													,30,"L",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("RECEITA (R$)"											,20,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("QNT."													,10,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("DESPESA (R$)"											,20,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("QNT."													,10,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("R%"														,10,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("D%"														,10,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__breakLine(_normalRow+1);

			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();
		} 
		
		override protected function __addResume(object_:Object):void
		{
			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();
			
			_gnncFilePdf.__breakLine(2);
			
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle(_headerFont); //FONT
			_gnncFilePdf.__addCell(""														,100,"C",_normalRow);
			_gnncFilePdf.__addCell("TOTAL (R)"												,30,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("QNT."													,10,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("TOTAL (D)"												,30,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("QNT."													,10,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__breakLine(_normalRow);

			_gnncFilePdf.__addCell(""														,100,"C",_normalRow);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_PAY_TOTAL)	,30,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell(""+_totalRowsIn											,10,"C",_normalRow,_headerBg,_headerBorder);
			
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT_PAY_TOTAL)	,30,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell(""+_totalRowsOut											,10,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__breakLine(_normalRow);


			addCellResume(
				['Resumo','Receita (R$)','QNT.','Despesa (R$)','QNT'],
				[110,30,10,30,10],null,null,
				['L','R','C','R','C']
			);
			
		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();

			if(_nameGroup != object_.NAME_GROUP)
			{
				_gnncFilePdf.__breakLine(1);
				_nameGroup = object_.NAME_GROUP;
				
				_gnncFilePdf.__setFontStyle(_headerFont,0xFFFFFF); //FONT
				_gnncFilePdf.__addCell(!object_.NAME_GROUP?'NENHUM':String(object_.NAME_GROUP).toUpperCase(),100,"L",_headerRow+2,0x777777,0x777777);
				/*_gnncFilePdf.__addCell("RECEITA",20,"C",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("DESPESA",20,"C",_headerRow,_headerBg,_headerBorder);*/
				_gnncFilePdf.__breakLine(_headerRow+2);
			}

			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();

			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell(""+object_.ID																	,10,"L",_normalRow+1,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(""+gnncData.__firstLetterUpperCase(object_.NAME)									,60,"L",_normalRow+1,_normalBg,_normalBorder);
			//_gnncFilePdf.__addCell(""+gnncData.__firstLetterUpperCase(object_.NAME_DEPARTAMENT)						,25,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(""+gnncData.__firstLetterUpperCase(object_.NAME_GROUP)							,30,"L",_normalRow+1,_normalBg,_normalBorder);
			
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_PAY,2,'',',','.','...',' ')			,20,"R",_normalRow+1,_headerBg,_headerBorder);
			_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
			_gnncFilePdf.__addCell(Number(object_.VALUE_IN_PAY )>0?'-':Number((object_.VALUE_IN_PAY/object_.VALUE_IN_PAY_TOTAL  )*100).toFixed(2)+'%' ,10,"C",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell(object_.ROWS_IN																	,10,"C",_normalRow+1,_normalBg,_normalBorder);
			
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT_PAY,2,'',',','.','...',' ')			,20,"R",_normalRow+1,_headerBg,_headerBorder);
			_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
			_gnncFilePdf.__addCell(Number(object_.VALUE_OUT_PAY)>0?'-':Number((object_.VALUE_OUT_PAY/object_.VALUE_OUT_PAY_TOTAL)*100).toFixed(2)+'%' ,10,"C",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell(object_.ROWS_OUT																	,10,"C",_normalRow+1,_normalBg,_normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRow+1);
			
			_totalRowsIn  += uint(object_.ROWS_IN);
			_totalRowsOut += uint(object_.ROWS_OUT);

			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();

		}
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			_fileName      = "DAYBYDAY - MONEY - Movimentos Financeiros de Clientes";
			_documentTitle = "Movimentos Financeiros de Clientes - "+getDatePeriodLegend();
			
			var idAccount:String 		= _object['idAccount']		? " AND fin.ID_FINANCIAL_ACCOUNT = '" 	+ _object['idAccount'] 		+ "' " : '' ;
			var idDepartament:String 	= _object['idDepartament']	? " AND fin.ID_DEPARTAMENT = '" 		+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= _object['idGroup']		? " AND fin.ID_GROUP = '" 				+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= _object['idCategory']		? " AND fin.ID_CATEGORY = '" 			+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= _object['documentType']	? " AND fin.DOCUMENT_TYPE = '" 			+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= _object['payType']		? " AND fin.PAY_TYPE = '" 				+ _object['payType'] 		+ "' " : '' ;
			
			var _filter:String = idAccount + idDepartament + idGroup + idCategory + documentType + payType;

			var _whereDate:String = " " +
				" LEFT(f.DATE_FINAL,10) >= LEFT('"+getDateStart()+" ',10) AND " +
				" LEFT(f.DATE_FINAL,10) <= LEFT('"+getDateEnd()+" ',10) " ;

			var _whereDateGeneral:String = " " +
				" LEFT(fin.DATE_FINAL,10) >= LEFT('"+getDateStart+" ',10) AND " +
				" LEFT(fin.DATE_FINAL,10) <= LEFT('"+getDateEnd+" ',10) " ;

			_sql = "" +
				" select " +
				" cli.ID 		as ID, " +
				" cli.NAME 		as NAME, " +
				" cli.ID_GROUP  as ID_GROUP, " +
				
				" (Select NAME from dbd_departament g where g.ID = cli.ID_DEPARTAMENT ) as NAME_DEPARTAMENT,  " +
				" (Select NAME from dbd_group 		g where g.ID = cli.ID_GROUP		  ) as NAME_GROUP,  " +
				
				" coalesce(ROUND(SUM(fin.VALUE_IN_PAY ),2),0) 	as VALUE_IN_PAY,  " +
				" coalesce(ROUND(SUM(fin.VALUE_OUT_PAY),2),0) 	as VALUE_OUT_PAY, " +

				//valor + juro + multa - desconto de pontualidade
				" CASE WHEN DATEDIFF(NOW(),dbd_financial.DATE_END) > 0 THEN ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT) * (1 + ((dbd_financial.FINE_PERCENT/100)/dbd_financial.FINE_PERCENT_TIME) * DATEDIFF(NOW(),dbd_financial.DATE_END) )+(dbd_financial.FINE_VALUE)+(dbd_financial.FINE_VALUE_PERCENT/100*(dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)),2) ELSE ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)-dbd_financial.DISCOUNT_PUNCTUALITY,2) END as VALUE_FINAL, " +

				" coalesce((Select ROUND(SUM(f.VALUE_IN_PAY ),2)  from dbd_financial f where f.ID_CLIENT <> 0 AND f.VALUE_IN_PAY > 0  AND "+_whereDate+" ),0) as VALUE_IN_PAY_TOTAL,  " +
				" coalesce((Select ROUND(SUM(f.VALUE_OUT_PAY),2)  from dbd_financial f where f.ID_CLIENT <> 0 AND f.VALUE_OUT_PAY > 0 AND "+_whereDate+" ),0) as VALUE_OUT_PAY_TOTAL,  " +
				
				" coalesce((Select COUNT(f.ID) from dbd_financial f where f.ID_CLIENT = cli.ID AND f.VALUE_IN_PAY > 0  AND "+_whereDate+" ),0) as ROWS_IN,  " +
				" coalesce((Select COUNT(f.ID) from dbd_financial f where f.ID_CLIENT = cli.ID AND f.VALUE_OUT_PAY > 0 AND "+_whereDate+" ),0) as ROWS_OUT  " +
				
				" from dbd_client as cli JOIN dbd_financial as fin on ( fin.ID_CLIENT = cli.ID )  " +
				
				" where  " +
				
				_whereDateGeneral + _filter +
				
				" group by  " +
				" cli.ID  " +
				
				" order by " +
				" NAME_GROUP, cli.NAME asc ";

		}
	
		
	}
}