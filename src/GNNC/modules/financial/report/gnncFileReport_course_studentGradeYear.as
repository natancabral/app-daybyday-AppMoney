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
	
	public class gnncFileReport_course_studentGradeYear extends gnncFileReport
	{
		public function gnncFileReport_course_studentGradeYear()
		{
		}
		
		override protected function __addHeader(e:*=null):void
		{
			
		} 
		
		override protected function __addResume(object_:Object):void
		{
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__breakLine(1);
			
			_gnncFilePdf.__addCellInLine("* [D] Alunos desistentes.","L",7);
		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
		
			if(i_==0)
			{
				_gnncFilePdf.__setFontStyle(_normalFont+2); //FONT
				_gnncFilePdf.__addCell('Turma', 24, "L", _normalRow+2, 0xfafafa, _normalBorder);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_COURSE), 166, "L", _normalRow+2, _normalBg, _normalBorder);
				_gnncFilePdf.__breakLine(_normalRow+2);
				
				_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
				_gnncFilePdf.__addCell('Início', 24, "L", _normalRow, 0xfafafa, _normalBorder);
				_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_START), 24, "L", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('Término', 24, "L", _normalRow, 0xfafafa, _normalBorder);
				_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_END), 24, "L", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('Fechamento', 24, "L", _normalRow, 0xfafafa, _normalBorder);
				_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_FINAL), 24, "L", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('', 23, "L", _normalRow, 0xfafafa, _normalBorder);
				_gnncFilePdf.__addCell('', 23, "L", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__breakLine(_normalRow);

				/*
				_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
				_gnncFilePdf.__addCell('Coordenador', 24, "L", _normalRow, 0xfafafa, _normalBorder);
				_gnncFilePdf.__addCell('', 24, "L", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('Total Prof.', 24, "L", _normalRow, 0xfafafa, _normalBorder);
				_gnncFilePdf.__addCell('1', 24, "L", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('Total Alunos', 24, "L", _normalRow, 0xfafafa, _normalBorder);
				_gnncFilePdf.__addCell('1', 24, "L", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('Total Desist.', 23, "L", _normalRow, 0xfafafa, _normalBorder);
				_gnncFilePdf.__addCell('1', 23, "L", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__breakLine(_normalRow+2);
				*/

				_gnncFilePdf.__breakLine(_normalRow);

				/**A4 wth margin = 190 or 260 **/
				_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
				
				_gnncFilePdf.__addCell('ALUNO', 58, "C", _headerRow, _headerBg, _headerBorder);
				_gnncFilePdf.__addCell('JAN', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('FEV', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('MAR', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('ABR', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('MAI', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('JUN', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('JUL', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('AGO', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('SET', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('OUT', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('NOV', 11, "C", _normalRow, _normalBg, _normalBorder);
				_gnncFilePdf.__addCell('DEZ', 11, "C", _normalRow, _normalBg, _normalBorder);
				
				_gnncFilePdf.__breakLine(_headerRow);
				_gnncFilePdf.__addLine(0x000000,0.2);
				//_gnncFilePdf.__breakLine(0.2);
				
			}
			
			var _normalRowBig:uint = _normalRow+3;
			
			/**A4 wth margin = 190 or 260 **/
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			if(object_.ACTIVE==2)
			_gnncFilePdf.__addCell('D', 5, "C", _normalRowBig, 0xDDDDDD, _normalBorder);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_STUDENT), (object_.ACTIVE==2?53:58), "L", _normalRowBig, 0xfafafa, _normalBorder);
			
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 11, "L", _normalRowBig, _normalBg, _normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRowBig);
			_gnncFilePdf.__addLine(0x000000,0.2);

			_gnncFilePdf.__setFontStyle(_normalFont-3); //FONT
			_gnncFilePdf.__addCell('Anotações: ', 15, "L", _normalRow, _normalBg, _normalBorder);
			_gnncFilePdf.__addCell('', 175, "L", _normalRow, _normalBg, _normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRow);
			_gnncFilePdf.__addLine(0x000000,0.2);

			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
		}
		
		override protected function __filterArrayCollection(arrayC_:ArrayCollection):ArrayCollection
		{
			//return new gnncDataArrayCollection().__hierarchy(arrayC_,'ID_GROUP','ID_FATHER','LEVEL','NAME_GROUP');
			return _object['arrayC'] ? _object['arrayC'] : arrayC_;
		}		
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			_fileName 				= "DAYBYDAY - "+gnncGlobalStatic._programName+" - Grade Anual de Curso";
		}
		
		private function __setSql():void
		{
			
			_sql = " select s.*, \n" +
				
				//" ( select ENROLLMENT 		from dbd_client as c WHERE c.ID = s.ID_CLIENT	) ENROLLMENT, \n" +
				//" ( select ACCESS_WEB_PASSW from dbd_client as c WHERE c.ID = s.ID_CLIENT	) ACCESS_WEB_PASSW, \n" +
				//" ( select DATE_BIRTH 		from dbd_client as c WHERE c.ID = s.ID_CLIENT	) DATE_BIRTH, \n" +
				" ( select ACTIVE 			from dbd_client as c WHERE c.ID = s.ID_CLIENT					) ACTIVE_CLIENT, \n" +
				
				//" coalesce((SELECT c.NAME from dbd_client c, dbd_course_teacher j where j.ID_PROJECT LIKE  s.ID_PROJECT AND c.ID like j.ID_CLIENT AND j.THEMAN LIKE '1' LIMIT 0,1) ,'-') NAME_TEACHER_THEMAN, \n" +
				//" ( select COUNT(ID) 		from dbd_course_parcel x where x.ID_CLIENT = s.ID_CLIENT AND x.ID_PROJECT = s.ID_PROJECT 	) ROWS_COURSE_PARCEL, \n" +
				
				" ( select NAME 			from dbd_project p where p.ID = s.ID_PROJECT 	) NAME_COURSE, \n" +
				" ( select DATE_START 		from dbd_project p where p.ID = s.ID_PROJECT	) DATE_START, \n" + //
				" ( select DATE_END 		from dbd_project p where p.ID = s.ID_PROJECT 	) DATE_END, \n" +	//
				" ( select DATE_FINAL 		from dbd_project p where p.ID = s.ID_PROJECT 	) DATE_FINAL, \n" +	//
				" ( select NAME 			from dbd_client  c where c.ID = s.ID_CLIENT  	) NAME_STUDENT \n" +		//
				
				//" ( select count(*) 		from dbd_financial f where f.ID_CLIENT like s.ID_CLIENT  ) ROWS_FINANCIAL, \n" +
				//" ( select sum(f.VALUE_IN) from dbd_financial f where f.ID_CLIENT like s.ID_CLIENT AND DATE_FORMAT(f.DATE_FINAL,'%Y-%m') like '2014-04'  ) VALUE_FINANCIAL \n" + 
				
				" from dbd_course_student s where s.ID_PROJECT = '"+_object['idCourse']+"' ORDER BY NAME_STUDENT ASC ";
			
			//new gnncAlert().__alert(_sql);
		}

		/**
		 * @@@@@@@@@@@@@@
		 * */
		public function __createPersonalList(idCourse_:uint):void
		{
			_dateStart				= null;

			_object					= new Object();
			_object['idCourse']		= idCourse_;
						
			_documentTitle  		= "Grade de Alunos";
			
			//_sql = "";
			//_gnncFilePdf._pageOrientation = Orientation.LANDSCAPE;
			__setSql();
			__create();
		}


	}
}