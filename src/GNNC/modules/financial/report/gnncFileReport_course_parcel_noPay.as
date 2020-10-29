package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.UI.gnncBook.book.limited;
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
	
	public class gnncFileReport_course_parcel_noPay extends gnncFileReport
	{
		public function gnncFileReport_course_parcel_noPay()
		{
		}
		
		override protected function __addHeader(e:*=null):void
		{
		} 
		
		override protected function __addResume(object_:Object):void
		{
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__breakLine(1);
			
			//_gnncFilePdf.__addCellInLine("* Os cheques nesta relação não estão necessariamente lançados no saldo financeiro.","L",7);
		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		private var nameCouse:Boolean 	= false;
		private var yearLine:uint 		= 0;
		private var clientLine:uint 	= 0;
		private var i:uint 				= 0;
		private var e:uint 				= 0;
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			_object = object_;
			
			/**A4 wth margin = 190 or 260 **/
			
			if(!nameCouse)
			{
				_gnncFilePdf.__breakLine(_normalRow+1);
				
				_gnncFilePdf.__addCell('Turma',30,"L",_normalRow,0,0);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_COURSE),160,"L",_normalRow,0,0);
				
				_gnncFilePdf.__breakLine(_normalRow+1);
				_gnncFilePdf.__addLine(0x000000,0.3);
				
				/*_gnncFilePdf.__addCell('Turma',30,"L",_normalRow,0,0);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(_object.NAME_COURSE),160,"L",_normalRow,0,0);
				_gnncFilePdf.__breakLine(_normalRow);
				
				_gnncFilePdf.__addCell('Período',50,"L",_normalRow,0,0);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(_object.NAME_COURSE),130,"L",_normalRow,0,0);
				_gnncFilePdf.__breakLine(_normalRow);
				
				_gnncFilePdf.__addCell('Coordenador(a)',50,"L",_normalRow,0,0);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(_object.NAME_COURSE),130,"L",_normalRow,0,0);
				_gnncFilePdf.__breakLine(_normalRow);*/
				
				nameCouse = true;
			}

			
			if(clientLine != uint(object_.ID_CLIENT))
			{
				_gnncFilePdf.__setFontStyle(_normalFont); //FONT
				
				var _desistente:String = object_.ACTIVE_STUDENT == 2 ? ' (Desistente)' : '' ;
				
				_gnncFilePdf.__breakLine(_normalRow+2);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_STUDENT)+_desistente,100,"L",_normalRow,0,0);
				_gnncFilePdf.__breakLine(_normalRow+1);
				
				_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT

				var _v:Number = Number(object_.VALUE_PARCEL_TODAY_TOTAL)-Number(object_.VALUE_IN_PAY_TOTAL);
				var _s:String = _v == 0 ? 'Nenhuma Pendência: ' : _v < 0 ? 'Crédito: ' :  'Débito: ';
				var _vF:Number = _v < 0 ? _v*-1 : _v;
				
				_gnncFilePdf.__addCell('Valor Previsto ('+gnncGlobalArrays._MONTH.getItemAt(new Date().month).NICK_NAME+')'				,48,"C",_normalRow,_headerBg,_normalBorder);
				_gnncFilePdf.__addCell('Valor Mensalidades Pagas (PG)'																	,47,"C",_normalRow,_headerBg,_normalBorder);
				_gnncFilePdf.__addCell('Valor Anexado'																					,48,"C",_normalRow,_headerBg,_normalBorder);
				_gnncFilePdf.__addCell('Situação'																						,47,"C",_normalRow,_headerBg,_normalBorder);

				_gnncFilePdf.__breakLine(_normalRow);

				_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT

				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_PARCEL_TODAY_TOTAL)										,48,"C",_normalRow,_normalBg,_normalBorder);
				_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_PARCEL_FINAL_TOTAL) 										,47,"C",_normalRow,_normalBg,_normalBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_PAY_TOTAL)+' ('+uint(object_.ROWS_IN_PAY_TOTAL)+')'	,48,"C",_normalRow,_normalBg,_normalBorder);

				if(_v>0)//debito
				{
					_gnncFilePdf.__setFontStyle(_normalFont-1,0xFFFFFF); //FONT
					_gnncFilePdf.__setFontWeight(false,_normalFont-2,false); //FONT
					_gnncFilePdf.__addCell(_s+gnncDataNumber.__safeReal(_vF),47,"C",_normalRow,0x222222,_normalBorder);
				}
				else
				{
					_gnncFilePdf.__setFontStyle(_normalFont-1,0x000000); //FONT
					_gnncFilePdf.__setFontWeight(false,_normalFont-2,false); //FONT
					_gnncFilePdf.__addCell(_s+gnncDataNumber.__safeReal(_vF),47,"C",_normalRow,_normalBg,_normalBorder);
				}

				_gnncFilePdf.__breakLine(_normalRow+1);
				
				//HEADER MONTH
				/**A4 wth margin = 190 or 260 **/
				_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
				_gnncFilePdf.__addCell("ANO" ,10,"C",_headerRow,_headerBg,_headerBorder);
				var c:uint = 0;
				for(c=0; c<12; c++)
					_gnncFilePdf.__addCell(String(gnncGlobalArrays._MONTH.getItemAt(c).NICK_NAME).toUpperCase(),15,"C",_headerRow,_headerBg,_headerBorder);
				
				//_gnncFilePdf.__breakLine(_headerRow+1);
				_gnncFilePdf.__breakLine(1);
				
			}


			var y:String 	= object_.YEAR;
			var m:String 	= object_.MONTH;

			if(yearLine != uint(y))
			{
				_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
				_gnncFilePdf.__breakLine(_normalRow);
				_gnncFilePdf.__addCell(y,10,"C",_normalRow,_normalBg,_normalBorder);
			}

			for(e=1; e<uint(m); e++)
			{
				if(clientLine != uint(object_.ID_CLIENT))
				{
					_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
					_gnncFilePdf.__addCell('-',15,"C",_normalRow,_normalBg,_normalBorder);
					i = e-1;
				}
			}

			i++;

			if(Number(object_.VALUE_IN_PAY) == Number(object_.VALUE_IN))//com pagamento igual a mensalidade
			{
				_gnncFilePdf.__setFontStyle(_normalFont-2,0x000000); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_PAY,2,'') + ' ('+uint(object_.ROWS_PARCEL_PAY)+')',15,"C",_normalRow,_normalBg,_normalBorder);
			}
			else if(Number(object_.VALUE_IN_PAY) && Number(object_.VALUE_IN_PAY) != Number(object_.VALUE_IN))//com pagamento diferente da mensalidade
			{
				_gnncFilePdf.__setFontStyle(_normalFont-2,0x000000); //FONT
				_gnncFilePdf.__setFontWeight(false,_normalFont-2,true); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_PAY,2,'') + ' ('+uint(object_.ROWS_PARCEL_PAY)+')',15,"C",_normalRow,_normalBg,_normalBorder);
			}
			else if(!Number(object_.VALUE_IN_PAY) && gnncDate.__isValid(object_.DATE_FINAL))//sem pagamento mas baixado
			{
				_gnncFilePdf.__setFontStyle(_normalFont-2,0x000000); //FONT
				_gnncFilePdf.__addCell('PG',15,"C",_normalRow,_normalBg,_normalBorder);
			}
			else if(gnncDate.__isValid(object_.DATE_CANCELED))//cancelado
			{
				_gnncFilePdf.__setFontStyle(_normalFont-2,0x000000); //FONT
				_gnncFilePdf.__addCell('CA',15,"C",_normalRow,_normalBg,_normalBorder);
			}
			else if(Number(object_.DATE_ALERT)>=0) //vencidos
			{
				_gnncFilePdf.__setFontStyle(_normalFont-2,0xFFFFFF); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN,2,''),15,"C",_normalRow,0x111111,_normalBorder);
			}
			else //abertos e ainda não vencidos
			{
				_gnncFilePdf.__setFontStyle(_normalFont-2,0x777777); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN,2,''),15,"C",_normalRow,_headerBg,_normalBorder);
			}
			
			if(i == 12)
			{
				//_gnncFilePdf.__breakLine(_normalRow);
				i = 0;
			}

			yearLine 	= uint(object_.YEAR);
			clientLine 	= uint(object_.ID_CLIENT);

			_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT

			//_gnncFilePdf.__addLine(0x000000,0.2);
		}
		
		override protected function __filterArrayCollection(arrayC_:ArrayCollection):ArrayCollection
		{
			//return new gnncDataArrayCollection().__hierarchy(arrayC_,'ID_GROUP','ID_FATHER','LEVEL','NAME_GROUP');
			//return _object['arrayC'] ? _object['arrayC'] : arrayC_;
			return arrayC_;
		}		
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			_fileName 				= "DAYBYDAY - "+gnncGlobalStatic._programName+" - Curso x Mensalidades x Pagamentos Anexados";
		}
		
		private function __setSql():void
		{
			_sql = "" +
			" select p.*, " +

			" MONTH(p.DATE_END) as MONTH, " + 
			" YEAR(p.DATE_END) as YEAR, " + 
			
			" CONCAT(YEAR(p.DATE_END),'-',MONTH(p.DATE_END)) as YMONTH, " + 
			
			" ( '00-00-00' ) DATE_FINAL_PAY,  " +
			" ( (DATE_END - CURRENT_DATE())*-1 ) DATE_ALERT,  " +
			" ( select SUM(VALUE_IN_PAY) 	from view_course_parcel_pay_value_in v where v.ID_COURSE_PARCEL = p.ID AND v.ID_CLIENT = p.ID_CLIENT AND v.ID_PROJECT = p.ID_PROJECT ) VALUE_IN_PAY, " +
			" ( select COUNT(ID) 		 	from dbd_course_parcel_pay sp where sp.ID_COURSE_PARCEL = p.ID AND sp.ID_PROJECT = p.ID_PROJECT) ROWS_PARCEL_PAY,  " +

			//total das pacelas vinculadas e pagas / lançamentos financeiros somados
			" ( select SUM(f.VALUE_IN_PAY) 	from dbd_course_parcel_pay c join dbd_financial f where c.ID_CLIENT like p.ID_CLIENT AND c.ID_FINANCIAL like f.ID AND c.ID_PROJECT = p.ID_PROJECT ) VALUE_IN_PAY_TOTAL, " + 
			" ( select COUNT(f.ID) 			from dbd_course_parcel_pay c join dbd_financial f where c.ID_CLIENT like p.ID_CLIENT AND c.ID_FINANCIAL like f.ID AND c.ID_PROJECT = p.ID_PROJECT ) ROWS_IN_PAY_TOTAL, " + 
			//somas das parcelas baixadas, porém valor não vinculado com os lançamentos financeiros
			" ( select SUM(c.VALUE_IN)  	from dbd_course_parcel c where c.ID_CLIENT = p.ID_CLIENT AND c.DATE_FINAL > 0 AND c.ID_PROJECT = p.ID_PROJECT ) VALUE_PARCEL_FINAL_TOTAL, " + 
			//somas das parcelas ate o mes atual, porém valor não vinculado com os lançamentos financeiros
			" ( select SUM(c.VALUE_IN)  	from dbd_course_parcel c where c.ID_CLIENT = p.ID_CLIENT AND LEFT(c.DATE_CANCELED,10) like '0000-00-00' AND c.DATE_END < CURDATE() AND c.ID_PROJECT = p.ID_PROJECT )  VALUE_PARCEL_TODAY_TOTAL, " + 

			//" ( select DATE_START 		from dbd_project t where t.ID = p.ID_PROJECT 	) COURSE_DATE_START,  " +
			//" ( select DATE_END 			from dbd_project t where t.ID = p.ID_PROJECT 	) COURSE_DATE_END,    " +
			//" ( select YEAR(DATE_START) 	from dbd_project t where t.ID = p.ID_PROJECT 	) COURSE_YEAR_START,  " +
			//" ( select YEAR(DATE_END) 	from dbd_project t where t.ID = p.ID_PROJECT 	) COURSE_YEAR_END,    " +

			" ( select ACTIVE 				from dbd_course_student s where s.ID_PROJECT = p.ID_PROJECT AND s.ID_CLIENT = p.ID_CLIENT ) ACTIVE_STUDENT,  " +

			" ( select NAME 				from dbd_project t where t.ID = p.ID_PROJECT 	) NAME_COURSE,  " +
			" ( select NAME 				from dbd_client  c where c.ID = p.ID_CLIENT  	) NAME_STUDENT  " +
			
			" from dbd_course_parcel p  where p.ID_PROJECT = '"+_object['idCourse']+"' ORDER BY NAME_STUDENT,p.ID_CLIENT, p.DATE_END, p.ID ASC ";
			
			//" "+_object['whereDate']+" "+_object['whereFinal']+" " + 
		}
		
		public function __createPersonalList(idCourse_:uint,dayDateEndVencimento_:uint=0):void
		{
			if(!idCourse_)
				return;
			
			_documentTitle  		= "Curso x Mensalidades x Pagamentos Anexados - Hoje "+gnncDate.__date2Legend('',new Date());

			_object 				= new Object();
			_object['idCourse'] 	= idCourse_;
			//_object['dayDateEndVencimento'] = dayDateEndVencimento_ ? "'"+gnncDataNumber.__setZero(dayDateEndVencimento_)+"'" : "LEFT(p.DATE_END)" ;
			
			//_sql = "";
			
			__setSql();
			__create();			
		}
		
	}
}