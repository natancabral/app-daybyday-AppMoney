package GNNC.modules.financial.report
{
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataArrayCollection;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.globals.gnncGlobalStatic;
	import GNNC.data.file.gnncFilePdf;
	import GNNC.data.file.gnncFileReport;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;

	public class gnncFileReport_financial_receipt extends gnncFileReport
	{
		public function gnncFileReport_financial_receipt()
		{
		}
		
		override protected function __addHeader(e:*=null):void
		{
			//A4 wth margin = 190 or 260 
		} 
		
		override protected function __addResume(object_:Object):void
		{
			//A4 wth margin = 190 or 260 
		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			//A4 wth margin = 190 or 260
			if(i_<3)
			{
				var image:ByteArray = gnncGlobalStatic._documentPdfLogo != null ? gnncGlobalStatic._documentPdfLogo : _gnncFilePdf.gnncLogoByteArray;
				_gnncFilePdf.__addImageByteArray(image,null,146,_gnncFilePdf._y-10,45,15,0,1);
			}
			
			var type:String = object_.MIX == 'FINANCIAL_TRANS' ? 'T ' : object_.VALUE_IN > 0 ? 'R ' : 'D ' ;
			
			_gnncFilePdf.__setFontStyle(16); //FONT
			_gnncFilePdf.__addCellInLine("RECIBO",											"C",_headerRow+7,0,0);
			_gnncFilePdf.__setFontStyle(_normalFont+2); //FONT
			_gnncFilePdf.__addCellInLine(gnncGlobalStatic._documentPdfCompany,				"L",_normalRow+1,0,0);
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCellInLine(gnncGlobalStatic._documentPdfDescription,			"L",_normalRow,0,0);
			_gnncFilePdf.__breakLine(1);
			_gnncFilePdf.__setFontStyle(_normalFont-3); //FONT
			_gnncFilePdf.__addCellInLine(gnncGlobalStatic._documentPdfReceipt,				"L",_headerRow-1,0,0);
			_gnncFilePdf.__breakLine(1);
			
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			
			//6x30 = 180px + 10px
			_gnncFilePdf.__addCell("Vencimento"											,22,"C",_normalRow+1,0xEEEEEE,_normalBorder);
			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_END)				,22,"C",_normalRow+1,0xFAFAFA,_normalBorder);
			_gnncFilePdf.__addCell("Pagamento"											,22,"C",_normalRow+1,0xEEEEEE,_normalBorder);
			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_FINAL)			,22,"C",_normalRow+1,0xFAFAFA,_normalBorder);
			_gnncFilePdf.__addCell("Regist. Nº"											,22,"C",_normalRow+1,0xEEEEEE,_normalBorder);
			_gnncFilePdf.__addCell(object_.NUMBER_LETTER +' '+ object_.NUMBER			,22,"C",_normalRow+1,0xFAFAFA,_normalBorder);
			
			_gnncFilePdf.__setFontStyle(_normalFont,0xFFFFFF); //FONT
			_gnncFilePdf.__addCell("Fatura Nº"											,29,"C",_normalRow+1,0x777777,_normalBorder);
			_gnncFilePdf.__addCell(type+object_.NUMBER_FINAL_PAY								,29,"C",_normalRow+1,0x777777,_normalBorder); +14

			_gnncFilePdf.__breakLine(_normalRow+1);
			
			_gnncFilePdf.__setFontStyle(_normalFont); //FONT

			_gnncFilePdf.__addCell("A importância de:",										44,"L",_normalRow+1,_normalBg,_normalBorder); 
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(gnncDataNumber.__safeLegend(object_.VALUE_IN_PAY>0?object_.VALUE_IN_PAY:object_.VALUE_OUT_PAY)),	88,"L",_normalRow+1,_normalBg,_normalBorder);

			_gnncFilePdf.__addCell("Valor "+(object_.VALUE_IN>0?"(Recebido):":"(Pago):"),29,"C",_normalRow+1,0xEEEEEE,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_PAY>0?object_.VALUE_IN_PAY:object_.VALUE_OUT_PAY),29,"C",_normalRow+1,0xFAFAFA,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow+1);
			
			
			_gnncFilePdf.__addCell((object_.VALUE_IN)>0?"Recebi(emos) de:":"Pago a:",		44,"L",_normalRow+1,_normalBg,_normalBorder); 
			_gnncFilePdf.__addCell(!object_.hasOwnProperty('NAME_CLIENT')?'':object_.NAME_CLIENT==null?'':object_.NAME_CLIENT,146,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow+1);

			_gnncFilePdf.__addCell("Referente (Plano de Contas):",							44,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_GROUP),		146,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow+1);
			
			var pt:String = !object_.PAY_TYPE      ? '' : gnncGlobalArrays._FINANCIAL_PAY_TYPE      .getItemAt(new gnncDataArrayCollection().__getIndex(gnncGlobalArrays._FINANCIAL_PAY_TYPE     ,'data',object_.PAY_TYPE)).label+' / ' ;
			var dt:String = !object_.DOCUMENT_TYPE ? '' : gnncGlobalArrays._FINANCIAL_DOCUMENT_TYPE .getItemAt(new gnncDataArrayCollection().__getIndex(gnncGlobalArrays._FINANCIAL_DOCUMENT_TYPE,'data',object_.DOCUMENT_TYPE)).label+' / ';
			
			_gnncFilePdf.__addCell("Forma de Pagamento:",									44,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(pt,                                                      30,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell("Doc. Número:",											25,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(dt+object_.DOCUMENT_NUMBER,						        91,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow+2);
			
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCellInLine(object_.DESCRIPTION,								"L",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow+_normalRow);	
			
			_gnncFilePdf.__setFontStyle(_normalFont); //FONT
			_gnncFilePdf.__addCellInLine("",												"L",_normalRow,_normalBg,_normalBg);
			_gnncFilePdf.__addCellInLine("_____________________________________________________________",		"C",_normalRow,_normalBg,_normalBg);
			_gnncFilePdf.__setFontStyle(_normalFont+1); //FONT
			
			if((object_.VALUE_IN)>0)
				_gnncFilePdf.__addCellInLine("Assinatura tesoureiro/responsável",			"C",_normalRow,_normalBg,_normalBg);
			else
				_gnncFilePdf.__addCellInLine("Assinatura recebedor",						"C",_normalRow,_normalBg,_normalBg);
			
			//CORTE/FINAL DO RECIBO
			if(i_<_report.DATA_ROWS-1)
			{
				_gnncFilePdf.__setFontStyle(_normalFont); //FONT
				_gnncFilePdf.__addCellInLine("",											"L",_normalRow,_normalBg,_normalBg);
				_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
				_gnncFilePdf.__addCellInLine("-------------------------------------------------------------------------------------------------  Cortar  -------------------------------------------------------------------------------------------------",		"C",_normalRow,_normalBg,_normalBg);
			}
		}
		
		override protected function __filterArrayCollection(arrayC_:ArrayCollection):ArrayCollection
		{
			return _object['arrayC'];
		}
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			_gnncFilePdf._showHeader 		= false;
			_gnncFilePdf._pageMarginTop 	= 15;
			_gnncFilePdf._pageMarginBottom 	= 15;
			
			_fileName = "DAYBYDAY - "+gnncGlobalStatic._programName+" - Recibo";
			_documentTitle = "Recibo";
			_sql = "";
		}

		
	}
}