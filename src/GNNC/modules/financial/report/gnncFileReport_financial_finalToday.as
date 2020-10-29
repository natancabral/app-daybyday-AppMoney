package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.DateUtils;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.globals.gnncGlobalStatic;
	import GNNC.data.sql.gnncSql;
	import GNNC.data.conn.gnncAMFPhp;
	import GNNC.data.file.gnncFilePdf;
	import GNNC.data.file.gnncFileReport;
	import GNNC.sqlTables.table_financial;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	public class gnncFileReport_financial_finalToday extends gnncFileReport_financial_today
	{
		public function gnncFileReport_financial_finalToday(csv_:Boolean=false)
		{
			_csvReturn = csv_;
		}
		
		override protected function __addResume(object_:Object):void
		{
			_gnncFilePdf.__breakLine(row);
					
			if(!object_.hasOwnProperty('TOTAL_TODAY_IN'))
				return;	
			
			/**A4 wth margin = 190 or 260 **/
			//### NEW LINE
			_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
			_gnncFilePdf.__addCell("",														76,"C",rowHeader+rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("RECEITA",												24,"C",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("DESPESA",												24,"C",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("MOVIMENTO",												66,"C",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__breakLine(row);
			
			//### NEW LINE
			_gnncFilePdf.__setFontStyle(font-1); //FONT
			_gnncFilePdf.__addCell("RESPONSÁVEL:",											76,"L",0.1,0,0);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.TOTAL_TODAY_IN),		24,"C",row,bgHeader,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.TOTAL_TODAY_OUT),		24,"C",row,bgHeader,border);
			_gnncFilePdf.__setFontStyle(font); //FONT
			_gnncFilePdf.__addCell(" = "+gnncDataNumber.__safeReal(Number(object_.TOTAL_TODAY_IN-object_.TOTAL_TODAY_OUT)),66,"C",row,bgHeader,border);
			_gnncFilePdf.__breakLine(row);

			_gnncFilePdf.__addLine(0x000000,0.2);
			_gnncFilePdf.__breakLine(row);
			
			//### Pendencias Financeiras
			_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
			_gnncFilePdf.__addCell("PENDÊNCIAS"															,27,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("RECEITA"															,27,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("DESPESA"															,27,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell(''																	,1, "C",row,0,0);
			/*_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__breakLine(row);
			*/
			_gnncFilePdf.__breakLine(row);
			
			_gnncFilePdf.__setFontStyle(font-1); //FONT
			_gnncFilePdf.__addCell(''+uint(object_.ROWS_ACTIVE_1)										,27,"C",row,bgHeader,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_ACTIVE_1)					,27,"C",row,bgHeader,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT_ACTIVE_1)				,27,"C",row,bgHeader,border);			
			_gnncFilePdf.__addCell(''																	,1, "C",row,0,0);
			/*_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__breakLine(row);
			*/
			_gnncFilePdf.__breakLine(row);
			_gnncFilePdf.__addLine(0x000000,0.2);


			_gnncFilePdf.__addCellInLine(
				object_.TOTAL_BEFORE +' | '+
				object_.TOTAL_BEFORE2+' | '+
				object_.TOTAL_AFTER  +' | '+
				object_.TOTAL_AFTER2 +' | ' ,'C',row,0,0);
				//###

			
			var csv:Array = new Array(
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'(Total R.)',
				'(Total R. T.)',
				'(Total R. P.)',
				'(Total D.)',
				'(Total D. T.)',
				'(Total D. P.)'
			);
			
			_csvFooter += csv.join(_csvSeparator) + _csvBreakLine;
			
			csv	= new Array( 
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				gnncDataNumber.__safeReal(ValorTotalLancamentoIn),//object_.TOTAL_TODAY_IN
				gnncDataNumber.__safeReal(ValorTotalLancamentoInTrans),
				gnncDataNumber.__safeReal(ValorTotalLancamentoInNoCount),
				gnncDataNumber.__safeReal(ValorTotalLancamentoOut),//object_.TOTAL_TODAY_OUT
				gnncDataNumber.__safeReal(ValorTotalLancamentoOutTrans),
				gnncDataNumber.__safeReal(ValorTotalLancamentoOutNoCount) 
			);
			
			_csvFooter += csv.join(_csvSeparator) + _csvBreakLine;
			
			csv	= new Array( 
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				gnncDataNumber.__safeReal(object_.TOTAL_TODAY_IN),
				'',
				'',
				gnncDataNumber.__safeReal(object_.TOTAL_TODAY_OUT), 
				''
			);
			
			_csvFooter += csv.join(_csvSeparator) + _csvBreakLine;
		}
		
		override protected function __setValues():void
		{
			//start
			var dateStartCurrent:String   = gnncDate.__date2String(_dateStart,false);
			var dateStartYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart),false);
			//end
			var dateEndCurrent:String   = gnncDate.__date2String(_dateEnd,false);
			var dateEndYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateEnd),false);
			
			var dateLegend:String = dateStartCurrent.substr(0,10)==dateEndCurrent.substr(0,10)? gnncDate.__date2Legend('',_dateStart) : gnncDate.__date2Legend('',_dateStart) + ' até ' + gnncDate.__date2Legend('',_dateEnd);

			_fileName 		= "DAYBYDAY - MONEY - Lancamentos Baixados no Dia";
			_documentTitle 	= "Lançamentos Baixados (Pagos e Recebidos) no Dia "+dateLegend;

			var idAccount:String 		= _object['idAccount']		? " AND ID_FINANCIAL_ACCOUNT = '" 	+ _object['idAccount'] 		+ "' " : '' ;
			var idDepartament:String 	= _object['idDepartament']	? " AND ID_DEPARTAMENT = '" 		+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= _object['idGroup']		? " AND ID_GROUP = '" 				+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= _object['idCategory']		? " AND ID_CATEGORY = '" 			+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= _object['documentType']	? " AND DOCUMENT_TYPE = '" 			+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= _object['payType']		? " AND PAY_TYPE = '" 				+ _object['payType'] 		+ "' " : '' ;

			var _filter:String = idAccount + idDepartament + idGroup + idCategory + documentType + payType;

			var _WHERE:String = " " +
				"DATE_FINAL >= '"+dateStartCurrent+" 00:00:00' AND " +
				"DATE_FINAL <= '"+dateEndCurrent+" 23:59:59' "+
				"" + _filter;
			
			var _COLUMNS:Array = [
				"*, IF(VALUE_IN > 0, '1', '0') as FININ ",
				"(select NAME   from dbd_client 			where dbd_client.ID like ID_CLIENT								) as NAME_CLIENT",
				"(select NAME 	from dbd_departament 		where dbd_departament.ID like ID_DEPARTAMENT					) as NAME_DEPARTAMENT",
				"(select NAME 	from dbd_group 				where dbd_group.ID like ID_GROUP								) as NAME_GROUP",
				//"(select NAME 	from dbd_category 			where dbd_category.ID like ID_CATEGORY							) as NAME_CATEGORY",
				"(select NAME 	from dbd_financial_account 	where dbd_financial_account.ID like ID_FINANCIAL_ACCOUNT		) as NAME_FINANCIAL_ACCOUNT",

				//pendencias
				"coalesce((select COUNT( ID ) 			from dbd_financial where VISIBLE = '1' AND ACTIVE = '1' "+idAccount+" ),0) as ROWS_ACTIVE_1 ",
				"coalesce((select SUM( IF(VALUE_IN_PAY>0, VALUE_IN_PAY, VALUE_IN) ) 		from dbd_financial where VISIBLE = '1' AND ACTIVE = '1' "+idAccount+" ),0) as VALUE_IN_ACTIVE_1 ",
				"coalesce((select SUM( IF(VALUE_OUT_PAY>0,VALUE_OUT_PAY,VALUE_OUT) ) 		from dbd_financial where VISIBLE = '1' AND ACTIVE = '1' "+idAccount+" ),0) as VALUE_OUT_ACTIVE_1 ",

				//valor + juro + multa - desconto de pontualidade
				" CASE WHEN DATEDIFF(NOW(),dbd_financial.DATE_END) > 0 THEN ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT) * (1 + ((dbd_financial.FINE_PERCENT/100)/dbd_financial.FINE_PERCENT_TIME) * DATEDIFF(NOW(),dbd_financial.DATE_END) )+(dbd_financial.FINE_VALUE)+(dbd_financial.FINE_VALUE_PERCENT/100*(dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)),2) ELSE ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)-dbd_financial.DISCOUNT_PUNCTUALITY,2) END as VALUE_FINAL ",

				//valor de todas as receitas do dia
				"(select round(SUM(VALUE_IN_PAY),2) 		from dbd_financial where "+_WHERE+"								) as TOTAL_TODAY_IN",
				//valor de todas as despesas do dia
				"(select round(SUM(VALUE_OUT_PAY),2) 		from dbd_financial where "+_WHERE+"								) as TOTAL_TODAY_OUT",
				
				//A soma de toda movimentação anterior a hoje, saldo de ontem
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_FINAL <= '"+dateStartYesterday+" 23:59:59' "+idAccount+" ) as TOTAL_BEFORE",
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_END   <= '"+dateStartYesterday+" 23:59:59' "+idAccount+" ) as TOTAL_BEFORE_END",
				//somas de todas as movimentações 
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_FINAL <= '"+dateEndCurrent+" 23:59:59'	"+idAccount+" ) as TOTAL_AFTER",
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_END   <= '"+dateEndCurrent+" 23:59:59'	"+idAccount+" ) as TOTAL_AFTER_END"
			];
			
			//var ord:Array = ['DATE_END','VALUE_IN asc','VALUE_OUT asc','PAY_TYPE','DOCUMENT_TYPE','NUMBER_LETTER','NUMBER','DATE_FINAL'];
			var ord:Array = [(_object['orderBy']?_object['orderBy']+',':'')+'FININ desc','DATE_END','NUMBER_FINAL_PAY','ID_DEPARTAMENT','ID_FINANCIAL_ACCOUNT','PAY_TYPE','FLAG_CARD','NUMBER_LETTER','NUMBER','DATE_FINAL asc','DATE_END'];
			
			_sql = new gnncSql().__SELECT(new table_financial(),false,_COLUMNS,null,null,[_WHERE],null,ord,false);
		}

		
	}
}