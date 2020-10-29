package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.UI.gnncBook.book.limited;
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataArray;
	import GNNC.data.data.gnncDataArrayCollection;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.file.gnncFilePdf;
	import GNNC.data.file.gnncFileReport;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.layout.Orientation;
	
	public class gnncFileReport_course_actualMonth extends gnncFileReport
	{
		private var _columnStudent:Array = [60,15,25,25,25,15,25];
		private var _valueInPay:Number = 0;
		private var _valueInPayTotal:Number = 0;

		public function gnncFileReport_course_actualMonth()
		{
		}
		
		override protected function __addHeader(e:*=null):void
		{
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle(_headerFont); //FONT
			
				if(!_report.DATA_ROWS)
					return;
			
				var _obj:Object = _report.DATA_ARR.getItemAt(0);
			
				_gnncFilePdf.__addCell("CURSO"										,30	,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("-"											,160,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__breakLine(_headerRow);

				_gnncFilePdf.__addCell("TURMA"										,30	,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(_obj.NAME_PROJECT,true,true).toUpperCase()	,160,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__breakLine(_headerRow);
	
				_gnncFilePdf.__addCell("INÍCIO / TÉRMINO"							,30	,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncDate.__date2Legend(_obj.DATE_START).toUpperCase() + " / " + gnncDate.__date2Legend(_obj.DATE_END).toUpperCase() ,160,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__breakLine(_headerRow);
	
				_gnncFilePdf.__addCell("COORDENADOR(A)"								,30	,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("-"											,160,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__breakLine(_headerRow+1);
				
			_gnncFilePdf.__setFontStyle(_titleFont); //FONT
				
				_gnncFilePdf.__addCellInLine("MENSALIDADE","C",_titleRow+5);
				
			_gnncFilePdf.__setFontStyle(_headerFont); //FONT
				
				_gnncFilePdf.__addCell("VALOR"										,30	,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(_obj.VALUE_IN) + " ("+gnncDataNumber.__safeLegend(_obj.VALUE_IN).toUpperCase()+")",60,"L",_headerRow,_normalBg,_headerBorder);
				_gnncFilePdf.__breakLine(_headerRow);

				_gnncFilePdf.__addCell("VENCIMENTO (DIA)"									,30	,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncDate.__string2Date(_obj.DATE_START).date+"",60,"L",_headerRow,_normalBg,_headerBorder);
				_gnncFilePdf.__breakLine(_headerRow);

			/*_gnncFilePdf.__setFontStyle(_titleFont); //FONT
				
				_gnncFilePdf.__addCellInLine("INADIPLENCIA","C",_titleRow+5);
				
				_gnncFilePdf.__setFontStyle(_headerFont); //FONT
				
				_gnncFilePdf.__addCell("VALOR"										,30	,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(_obj.VALUE_IN) + " ("+gnncDataNumber.__safeLegend(_obj.VALUE_IN)+")",60,"L",_headerRow,_normalBg,_headerBorder);
				_gnncFilePdf.__breakLine(_headerRow);
				
				_gnncFilePdf.__addCell("VENCIMENTO (DIA)"									,30	,"L",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncDate.__string2Date(_obj.DATE_START).date+"",60,"L",_headerRow,_normalBg,_headerBorder);
				_gnncFilePdf.__breakLine(_headerRow);*/

			_gnncFilePdf.__setFontStyle(_titleFont); //FONT
				
				_gnncFilePdf.__addCellInLine("ALUNOS","C",_titleRow+5);

				//_gnncFilePdf.__addCellInLine("Total: "+gnncDataArray.__matchValues(_columnStudent,"+"),"C");
				
				_gnncFilePdf.__setFontStyle(_headerFont); //FONT
				
				_gnncFilePdf.__addCell("ALUNO"										,_columnStudent[0],"L",_headerRow,_headerBg,_headerBorder); //aluno
				_gnncFilePdf.__addCell("SITUAÇÃO"									,_columnStudent[1],"L",_headerRow,_headerBg,_headerBorder); //situação de matrícula ou desistente
				_gnncFilePdf.__addCell("MENS PAG."									,_columnStudent[5],"L",_headerRow,_headerBg,_headerBorder); //Todos os meses (anexados)
				_gnncFilePdf.__addCell("VALOR MENS."								,_columnStudent[2],"L",_headerRow,_headerBg,_headerBorder); //Valor mensalidade para o aluno
				_gnncFilePdf.__addCell("VALOR PAG. (ANEX)"							,_columnStudent[3],"L",_headerRow,_headerBg,_headerBorder); //Palor pago no mês
				_gnncFilePdf.__addCell("PAGO EM"									,_columnStudent[4],"L",_headerRow,_headerBg,_headerBorder); //Pagamento do mês
				_gnncFilePdf.__addCell("TOTAL PAG. (ANEX)"							,_columnStudent[6],"L",_headerRow,_headerBg,_headerBorder); //Todos os meses (anexados)
				_gnncFilePdf.__breakLine(_headerRow);
				//SE PAGO OU NAO
				//MES DA MENSALIDADE
				//MATRICULADO OU DESISTENTE

		} 	
		
		override protected function __addResume(object_:Object):void
		{
			_gnncFilePdf.__breakLine(1);

			_gnncFilePdf.__addCell(""											,_columnStudent[0],"L",_normalRow,_normalBg);
			_gnncFilePdf.__addCell(""											,_columnStudent[1],"C",_normalRow,_normalBg);
			_gnncFilePdf.__addCell(""											,_columnStudent[5],"C",_normalRow,_normalBg);
			_gnncFilePdf.__addCell("Total"										,_columnStudent[2],"C",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(_valueInPay)		,_columnStudent[3],"R",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell("-"											,_columnStudent[4],"C",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(_valueInPayTotal)	,_columnStudent[6],"R",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow);

			_gnncFilePdf.__setFontStyle(_titleFont); //FONT
			
			_gnncFilePdf.__addCellInLine("REPASSES","C",_titleRow+5);
			
			_gnncFilePdf.__setFontStyle(_headerFont); //FONT
			
			_gnncFilePdf.__addCell("SALDO PAGO EM @JUNHO"						,150,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(_valueInPay)		,40,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow);
			
			_gnncFilePdf.__setFontStyle(_normalFont); //FONT
			
			_gnncFilePdf.__addCell("Repasse ACO"								,130,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell("0%"											,20,"C",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell("-"											,40,"L",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow+2);
			
			_gnncFilePdf.__setFontStyle(_headerFont); //FONT
			
			_gnncFilePdf.__addCell("SALDO RESTANTE"								,150,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(_valueInPay)		,40,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow);
			
			_gnncFilePdf.__setFontStyle(_normalFont); //FONT
			
			var _50percent:Number = _valueInPay/2;
			
			_gnncFilePdf.__addCell("Repasse Coordenador"						,130,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell("50%"										,20,"C",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(_50percent)		,40,"L",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow);
			
			_gnncFilePdf.__addCell("Repasse CEC"								,130,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell("50%"										,20,"C",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(_50percent)		,40,"L",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow);
			
			_gnncFilePdf.__setFontStyle(_titleFont); //FONT
			
			_gnncFilePdf.__addCellInLine("ASSINATURAS","C",_titleRow+5);
			
			
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__breakLine(1);
			
			_gnncFilePdf.__setFontStyle(_legendFont); //FONT

			_gnncFilePdf.__breakLine(_legendRow);

			//_gnncFilePdf.__addCellInLine("* As transferências não são demonstradas neste relatório."	,"L",_legendRow);
			_gnncFilePdf.__addCellInLine("Legendas:"													,"L",_legendRow);
			_gnncFilePdf.__addCellInLine("(MAT) Matrículado / (DES) Desistente."				,"L",_legendRow);
			_gnncFilePdf.__addCellInLine("(VALOR MENS.) Valor da mensalidade para o aluno."				,"L",_legendRow);
			_gnncFilePdf.__addCellInLine("(VALOR ANEX.) Valor pago pelo aluno no mês atual. Pagamento(s) Anexado(s)","L",_legendRow);
			_gnncFilePdf.__addCellInLine("(DATA PAG.) Data do pagamento do mês atual."					,"L",_legendRow);
			_gnncFilePdf.__addCellInLine("(TOTAL PAG.) Todas das parcelas pagas."						,"L",_legendRow);
			
			//VALOR PAG.) DATA PAG. TOTAL PAG
		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			_gnncFilePdf.__setFontStyle(_normalFont); //FONT
			
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_STUDENT)				,_columnStudent[0],"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell("- / "+object_.DATE_ALERT											,_columnStudent[1],"C",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(object_.ROWS_PARCEL_FINAL+"/"+object_.ROWS_PARCEL					,_columnStudent[5],"C",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN,2,"")						,_columnStudent[2],"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_PAY,2,"")					,_columnStudent[3],"R",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_FINAL,null,true,false,'-',true)	,_columnStudent[4],"C",_normalRow,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_PAY_TOTAL,2,"")			,_columnStudent[6],"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow);
			
			_valueInPay 		= _valueInPay + Number(object_.VALUE_IN_PAY);
			_valueInPayTotal 	= _valueInPayTotal + Number(object_.VALUE_IN_PAY_TOTAL);
			
		}
		
		override protected function __filterArrayCollection(arrayC_:ArrayCollection):ArrayCollection
		{
			return arrayC_;
		}		
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			//_gnncFilePdf._pageOrientation = Orientation.PORTRAIT;
			_fileName = "DAYBYDAY - MONEY - Resumo do Curso no Mes";
		}
		
		private function __setSql():void
		{
			/*_sql = "" +
				
				"select p.*, " +
				
				" ( '00-00-00' 																																		) DATE_FINAL_PAY,  " +
				" ( select (sp.DATE_END - CURRENT_DATE())*-1 from from dbd_course_parcel sp where sp.ID_CLIENT like p.ID_CLIENT AND sp.ID_PROJECT like p.ID_PROJECT LIMIT 0,1	) DATE_ALERT,  " +
				
				" ( select COUNT(ID) from dbd_course_parcel_pay sp where sp.ID_COURSE_PARCEL like p.ID 																) ROWS_PARCEL_PAY,  " +
				" ( select COUNT(ID) from dbd_course_parcel sp where sp.ID_CLIENT like p.ID_CLIENT AND sp.ID_PROJECT like p.ID_PROJECT AND sp.DATE_FINAL <> '0000-00-00 00:00:00' ) ROWS_PARCEL_FINAL,  " +
				" ( select COUNT(ID) from dbd_course_parcel sp where sp.ID_CLIENT like p.ID_CLIENT AND sp.ID_PROJECT like p.ID_PROJECT 								) ROWS_PARCEL,  " +
				
				" ( select NAME from dbd_client c where c.ID like p.ID_CLIENT 																						) NAME_STUDENT, " +
				" ( select NAME from dbd_project j where j.ID like p.ID_PROJECT 																						) NAME_PROJECT, " +
				" ( select SUM(VALUE_IN_PAY) from view_course_parcel_pay_value_in v where v.ID_COURSE_PARCEL like p.ID AND v.ID_CLIENT like p.ID_CLIENT AND v.ID_PROJECT like p.ID_PROJECT ) VALUE_IN_PAY,  " +
				" ( select SUM(VALUE_IN_PAY) from view_course_parcel_pay_value_in v where v.ID_CLIENT like p.ID_CLIENT AND v.ID_PROJECT like p.ID_PROJECT 			) VALUE_IN_PAY_TOTAL  " +
				
				" from " +
				
				" dbd_course_parcel p " +
				
				" where " +
				
				" p.ID_PROJECT = '"+_object['idCourse']+"' " +
				
				" MONTH(p.DATE_END) like MONTH(CURRENT_DATE) AND " +
				" YEAR(p.DATE_END) like YEAR(CURRENT_DATE) " +
				
				" order by " +
				
				" NAME_PROJECT,NAME_STUDENT,p.DATE_END,p.ID ASC	";*/
			
			_sql = "" +

			" select p.*, " +
			" ('00-00-00') DATE_FINAL_PAY,  " +
			
			" ( select COUNT(ID) from dbd_course_parcel sp where sp.ID_CLIENT = p.ID_CLIENT AND sp.ID_PROJECT = p.ID_PROJECT 								) ROWS_PARCEL, " +
			" ( select NAME from dbd_client c where c.ID = p.ID_CLIENT																						) NAME_STUDENT, " +
			" ( select NAME from dbd_project j where j.ID = p.ID_PROJECT 																					) NAME_PROJECT, " +
			" ( select COUNT(ID) from dbd_course_parcel_pay sp where sp.ID_COURSE_PARCEL like p.ID  														) ROWS_PARCEL_PAY,   " +
			" ( select COUNT(ID) from dbd_course_parcel sp where sp.ID_CLIENT like p.ID_CLIENT AND sp.ID_PROJECT like p.ID_PROJECT AND sp.DATE_FINAL > 1 	) ROWS_PARCEL_FINAL,  " +
			
			" ( select SUM(v.VALUE_IN_PAY) from view_course_parcel_pay_value_in v where v.ID_COURSE_PARCEL = p.ID AND v.ID_CLIENT = p.ID_CLIENT AND v.ID_PROJECT = p.ID_PROJECT 	) VALUE_IN_PAY,  " +
			" ( select SUM(v.VALUE_IN_PAY) from view_course_parcel_pay_value_in v where v.ID_CLIENT = p.ID_CLIENT AND v.ID_PROJECT = p.ID_PROJECT 									) VALUE_IN_PAY_TOTAL, " +
			" ( select (sp.DATE_END - CURDATE())*-1 from dbd_course_parcel sp where sp.ID_CLIENT = p.ID_CLIENT AND sp.ID_PROJECT like p.ID_PROJECT LIMIT 0,1						) DATE_ALERT " +
			
			" from  dbd_course_parcel p  where  p.ID_PROJECT = '"+_object['idCourse']+"' AND LEFT(p.DATE_END,7) like LEFT(CURDATE(),7) order by  NAME_STUDENT,p.ID_PROJECT,p.DATE_END,p.ID ASC " ;

			//new gnncAlert().__alert(_sql);
		}
		
		public function __createPersonalListMonth(idCourse_:uint,month_of1to12_:uint=0):void
		{
			if(!idCourse_)
				return;
			
			_dateStart = new Date();
			
			var _month:uint = month_of1to12_ ? month_of1to12_-1 : _dateStart.month;
			
			_documentTitle = "Resumo do Curso no Mês - "+gnncGlobalArrays._MONTH.getItemAt(_month).label+" "+_dateStart.fullYear;
			
			_object 				= new Object();
			_object['idCourse'] 	= idCourse_;
			//_object['month'] 		= month_of1to12_ ? "'"+gnncDataNumber.__setZero(month_of1to12_)+"'" : new Date().month ;
			
			__setSql();
			__create();			
		}
		
	}
}