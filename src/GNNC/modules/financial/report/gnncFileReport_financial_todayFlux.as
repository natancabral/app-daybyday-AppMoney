package GNNC.modules.financial.report
{
	import GNNC.data.date.DateUtils;
	import GNNC.data.date.gnncDate;
	import GNNC.data.sql.gnncSql;
	import GNNC.sqlTables.table_financial;
	
	public class gnncFileReport_financial_todayFlux extends gnncFileReport_financial_today
	{
		public function gnncFileReport_financial_todayFlux(csv_:Boolean=false)
		{
			_csvReturn = csv_;
		}
		
		/*override protected function __addResume(object_:Object):void
		{
		}*/
		
		override protected function __setValues():void
		{
			//start
			var dateStartCurrent:String   = gnncDate.__date2String(_dateStart,false);
			var dateStartYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart),false);
			//end
			var dateEndCurrent:String   = gnncDate.__date2String(_dateEnd,false);
			var dateEndYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateEnd),false);
			
			var dateLegend:String = dateStartCurrent.substr(0,10)==dateEndCurrent.substr(0,10)? gnncDate.__date2Legend('',_dateStart) : gnncDate.__date2Legend('',_dateStart) + ' até ' + gnncDate.__date2Legend('',_dateEnd);

			_fileName 		= "DAYBYDAY - MONEY - Fluxo de Caixa";
			_documentTitle 	= "Fluxo de Caixa do Dia "+dateLegend;
			
			var idAccount:String 		= _object['idAccount']		>0? " AND ID_FINANCIAL_ACCOUNT = '" + _object['idAccount'] 		+ "' " : '' ;
			var idDepartament:String 	= _object['idDepartament']	>0? " AND ID_DEPARTAMENT = '" 		+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= _object['idGroup']		>0? " AND ID_GROUP = '" 			+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= _object['idCategory']		>0? " AND ID_CATEGORY = '" 			+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= _object['documentType']	? " AND DOCUMENT_TYPE = '" 		+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= _object['payType']		? " AND PAY_TYPE = '" 			+ _object['payType'] 		+ "' " : '' ;

			var _filter:String = idAccount + idDepartament + idGroup + idCategory + documentType + payType;

			var _WHERE:String = " " +
				" DATE_FINAL >= '"+dateStartCurrent+" 00:00:00' AND " +
				" DATE_FINAL <= '"+dateEndCurrent+" 23:59:59' AND " +
				" DATE_FINAL > 0 AND " + 
				" ( VALUE_IN_PAY > 0.00001 OR VALUE_OUT_PAY > 0.00001 ) " +
				"" + _filter;
			
			var _COLUMNS:Array = [
				"*, IF(VALUE_IN > 0, '1', '0') as FININ",
				"(select NAME 	from dbd_client 			where dbd_client.ID 			= ID_CLIENT						) as NAME_CLIENT",
				"(select NAME 	from dbd_departament 		where dbd_departament.ID 		= ID_DEPARTAMENT				) as NAME_DEPARTAMENT",
				"(select NAME 	from dbd_group 				where dbd_group.ID 				= ID_GROUP						) as NAME_GROUP",
				//"(select NAME 	from dbd_category 			where dbd_category.ID 			= ID_CATEGORY					) as NAME_CATEGORY",
				"(select NAME 	from dbd_financial_account 	where dbd_financial_account.ID 	= ID_FINANCIAL_ACCOUNT			) as NAME_FINANCIAL_ACCOUNT",

				"(select f.NUMBER_FINAL_PAY from dbd_financial as f where f.ID = dbd_financial.ID_PAY_PART limit 1 ) as THIS_IS_NUMBER_FINAL_PAY ",

				//pendencias
				"coalesce((select COUNT( ID ) 												from dbd_financial where VISIBLE = '1' AND ACTIVE = '1' "+idAccount+" ),0) as ROWS_ACTIVE_1 ",
				"coalesce((select SUM( IF(VALUE_IN_PAY>0, VALUE_IN_PAY, VALUE_IN) ) 		from dbd_financial where VISIBLE = '1' AND ACTIVE = '1'	"+idAccount+" ),0) as VALUE_IN_ACTIVE_1 ",
				"coalesce((select SUM( IF(VALUE_OUT_PAY>0,VALUE_OUT_PAY,VALUE_OUT) ) 		from dbd_financial where VISIBLE = '1' AND ACTIVE = '1'	"+idAccount+" ),0) as VALUE_OUT_ACTIVE_1 ",

				//valor + juro + multa - desconto de pontualidade
				" CASE WHEN DATEDIFF(NOW(),dbd_financial.DATE_END) > 0 THEN ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT) * (1 + ((dbd_financial.FINE_PERCENT/100)/dbd_financial.FINE_PERCENT_TIME) * DATEDIFF(NOW(),dbd_financial.DATE_END) )+(dbd_financial.FINE_VALUE)+(dbd_financial.FINE_VALUE_PERCENT/100*(dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)),2) ELSE ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)-dbd_financial.DISCOUNT_PUNCTUALITY,2) END as VALUE_FINAL ",

				//valor de todas as receitas do dia
				"(select round(SUM(VALUE_IN_PAY),2) 		from dbd_financial where "+_WHERE+"								) as TOTAL_TODAY_IN",
				//valor de todas as despesas do dia
				"(select round(SUM(VALUE_OUT_PAY),2) 		from dbd_financial where "+_WHERE+"								) as TOTAL_TODAY_OUT",

				//A soma de toda movimentação anterior a hoje, saldo de ontem
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_FINAL <= '"+dateStartYesterday+" 23:59:59' "+idAccount+" ) as TOTAL_BEFORE",
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_END   <= '"+dateStartYesterday+" 23:59:59' "+idAccount+" ) as TOTAL_BEFORE_END ",
				//somas de todas as movimentações 
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_FINAL <= '"+dateEndCurrent+" 23:59:59'   "+idAccount+" ) as TOTAL_AFTER",
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_END   <= '"+dateEndCurrent+" 23:59:59'   "+idAccount+" ) as TOTAL_AFTER_END "

			];

			var ord:Array = [(_object['orderBy']?_object['orderBy']+',':'')+'FININ desc','NUMBER_FINAL_PAY','ID_DEPARTAMENT','ID_FINANCIAL_ACCOUNT','PAY_TYPE','FLAG_CARD','NUMBER_LETTER','NUMBER','DATE_FINAL asc','DATE_END'];

			_sql = new gnncSql().__SELECT(new table_financial(),false,_COLUMNS,null,null,[_WHERE],null,ord,false);
		}

		
	}
}