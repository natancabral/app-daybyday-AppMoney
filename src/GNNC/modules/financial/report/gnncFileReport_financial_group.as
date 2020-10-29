package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.file.gnncFilePdf;
	import GNNC.data.file.gnncFileReport;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	public class gnncFileReport_financial_group extends gnncFileReport
	{
		public function gnncFileReport_financial_group()
		{
		}

		override protected function __addHeader(e:*=null):void
		{
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle(_headerFont); //FONT
			_gnncFilePdf.__addCell("ID"														,8,"L",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("SUB-CATEGORIA DE"										,30,"L",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("PLANO DE CONTAS"										,84,"L",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("T%"														,12,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("R%"														,12,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("D%"														,12,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("RECEITA"												,16,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("DESPESA"												,16,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__breakLine(_normalRow+1);
		} 
		
		override protected function __addResume(object_:Object):void
		{
			_gnncFilePdf.__breakLine(_normalRow);
			_gnncFilePdf.__setFontStyle(6);
			_gnncFilePdf.__addCellInLine("T% : Em relação ao movimento total (%)"	,"L",3,0,0);
			_gnncFilePdf.__addCellInLine("R% : Em relação a receita (%)"			,"L",3,0,0);
			_gnncFilePdf.__addCellInLine("D% : Em relação a despesa (%)"			,"L",3,0,0);
			_gnncFilePdf.__addCellInLine("*As transferências não são demonstradas neste relatório.","L",3,0,0);
		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			var ALL:String 	= gnncDataNumber.__clearNumberInNaNIfinity(Number((object_.VALUE_IN_PAY+object_.VALUE_OUT_PAY)/object_.VALUE_INOUT_TOTAL*100)).toFixed(1)+"%";
			var IN:String 	= (object_.VALUE_IN_PAY==0)?'-':gnncDataNumber.__clearNumberInNaNIfinity(Number((object_.VALUE_IN_PAY+object_.VALUE_OUT_PAY)/object_.VALUE_IN_TOTAL*100)).toFixed(1)+"%";
			var OUT:String 	= (object_.VALUE_OUT_PAY==0)?'-':gnncDataNumber.__clearNumberInNaNIfinity(Number((object_.VALUE_IN_PAY+object_.VALUE_OUT_PAY)/object_.VALUE_OUT_TOTAL*100)).toFixed(1)+"%";
			
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell(""+object_.ID_GROUP										,8,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(""+gnncData.__firstLetterUpperCase(object_.NAME_FATHER)	,30,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__setFontStyle(_normalFont); //FONT
			_gnncFilePdf.__addCell(""+gnncData.__firstLetterUpperCase(object_.NAME_GROUP)	,84,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell(""+ALL													,12,"C",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(""+IN													,12,"C",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(""+OUT													,12,"C",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__setFontStyle(_normalFont); //FONT
			_gnncFilePdf.__addCell(Number(object_.VALUE_IN_PAY)>0?Number(object_.VALUE_IN_PAY).toFixed(2):''		,16,"R",_normalRow,0xEEEEEE,_normalBorder);
			_gnncFilePdf.__addCell(Number(object_.VALUE_OUT_PAY)>0?Number(object_.VALUE_OUT_PAY).toFixed(2):''		,16,"R",_normalRow,0xEEEEEE,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow);
		}
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			_fileName = "DAYBYDAY - MONEY - Plano de Contas";
			_documentTitle = "Plano de Contas - "+gnncDate.__date2Legend('',_dateStart);
			
			var _where:String = " DATE_END >= '"+_dateStart.fullYear+"-"+(_dateStart.month+1)+"-01 00:00:00' AND DATE_END <= '"+_dateStart.fullYear+"-"+(_dateStart.month+1)+"-31 23:59:59' AND MIX <> 'FINANCIAL_TRANS' ";
			_sql = "" +
				
				" SELECT " +
				" gro.MIX 												as MIX, " +
				" gro.NAME 												as NAME_GROUP, " +
				" (Select NAME from dbd_group WHERE ID like gro.ID_FATHER) as NAME_FATHER, " +
				" gro.ID 												as ID_GROUP, " +
				" ROUND(SUM(VALUE_IN_PAY),2) 							as VALUE_IN_PAY, "+ 
				" ROUND(SUM(VALUE_OUT_PAY),2) 							as VALUE_OUT_PAY, "+
				
				//valor + juro + multa - desconto de pontualidade
				" CASE WHEN DATEDIFF(NOW(),dbd_financial.DATE_END) > 0 THEN ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT) * (1 + ((dbd_financial.FINE_PERCENT/100)/dbd_financial.FINE_PERCENT_TIME) * DATEDIFF(NOW(),dbd_financial.DATE_END) )+(dbd_financial.FINE_VALUE)+(dbd_financial.FINE_VALUE_PERCENT/100*(dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)),2) ELSE ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)-dbd_financial.DISCOUNT_PUNCTUALITY,2) END as VALUE_FINAL, "+

				" (SELECT ROUND(SUM(VALUE_IN_PAY)+SUM(VALUE_OUT_PAY),1) from dbd_financial where "+_where+" ) as VALUE_INOUT_TOTAL, "+
				" (SELECT ROUND(SUM(VALUE_IN_PAY),1) 					from dbd_financial where "+_where+" ) as VALUE_IN_TOTAL, "+
				" (SELECT ROUND(SUM(VALUE_OUT_PAY),1) 					from dbd_financial where "+_where+" ) as VALUE_OUT_TOTAL "+
				
				" FROM "+ 
				" dbd_financial as fin " +
				" JOIN dbd_group as gro on ( gro.ID like fin.ID_GROUP ) " +
				" WHERE " + 
				" fin.DATE_END >= '"+_dateStart.fullYear+"-"+(_dateStart.month+1)+"-01 00:00:00' AND fin.DATE_END <= '"+_dateStart.fullYear+"-"+(_dateStart.month+1)+"-31 23:59:59' " + 
				" AND fin.MIX <> 'FINANCIAL_TRANS' " +
				" GROUP BY " +
				" fin.ID_GROUP "+
				" ORDER BY "+
				" MIX,NAME_GROUP ";
		}
	}
}