package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.UI.gnncBook.book.limited;
	import GNNC.UI.gnncPopUp.gnncPopUp;
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataArrayCollection;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.globals.gnncGlobalStatic;
	import GNNC.data.file.gnncFilePdf;
	import GNNC.data.file.gnncFileReport;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.layout.Orientation;
	
	public class gnncFileReport_financial_overDraft extends gnncFileReport
	{
		public function gnncFileReport_financial_overDraft()
		{
		}
		/*
		
		override protected function __addHeader(e:*=null):void
		{
			/ * * A4 wth margin = 190 or 260 * * /
			_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
			
			_gnncFilePdf.__addCell("DATA VENC",							15,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("DATA REFER",						15,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("-",									5 ,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("REGISTRO",							15,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("CLIENTE",							40,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("EMISSOR DO CHEQUE",					40,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("PLANO DE CONTAS",					30,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("COMPENSADO",						30,"C",_headerRow,_headerBg,_headerBorder);
			
			_gnncFilePdf.__breakLine(_headerRow);
			
			_gnncFilePdf.__addCell("DESCRIÇÃO DO CHEQUE",				100,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("DOC. NUM.",							40,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("DOC. TIPO",							20,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("RECEITA",							15,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("DESPESA",							15,"C",_headerRow,_headerBg,_headerBorder);
			
			_gnncFilePdf.__breakLine(_headerRow+1);
		} 
		
		override protected function __addResume(object_:Object):void
		{
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__breakLine(1);
			
			_gnncFilePdf.__addCellInLine("* Os cheques nesta relação não estão necessariamente lançados no saldo financeiro.","L",7);
		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			var _canceled:String 	 	= object_.DATE_CANCELED != '0000-00-00 00:00:00' ? '({!CANCELADO!}) ' : '';
			var _documentType:String 	= !object_.DOCUMENT_TYPE ? '' : new gnncDataArrayCollection().__filterNumeric(gnncGlobalArrays._FINANCIAL_DOCUMENT_TYPE,'data',Number(object_.DOCUMENT_TYPE)).getItemAt(0).label;
			var _nameClient:String	 	= gnncData.__firstLetterUpperCase(object_.NAME_CLIENT);
			var _nameClientDoc:String 	= gnncData.__firstLetterUpperCase(object_.NAME_CLIENT_DOCUMENT);
			
			_nameClientDoc = _nameClientDoc == _nameClient ? 'Próprio cliente' : _nameClientDoc;
			/ * *A4 wth margin = 190 or 260 * * /
			/ *
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_END,null,true,false,'-',true),				15,"L",_normalRow,0xDDDDDD,_normalBorder);
			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_PAY_REFERENCE,null,true,false,'-',true).substr(3,7),		15,"L",_normalRow,0xDDDDDD,_normalBorder);
			_gnncFilePdf.__setFontStyle(_normalFont); //FONT
			_gnncFilePdf.__addCell(object_.NUMBER_LETTER,															5,"L" ,_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(object_.NUMBER,																	15,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(_nameClient,																		40,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell(_nameClientDoc,																	40,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_GROUP),								30,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDate.__isNull(object_.DATE_FINAL) ? 'Não' : 'Sim',							30,"C",_normalRow,gnncDate.__isNull(object_.DATE_FINAL)?_normalBg:_alternativeBg,_normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRow);
			
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell(_canceled+object_.DESCRIPTION,													100,"L",_normalRow,!_canceled?_normalBg:_alternativeBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.DOCUMENT_NUMBER),						40,"L" ,_normalRow,!_canceled?_normalBg:_alternativeBg,_normalBorder);
			_gnncFilePdf.__addCell(_documentType,																	20,"L" ,_normalRow,!_canceled?_normalBg:_alternativeBg,_normalBorder);
			_gnncFilePdf.__setFontStyle(_normalFont); //FONT
			_gnncFilePdf.__addCell(Number(object_.VALUE_IN)>0?gnncDataNumber.__safeReal(object_.VALUE_IN,2,''):'',	15,"C",_normalRow,_alternativeBg,_normalBorder);
			_gnncFilePdf.__addCell(Number(object_.VALUE_OUT)>0?gnncDataNumber.__safeReal(object_.VALUE_OUT,2,''):'',15,"C",_normalRow,_alternativeBg,_normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRow);
			_gnncFilePdf.__addLine(0x000000,0.2);* /
			
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
		}
		
		override protected function __filterArrayCollection(arrayC_:ArrayCollection):ArrayCollection
		{
			if(!_object)
				_object = new Object();
			
			//return new gnncDataArrayCollection().__hierarchy(arrayC_,'ID_GROUP','ID_FATHER','LEVEL','NAME_GROUP');
			return _object['arrayC'] ? _object['arrayC'] : arrayC_;
		}		
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			_fileName 				= "DAYBYDAY - "+gnncGlobalStatic._programName+" - Relacao dos Cheques";
		}
		
		private function __setSql():void
		{
			_sql = "" +
				" select *, " +
				
				" (select NAME from dbd_client 				where dbd_client.ID like ID_CLIENT								) NAME_CLIENT, " +
				//" (select NAME from dbd_departament 		where dbd_departament.ID like ID_DEPARTAMENT					) NAME_DEPARTAMENT, " +
				" (select NAME from dbd_group 				where dbd_group.ID like ID_GROUP								) NAME_GROUP " +
				
				" from " + 
				" dbd_financial_overdraft " +
				
				" where " +
				" "+_object['whereDate']+" "+_object['whereFinal']+" " + 
				
				" order by " +
				" DATE_END asc ";
			
			//new gnncAlert().__alert(_sql);
		}

		public function __createPersonalList(arrayC_:ArrayCollection):void
		{
			_object					= new Object();
			_object['arrayC']		= new gnncDataArrayCollection().__clone(arrayC_);
			
			//new gnncAlert().__dataGrid(arrayC_);
			
			_documentTitle  		= "Listagem de Cheques (Personalizada)";
			
			_sql = "";
			__create();			
		}

		public function __createPersonalAllDateFinalNullAndDateEndLate(date_:Date):void
		{
			_dateStart 				= date_;
			
			_object 				= new Object();
			_object['whereDate']	= "DATE_END < '"+gnncDate.__date2String(_dateStart,false)+" 24:59:59'";
			_object['whereFinal']	= "AND DATE_FINAL = '0000-00-00 00:00:00'";
			
			_documentTitle  		= "Relação de Cheques Vencidos e não Compensados ("+gnncDate.__date2Legend('',_dateStart)+" retroativo)";
			
			__setSql();
			__create();
		}

		public function __createPersonalYear(date_:Date):void
		{
			_dateStart 				= date_;
			
			_object 				= new Object();
			_object['whereDate']	= "DATE_END like '"+_dateStart.fullYear+"-%'";
			_object['whereFinal']	= "";

			_documentTitle  		= "Relação de Cheques - Anual ("+_dateStart.fullYear+")";
			
			__setSql();
			__create();
		}

		public function __createPersonalYearDateFinal(date_:Date,dateFinal_:Boolean):void
		{
			_dateStart 					= date_;
			
			_object 				= new Object();
			_object['whereDate']	= "DATE_END like '"+date_.fullYear+"-%'";
			_object['whereFinal']	= dateFinal_ ? " AND DATE_FINAL <> '0000-00-00 00:00:00' " : " AND DATE_FINAL = '0000-00-00 00:00:00' " ;

			var _type:String		= dateFinal_ ? "Compensados" : " Não Compensados" ;

			_documentTitle  		= "Relação de Cheques "+_type+" - Anual ("+_dateStart.fullYear+")";
			
			__setSql();
			__create();
		}
		
		public function __createPersonalMonth(date_:Date):void
		{
			_dateStart 				= date_;
			
			_object 				= new Object();
			_object['whereDate']	= "DATE_END like '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(_dateStart.month+1)+"-%'";
			_object['whereFinal']	= "";
			
			_documentTitle  		= "Relação de Cheques - Mensal ("+gnncGlobalArrays._MONTH.getItemAt(_dateStart.month).label+" "+_dateStart.fullYear+")";
			
			__setSql();
			__create();
		}

		public function __createPersonalMonthDateFinal(date_:Date,dateFinal_:Boolean):void
		{
			_dateStart 				= date_;
			
			_object 				= new Object();
			_object['whereDate']	= "DATE_END like '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(_dateStart.month+1)+"-%'";
			_object['whereFinal']	= dateFinal_ ? " AND DATE_FINAL <> '0000-00-00 00:00:00' " : " AND DATE_FINAL = '0000-00-00 00:00:00' " ;

			var _type:String		= dateFinal_ ? "Compensados" : " Não Compensados" ;

			_documentTitle  		= "Relação de Cheques "+_type+" - Mensal ("+gnncGlobalArrays._MONTH.getItemAt(_dateStart.month).label+" "+_dateStart.fullYear+")";
			
			__setSql();
			__create();
		}

		public function __createPersonalDaily(date_:Date):void
		{
			_dateStart				= date_;
			
			_object 				= new Object();
			_object['whereDate']	= "DATE_END like '"+gnncDate.__date2String(_dateStart,false)+" %'";
			_object['whereFinal']	= "";
			
			_documentTitle  		= "Relação de Cheques - Diário ("+gnncDate.__date2Legend('',_dateStart)+")";
			
			__setSql();
			__create();
		}

		public function __createPersonalDailyDateFinal(date_:Date,dateFinal_:Boolean):void
		{
			_dateStart				= date_;
			
			_object 				= new Object();
			_object['whereDate']	= "DATE_END like '"+gnncDate.__date2String(date_,false)+" %'";
			_object['whereFinal']	= dateFinal_ ? " AND DATE_FINAL <> '0000-00-00 00:00:00' " : " AND DATE_FINAL = '0000-00-00 00:00:00' " ;
			
			var _type:String		= dateFinal_ ? "Compensados" : " Não Compensados" ;
			
			_documentTitle  		= "Relação de Cheques "+_type+" - Diário ("+gnncDate.__date2Legend('',_dateStart)+")";
			
			__setSql();
			__create();
		}

		public function __createPersonalClientDaily(date_:Date,idClient_:uint,nameClient_:String):void
		{
			_dateStart				= date_;
			
			_object 				= new Object();
			_object['whereDate']	= " LEFT(DATE_END,10) like LEFT('"+gnncDate.__date2String(_dateStart,false)+"',10) ";
			_object['whereFinal']	= " AND ID_CLIENT = '"+idClient_+"' " ;
			
			_documentTitle  		= "Relação de Cheques Diário ("+gnncDate.__date2String(_dateStart,false)+") de "+gnncData.__firstLetterUpperCase(nameClient_)+" ";
			
			__setSql();
			__create();
		}

		public function __createPersonalClientAll(idClient_:uint,nameClient_:String):void
		{
			_dateStart				= null;
			
			_object 				= new Object();
			_object['whereDate']	= " ";
			_object['whereFinal']	= " ID_CLIENT = '"+idClient_+"' " ;
			
			_documentTitle  		= "Relação de Cheques Cadastrados de "+gnncData.__firstLetterUpperCase(nameClient_)+" ";
			
			__setSql();
			__create();
		}*/


	}
}