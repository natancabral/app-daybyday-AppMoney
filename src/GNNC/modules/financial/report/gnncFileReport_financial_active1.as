package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.data.data.gnncDataNumber;
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

	public class gnncFileReport_financial_active1 extends gnncFileReport_financial_today
	{
		public function gnncFileReport_financial_active1()
		{
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
			
		}
		
		override protected function __setValues():void
		{
			_fileName 		= "DAYBYDAY - MONEY - Pendencias Financeiras Sinalizadas";
			_documentTitle 	= "Lançamentos Pendentes Sinalizados - Todas - Relatório criado em "+gnncDate.__date2Legend('',new Date());
			
			_sql = "SELECT *, " +
				"(select NAME 		from dbd_client 			where dbd_client.ID = ID_CLIENT													) as NAME_CLIENT, " +
				"(select NAME 		from dbd_departament 		where dbd_departament.ID = ID_DEPARTAMENT										) as NAME_DEPARTAMENT, " +
				"(select NAME 		from dbd_group 				where dbd_group.ID = ID_GROUP													) as NAME_GROUP, " +
				"(select NAME 		from dbd_financial_account 	where dbd_financial_account.ID = ID_FINANCIAL_ACCOUNT							) as NAME_FINANCIAL_ACCOUNT, " +
				//"(select COUNT(ID) 	from dbd_attach 			where dbd_attach.MIX = 'FINANCIAL' AND dbd_attach.ID_MIX = dbd_financial.ID	) as ROWS_ATTACH, " +
				
				//valor + juro + multa - desconto de pontualidade
				" CASE WHEN DATEDIFF(NOW(),dbd_financial.DATE_END) > 0 THEN ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT) * (1 + ((dbd_financial.FINE_PERCENT/100)/dbd_financial.FINE_PERCENT_TIME) * DATEDIFF(NOW(),dbd_financial.DATE_END) )+(dbd_financial.FINE_VALUE)+(dbd_financial.FINE_VALUE_PERCENT/100*(dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)),2) ELSE ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)-dbd_financial.DISCOUNT_PUNCTUALITY,2) END as VALUE_FINAL, " +

				"coalesce((select SUM( IF(VALUE_IN_PAY>0, VALUE_IN_PAY, VALUE_IN) ) 		from dbd_financial where VISIBLE = '1' AND ACTIVE = '1'				),0) as TOTAL_TODAY_IN, " +
				"coalesce((select SUM( IF(VALUE_OUT_PAY>0,VALUE_OUT_PAY,VALUE_OUT) ) 		from dbd_financial where VISIBLE = '1' AND ACTIVE = '1'				),0) as TOTAL_TODAY_OUT " +

				"FROM  " +
				"dbd_financial WHERE VISIBLE = '1' AND ACTIVE = '1' ORDER BY DATE_END, DATE_START, ID ASC ";
		}

		
	}
}