package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.UI.gnncBook.book.limited;
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataArrayCollection;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.file.gnncFilePdf;
	import GNNC.data.file.gnncFileReport;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.layout.Orientation;
	
	public class gnncFileReport_financial_safeIn extends gnncFileReport
	{
		public function gnncFileReport_financial_safeIn()
		{
		}
		
		override protected function __addHeader(e:*=null):void
		{
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle(_headerFont); //FONT
			_gnncFilePdf.__addCell("NÍVEL"												,8,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("SUB-CAT DE"											,15,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("PLANO DE CONTAS"									,45,"L",_headerRow,_headerBg,_headerBorder);
			
			_gnncFilePdf.__addCell("JAN/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("FEV/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("MAR/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("ABR/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("MAI/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("JUN/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("JUL/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("AGO/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("SET/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("OUT/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("NOV/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("DEZ/"+_dateStart.fullYear								,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("TOTAL (R$)"											,16,"C",_headerRow,_headerBg,_headerBorder);
			
			_gnncFilePdf.__breakLine(_headerRow+1);
		} 
		
		override protected function __addResume(object_:Object):void
		{
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__breakLine(1);
			
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell("Total R$ (soma dos valores)"										,68,"L",_normalRow+3,_normalBg,_normalBorder);
			
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_1_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_2_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_3_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_4_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_5_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_6_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_7_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_8_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_9_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_10_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_11_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_12_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_0_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRow+2);
			
			_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
			_gnncFilePdf.__addCellInLine("* As transferências não são demonstradas neste relatório.","L",7);
		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			var _normalBg:uint  = (!object_.LEVEL) ? 0xCCCCCC : (object_.LEVEL==1) ? gnncFileReport._normalBg : (object_.LEVEL==2) ? 0xEEEEEE : gnncFileReport._normalBg;
			var _normalRow:uint = (!object_.LEVEL) ? gnncFileReport._normalRow+2 : gnncFileReport._normalRow;
			
			//uint(object_.LEVEL)*2
			var space:String = !object_.LEVEL ? "": object_.LEVEL==1 ? "  " : object_.LEVEL==2 ? "    " : "      "; 
			
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle	(_normalFont-2); //FONT
			_gnncFilePdf.__addCell(object_.LEVEL													,8 ,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_FATHER)				,15,"L",_normalRow,_normalBg,_normalBorder);
			
			_gnncFilePdf.__setFontStyle( !object_.LEVEL ? _normalFont : _normalFont-1); //FONT
			_gnncFilePdf.__addCell(space+gnncData.__firstLetterUpperCase(object_.NAME_GROUP)		,45,"L",_normalRow,_normalBg,_normalBorder);
			
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_1,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_2,2,"")		,16,"R",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_3,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_4,2,"")		,16,"R",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_5,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_6,2,"")		,16,"R",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_7,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_8,2,"")		,16,"R",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_9,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_10,2,"")		,16,"R",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_11,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_12,2,"")		,16,"R",_normalRow,_headerBg,_normalBorder);
			
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_0,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRow);
			
			/*if(id_father != object_.ID_FATHER)
			_gnncFilePdf.__addLine(0x000000,0.2);
			else
			id_father = object_.ID_FATHER;*/
		}
		
		override protected function __filterArrayCollection(arrayC_:ArrayCollection):ArrayCollection
		{
			return new gnncDataArrayCollection().__hierarchy(arrayC_,'ID_GROUP','ID_FATHER','LEVEL','NAME_GROUP');
		}		
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			_gnncFilePdf._pageOrientation = Orientation.LANDSCAPE;
			_fileName = "DAYBYDAY - MONEY - Receitas";
			_documentTitle = "Receitas - "+_dateStart.fullYear;
			
			_sql = "" +
				"Select " +
				//" (select ID from dbd_group where dbd_group.ID like ID_GROUP) as ID_GROUP, "+
				//" (select NAME from dbd_group where dbd_group.ID like ID_GROUP) as NAME_GROUP, "+
				//" CASE " +
				//" WHEN gro.MIX like 'FINANCIAL_IN'  THEN 'Receita' " +
				//" WHEN gro.MIX like 'FINANCIAL_OUT' THEN 'Despesa' " +
				//" END as MIX, "+
				"gro.ID_FATHER 						as ID_FATHER, " +
				"gro.LEVEL 							as LEVEL, " +
				"gro.MIX 							as MIX, " +
				"gro.NAME 							as NAME_GROUP, " +
				"(Select NAME from dbd_group WHERE ID like gro.ID_FATHER) as NAME_FATHER, " +
				"gro.ID 							as ID_GROUP, " ;
			
			for(var e:uint=1; e<=12; e++)
			{
				_sql += " (Select round(SUM(VALUE_IN_PAY),2) 	from dbd_financial where DATE_FINAL >= '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"-01 00:00:00' AND DATE_FINAL <= '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"-31 23:59:59' AND MIX <> 'FINANCIAL_TRANS' AND ID_GROUP = gro.ID	) as VALUE_TOTAL_MONTH_"+e+", ";
				_sql += " (Select round(SUM(VALUE_IN_PAY),2) 	from dbd_financial where DATE_FINAL >= '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"-01 00:00:00' AND DATE_FINAL <= '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"-31 23:59:59' AND MIX <> 'FINANCIAL_TRANS' 						) as VALUE_TOTAL_MONTH_"+e+"_TOTAL, ";
			}
			
			_sql += "" +
				"(Select round(SUM(VALUE_IN_PAY),2) 	from dbd_financial where DATE_FINAL >= '"+_dateStart.fullYear+"-01-01 00:00:00' AND DATE_FINAL <= '"+_dateStart.fullYear+"-12-31 23:59:59' AND MIX <> 'FINANCIAL_TRANS' AND ID_GROUP = gro.ID	) as VALUE_TOTAL_MONTH_"+0+", "+
				"(Select round(SUM(VALUE_IN_PAY),2) 	from dbd_financial where DATE_FINAL >= '"+_dateStart.fullYear+"-01-01 00:00:00' AND DATE_FINAL <= '"+_dateStart.fullYear+"-12-31 23:59:59' AND MIX <> 'FINANCIAL_TRANS'  						) as VALUE_TOTAL_MONTH_"+0+"_TOTAL "+
				
				"from "+ 
				"dbd_group as gro "+
				
				"where " +
				"gro.MIX = 'FINANCIAL_IN' " + 
				"AND gro.MIX <> 'FINANCIAL_TRANS' " + 
				
				"order by "+
				"gro.MIX,gro.ID_FATHER,NAME_GROUP ";
			
			//new gnncAlert().__alert(_sql);
		}
	}
}