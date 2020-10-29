package GNNC.modules.financial.report
{
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataArrayCollection;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.globals.gnncGlobalStatic;
	import GNNC.data.file.gnncFileReport;
	
	import mx.collections.ArrayCollection;

	public class gnncFileReport_financial_receiptSafesIR extends gnncFileReport_financial_addToday
	{

		protected override function __addHeader(e:*=null):void
		{
			_gnncFilePdf.__setFontStyle(16);
			
			_gnncFilePdf.__addCellInLine(_object['title'],"C",18,0,0);
			
			_gnncFilePdf.__setFontStyle(_gnncFilePdf._normalFontSize);
			
			_gnncFilePdf._y = _gnncFilePdf._y + _gnncFilePdf._normalHeightRow;
			_gnncFilePdf._x = _gnncFilePdf._pageMarginLeft;
			
			_gnncFilePdf.__breakLine(_gnncFilePdf._normalHeightRow);
			_gnncFilePdf.__addTextMultiCell(_object['descr'],190,_gnncFilePdf._normalHeightRow);
			_gnncFilePdf.__breakLine(_gnncFilePdf._normalHeightRow*2);

			/**A4 wth margin = 190 or 260 **/
			_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
			_gnncFilePdf.__addCell("DATA PAG.",					15,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("DATA VENC.",				15,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("-",							5 ,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("REGISTRO",					15,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("REG. BAIXA",				15,"L",rowHeader,bgHeader,borderHeader);
			//65
			
			_gnncFilePdf.__addCell("PLANO DE CONTAS",			40,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("PAG. TIPO",					15,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("DOC. NUM.",					36,"L",rowHeader,bgHeader,borderHeader);
			
			_gnncFilePdf.__addCell("RECEBIDO",					17,"C",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("PAGO",						17,"C",rowHeader,bgHeader,borderHeader);
			//30
			
			//_gnncFilePdf.__breakLine(row);
			//_gnncFilePdf.__addCell("DESCRIÇÃO DO LANÇAMENTO",	100,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__breakLine(row+1);
		}
		
		protected override function __addResume(object_:Object):void
		{
		}

		override protected function __addFinalObservation(object_:Object):void
		{
		}
		
		protected override function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			var _canceled:String 	= (object_.DATE_CANCELED!='0000-00-00 00:00:00')?'({!CANCELADO!}) ':'';
			var _tranf:String 		= (object_.MIX=='FINANCIAL_TRANS')?'({!TRANSFERÊNCIA!}) ':'';
			
			/**A4 wth margin = 190 or 260 **/
			_gnncFilePdf.__setFontStyle(font-1); //FONT

			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_FINAL,null,true,false,'-',true),				15,"L",row,0xDDDDDD,border);
			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_END,null,true,false,'-',true),				15,"L",row,bgHeader,border);
			_gnncFilePdf.__addCell(object_.NUMBER_LETTER,															5,"L",row,bg,border);
			_gnncFilePdf.__addCell(object_.NUMBER,																	15,"L",row,bg,border);
			_gnncFilePdf.__addCell((Number(object_.VALUE_IN)>0?'R ':'D ')+object_.NUMBER_FINAL_PAY,					15,"L",row,bg,border);

			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_GROUP),								40,"L",row,bg,border);
			_gnncFilePdf.__addCell(object_.PAY_TYPE,                                                                15,"L",row,(!_canceled)?bg:bgAlt,border);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.DOCUMENT_NUMBER),						36,"L",row,(!_canceled)?bg:bgAlt,border);
			
			_gnncFilePdf.__setFontStyle(font); //FONT
			_gnncFilePdf.__addCell(Number(object_.VALUE_IN_PAY)>0?gnncDataNumber.__safeReal(object_.VALUE_IN_PAY,2,''):'',		17,"C",row,bgAlt,border);
			_gnncFilePdf.__addCell(Number(object_.VALUE_OUT_PAY)>0?gnncDataNumber.__safeReal(object_.VALUE_OUT_PAY,2,''):'',	17,"C",row,bgAlt,border);
			
			//_gnncFilePdf.__breakLine(row);
			
			//_gnncFilePdf.__setFontStyle(font-1); //FONT
			//_gnncFilePdf.__addCell(_tranf+_canceled+object_.DESCRIPTION,											190,"L",row,(!_canceled)?bg:bgAlt,border);
			
			_gnncFilePdf.__breakLine(row);
			_gnncFilePdf.__addLine(0x000000,0.2);
			
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
		}
		
		override protected function __filterArrayCollection(arrayC_:ArrayCollection):ArrayCollection
		{
			return _object['arrayC'];
			//return arrayC_;
		}
		
		override protected function __finalReport(e:*=null):void
		{
		}

		
		override protected function __setValues():void
		{
			_fileName = "DAYBYDAY - "+gnncGlobalStatic._programName+" - Declaracao Financeira";
			_documentTitle = "Declaração Financeira";
			//_gnncFilePdf._document_0_logo = gnncGlobalStatic._documentPdfLogo;
			
			_sql = "";
		}

		public function __createPersonal(list_:ArrayCollection,description_:String='',title_:String=''):void
		{
			_object 			= new Object();
			_object['arrayC']	= list_;
			_object['descr']	= description_;
			_object['title']	= title_;

			if(title_)
				_documentTitle = title_;
			
			__create(_object);
		}

	}
}