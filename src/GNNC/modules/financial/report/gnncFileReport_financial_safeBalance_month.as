package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataArrayCollection;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.DateUtils;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.globals.gnncGlobalLog;
	import GNNC.data.globals.gnncGlobalStatic;
	import GNNC.data.file.gnncFileReport;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.layout.Orientation;
	
	public class gnncFileReport_financial_safeBalance_month extends gnncFileReport
	{
		protected var MIX:String           = '';
		protected var firstTime:uint       = 0;
		protected var nameKeyFather:String = '';
		protected var nameKeyGroup:String  = '';
		
		//total do grupo
		protected var valueInGroupTotal:Number  = 0;
		protected var valueOutGroupTotal:Number = 0;
		//total dos valores receita e despesa
		protected var valueInTotal:Number  = 0;
		protected var valueOutTotal:Number = 0;
		//por separação dos grupos da receita e da despesa, quando aparece o titulo zera
		protected var valueInTotalPer:Number  = 0;
		protected var valueOutTotalPer:Number = 0;
		
		protected var nameAccount:String   = '';
		protected var _beforeTotal:Boolean = false;
		
		public var title:String = "Balanço Mensal";
		protected var nameDateInterval:String = '';

		public function gnncFileReport_financial_safeBalance_month(csv_:Boolean=false)
		{
			_csvReturn = csv_;
		}
		
		override protected function __addHeader(e:*=null):void
		{
			if(!_beforeTotal)
			{
				_beforeTotal = true;
				_gnncFilePdf.__setFontStyle(8); //FONT
				_gnncFilePdf.__addCell(title,45,"L",_headerRow+2,0xDDDDDD,_headerBorder);
				
				nameAccount = Number(_object['idAccount'])>0?_object['nameAccount']:'Todas as Contas';
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(nameAccount),45,"C",_headerRow+2,0xEEEEEE,_headerBorder);
				
				if(Number(_object['idDepartament'])>0)
					_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(_object['nameDepartament']),45,"C",_headerRow+2,0xEEEEEE,_headerBorder);
				
				//_gnncFilePdf.__addCell(gnncDate.__date2Legend('',_dateStart),25,"C",_headerRow+2,0xDDDDDD,_headerBorder);
				_gnncFilePdf.__addCell(nameDateInterval,25,"C",_headerRow+2,0xDDDDDD,_headerBorder);

				_gnncFilePdf.__breakLine(_headerRow+3);
			}

			//A4 wth margin = 190 or 260 
			
			addCellHeader(
				['Nível','Sub-GRP de','Plano de Contas','Receita (R$)','Despesa (R$)'],
				[10,15,105,30,30],
				['L','L','L','R','R']
			);

			_csvHeader = new Array(
				'Nível',
				'Plano de Contas',
				String(gnncGlobalArrays._MONTH.getItemAt(_dateStart.month).label+" "+_dateStart.fullYear).toUpperCase(),
				//gnncGlobalArrays._MONTH.getItemAt(_dateStart.month).label+" "+_dateStart.fullYear,
				'TOTAL'
			);

			_gnncFilePdf.__clearAll();
		} 
		
		override protected function __addResume(object_:Object):void
		{
			_gnncFilePdf.__clearAll();
			
			var _normalBg:uint   = Number(object_.LEVEL)==0 ? 0xDDDDDD : (object_.LEVEL==1) ? gnncFileReport._normalBg : (object_.LEVEL==2) ? 0xEEEEEE : gnncFileReport._normalBg;
			var _normalRow:uint  = Number(object_.LEVEL)==0 ? gnncFileReport._normalRow+1 : gnncFileReport._normalRow;
			var space:String 	 = Number(object_.LEVEL)==0 ? "": Number(object_.LEVEL)==1 ? "    " : Number(object_.LEVEL)==2 ? "      " : "        "; 
			var borderColor:uint = 0xAAAAAA;
			
			if(firstTime != 0 && object_.LEVEL == 0 && ( nameKeyGroup!=object_.NAME_GROUP || nameKeyFather!=object_.NAME_FATHER ) ){
				
				//A4 wth margin = 190 or 260 
				_gnncFilePdf.__addLine(0x444444,0.3);
				
				_gnncFilePdf.__clearAll();
				_gnncFilePdf.__setFontStyle(_normalFont-2,0x000000); //font
				_gnncFilePdf.__addCell("",25,"C",_normalRow,0,0);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(nameKeyFather),75,"L",_normalRow,_headerBg,borderColor);
				_gnncFilePdf.__addCell("Total do Grupo",25,"C",_normalRow,_headerBg,borderColor);
				_gnncFilePdf.__addCell("R$",5,"C",_normalRow,_headerBg,borderColor);
				
				_gnncFilePdf.__setFontStyle( _normalFont); //FONT
				_gnncFilePdf.__setFontWeight(false,_normalFont);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueInGroupTotal,2,"")	,30,"R",_normalRow,_headerBg,borderColor);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueOutGroupTotal,2,"")	,30,"R",_normalRow,_headerBg,borderColor);
				
				_gnncFilePdf.__breakLine(_normalRow+3);

				var csvTotal:Array = new Array( 
					'',
					"Total do Grupo",
					space+gnncData.__firstLetterUpperCase(nameKeyFather)
				);

				_csvContent += csvTotal.join(_csvSeparator) + _csvBreakLine;

			}

			_gnncFilePdf.__clearAll();
			_gnncFilePdf.__setFontStyle(_normalFont+1,0x000000); //font
			_gnncFilePdf.__setFontWeight(false,_normalFont+1);

			_gnncFilePdf.__addCell("",25,"C",_normalRow+2,0,0);
			//_gnncFilePdf.__addCell("Resumo das Despesas do mês de "+nameMonth     ,105,"L",_normalRow+2,_headerBg,borderColor);
			_gnncFilePdf.__addCell("Resumo das Despesas "+nameDateInterval     ,105,"L",_normalRow+2,_headerBg,borderColor);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueInTotalPer,2,"")   ,30 ,"R",_normalRow+2,_headerBg,borderColor);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueOutTotalPer,2,"")  ,30 ,"R",_normalRow+2,_headerBg,borderColor);
			_gnncFilePdf.__breakLine(_normalRow+2);

			_gnncFilePdf.__breakLine(4);
			
			_gnncFilePdf.__addLine(0x444444,0.3);
			_gnncFilePdf.__addCell("",25,"C",_normalRow+2,0,0);
			_gnncFilePdf.__addCell("Resumo"                                       ,105,"L",_normalRow+2,_headerBg,borderColor);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueInTotal,2,"")   ,30 ,"R",_normalRow+2,_headerBg,borderColor);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueOutTotal,2,"")  ,30 ,"R",_normalRow+2,_headerBg,borderColor);
			_gnncFilePdf.__breakLine(_normalRow+2);

			_gnncFilePdf.__addCell("",25,"C",_normalRow+2,0,0);
			_gnncFilePdf.__addCell("Balanço"                                      ,105,"L",_normalRow+2,_headerBg,borderColor);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueInTotal-valueOutTotal,2,"")  ,60 ,"R",_normalRow+2,_headerBg,borderColor);
			_gnncFilePdf.__breakLine(_normalRow+3);

			_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
			_gnncFilePdf.__addCellInLine("* As transferências não são demonstradas neste relatório.","L",4);
			_gnncFilePdf.__addCellInLine("* Plano de contas que contem receita e despesa são valores estornados.","L",4);

			var csvResume:Array = new Array( 
				'',
				'',
				"Resumo dos Meses (Total do Balanço R$)"
				//gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_PREV,2,""),
				//gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_FINAL,2,""),
				//gnncDataNumber.__safeReal(M3+"%",2,"")
			);

			_csvContent += _csvSeparator + _csvBreakLine;
			_csvContent += csvResume.join(_csvSeparator) + _csvBreakLine;
			_csvContent += _csvSeparator + _csvBreakLine;

		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			_gnncFilePdf.__clearAll();

			var _normalBg:uint   = Number(object_.LEVEL)==0 ? 0xDDDDDD : (object_.LEVEL==1) ? gnncFileReport._normalBg : (object_.LEVEL==2) ? 0xEEEEEE : gnncFileReport._normalBg;
			var _normalRow:uint  = Number(object_.LEVEL)==0 ? gnncFileReport._normalRow+1 : gnncFileReport._normalRow;
			var space:String 	 = Number(object_.LEVEL)==0 ? "": object_.LEVEL==1 ? "  " : object_.LEVEL==2 ? "      " : "        "; 
			var borderColor:uint = 0xAAAAAA;

			if(firstTime != 0 && object_.LEVEL == 0 && ( nameKeyGroup!=object_.NAME_GROUP || nameKeyFather!=object_.NAME_FATHER ) ){
				
				//A4 wth margin = 190 or 260 
				_gnncFilePdf.__addLine(0x444444,0.3);
				
				_gnncFilePdf.__clearAll();
				_gnncFilePdf.__setFontStyle(_normalFont-2,0x000000); //FONT
				_gnncFilePdf.__addCell("",25,"C",_normalRow,0,0);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(nameKeyFather),75,"L",_normalRow,_headerBg,borderColor);
				_gnncFilePdf.__addCell("Total do Grupo",25,"C",_normalRow,_headerBg,borderColor);
				_gnncFilePdf.__addCell("R$",5,"C",_normalRow,_headerBg,borderColor);
				_gnncFilePdf.__setFontStyle(_normalFont); //FONT
				_gnncFilePdf.__setFontWeight(false,_normalFont);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueInGroupTotal,2,"")	,30,"R",_normalRow,_headerBg,borderColor);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueOutGroupTotal,2,"")	,30,"R",_normalRow,_headerBg,borderColor);
				
				_gnncFilePdf.__breakLine(_normalRow+3);

				var csvTotal:Array = new Array( 
					'',
					"Total do Grupo",
					space+gnncData.__firstLetterUpperCase(nameKeyFather)
				);
				
				_csvContent += csvTotal.join(_csvSeparator) + _csvBreakLine;
				
				//zera quando muda de grupo/plano de contas
				valueInGroupTotal  = 0;
				valueOutGroupTotal = 0;
			}

			nameKeyGroup  = object_.NAME_GROUP;
			nameKeyFather = object_.NAME_FATHER ? object_.NAME_FATHER : object_.NAME_GROUP ;
			firstTime = 1;

			if(MIX!=object_.groMIX)
			{
				//_gnncFilePdf.__addCell('',260,'C',0.1,0,0); //remove style
				//_gnncFilePdf.__breakLine(0.1);

				//---------------------------------------------------------------------------------------------------------------
				//---------------------------------------------------------------------------------------------------------------
				if(i_!=0){
					_gnncFilePdf.__clearAll();
					_gnncFilePdf.__setFontStyle(_normalFont+1,0x000000); //font
					_gnncFilePdf.__setFontWeight(false,_normalFont+1);
					
					_gnncFilePdf.__addCell("",25,"C",_normalRow+2,0,0);
					_gnncFilePdf.__addCell("Resumo das Receitas "+nameDateInterval ,105,"L",_normalRow+2,_headerBg,borderColor);
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueInTotalPer,2,""),30 ,"R",_normalRow+2,_headerBg,borderColor);
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueOutTotalPer,2,""),30 ,"R",_normalRow+2,_headerBg,borderColor);
					_gnncFilePdf.__breakLine(_normalRow+2);
				}
				//---------------------------------------------------------------------------------------------------------------
				//---------------------------------------------------------------------------------------------------------------
		
				_gnncFilePdf.__clearAll();
				
				var balanceType:String = String(object_.groMIX).indexOf("OUT")<0?"Balanço - Receitas":"Balanço - Despesas";
				
				_gnncFilePdf.__setFontStyle(13,0x00000010);
				_gnncFilePdf.__setFontWeight(false,13);
				_gnncFilePdf.__addCell(balanceType,190,"C",10);
				_gnncFilePdf.__breakLine(10);
				_gnncFilePdf.__setFontWeight(true,_normalFont);
				
				var csvType:Array = new Array( 
					'',
					balanceType
				);
				
				_csvContent += _csvSeparator + _csvBreakLine;
				_csvContent += csvType.join(_csvSeparator) + _csvBreakLine;
				_csvContent += _csvSeparator + _csvBreakLine;
				
				MIX = object_.groMIX;
				
				//zera quando muda de receita pra despesa
				valueInTotalPer  = 0;
				valueOutTotalPer = 0;
			}

			valueInGroupTotal  += Number(object_.VALUE_IN_PAY);
			valueOutGroupTotal += Number(object_.VALUE_OUT_PAY);
			valueInTotal       += Number(object_.VALUE_IN_PAY); 
			valueOutTotal      += Number(object_.VALUE_OUT_PAY);
			valueInTotalPer    += Number(object_.VALUE_IN_PAY); 
			valueOutTotalPer   += Number(object_.VALUE_OUT_PAY);
			
			_gnncFilePdf.__clearAll();

			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle	(_normalFont-2); //FONT
			
			if(Number(object_.LEVEL)==0)
				_gnncFilePdf.__setFontWeight(false,_normalFont-2);

			_gnncFilePdf.__addCell(object_.LEVEL													,10,"C",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_FATHER)				,15,"L",_normalRow,_normalBg,_normalBorder);

			_gnncFilePdf.__setFontStyle( Number(object_.LEVEL)==0 ? _normalFont-1 : _normalFont-2); //FONT
			
			if(Number(object_.LEVEL)==0)
				_gnncFilePdf.__setFontWeight(false,Number(object_.LEVEL)==0 ? _normalFont-1 : _normalFont-2);

			_gnncFilePdf.__addCell(space+gnncData.__firstLetterUpperCase(object_.NAME_GROUP)		,105,"L",_normalRow,_normalBg,_normalBorder);
			
			_gnncFilePdf.__setFontStyle	(_normalFont); //FONT

			_gnncFilePdf.__addCell(Number(object_.VALUE_IN_PAY )==0?'-':gnncDataNumber.__safeReal(object_.VALUE_IN_PAY ,2,"")	,30,"R",_normalRow,0xfafafa,_normalBorder);
			_gnncFilePdf.__addCell(Number(object_.VALUE_OUT_PAY)==0?'-':gnncDataNumber.__safeReal(object_.VALUE_OUT_PAY,2,"")	,30,"R",_normalRow,0xfafafa,_normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRow);
			_gnncFilePdf.__setFontWeight(true,_normalFont-2);
			_gnncFilePdf.__clearAll();
						
			var csv:Array = new Array(
				object_.LEVEL,
				Number(object_.LEVEL)==0?'Grupo Chave':'',
				space+gnncData.__firstLetterUpperCase(object_.NAME_GROUP)
			);
			
			_csvContent += csv.join(_csvSeparator) + _csvBreakLine;
		}
		
		override protected function __filterArrayCollection(arrayC_:ArrayCollection):ArrayCollection
		{
			return new gnncDataArrayCollection().__hierarchyReport(arrayC_,'ID_GROUP','ID_FATHER','LEVEL','NAME_GROUP');
			//arrayC_ = new gnncDataArrayCollection().__hierarchy(arrayC_,'ID_GROUP','ID_FATHER','LEVEL','NAME_GROUP');
			//return new gnncDataArrayCollection().__hierarchy(arrayC_,'ID_GROUP','ID_FATHER','LEVEL','NAME_GROUP');
		}		
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			_gnncFilePdf._pageOrientation = Orientation.PORTRAIT;
			_fileName = "DAYBYDAY - MONEY - "+title;
			_documentTitle = "Plano de Contas -  "+title+" - "+gnncGlobalArrays._MONTH.getItemAt(_dateStart.month).label+" "+_dateStart.fullYear;

			nameDateInterval = gnncGlobalArrays._MONTH.getItemAt(_dateStart.month).label+" "+_dateStart.fullYear;

			var idAccount:String 		= _object['idAccount']		? " AND fin.ID_FINANCIAL_ACCOUNT = '" + _object['idAccount'] 	+ "' " : '' ;
			var idDepartament:String 	= _object['idDepartament']	? " AND fin.ID_DEPARTAMENT = '" 	+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= _object['idGroup']		? " AND fin.ID_GROUP = '" 			+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= _object['idCategory']		? " AND fin.ID_CATEGORY = '" 		+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= _object['documentType']	? " AND fin.DOCUMENT_TYPE = '" 		+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= _object['payType']		? " AND fin.PAY_TYPE = '" 			+ _object['payType'] 		+ "' " : '' ;
						
			var filter:String = idDepartament + idAccount;
			var dateFull:String   = _dateStart.fullYear+"-"+gnncDataNumber.__setZero(_dateStart.month+1)+"-00";

			_sql = "" +
				
				" Select " +   
                " gro.ID, " + 
                " ''         as NAME_FATHER, " + 
                " gro.ID_FATHER as ID_FATHER, " + 
                " gro.LEVEL  as LEVEL, " +   
                " gro.MIX    as groMIX, " +   
                " gro.ID     as ID_GROUP, " +  
                " gro.NAME   as NAME_GROUP, " + 
				//" round(coalesce(SUM(fin.VALUE_IN_PAY ),0),2) as VALUE_IN_PAY, " + 
				//" round(coalesce(SUM(fin.VALUE_OUT_PAY),0),2) as VALUE_OUT_PAY   " + 

                " coalesce((select round(coalesce(SUM(fin.VALUE_IN_PAY ),0),2) from dbd_financial as fin where LEFT(fin.DATE_FINAL,7) like LEFT('"+dateFull+"',7) AND fin.MIX <> 'FINANCIAL_TRANS' AND gro.ID = fin.ID_GROUP AND fin.VALUE_IN_PAY > 0  "+filter+"),0) as VALUE_IN_PAY, " +
                " coalesce((select round(coalesce(SUM(fin.VALUE_OUT_PAY),0),2) from dbd_financial as fin where LEFT(fin.DATE_FINAL,7) like LEFT('"+dateFull+"',7) AND fin.MIX <> 'FINANCIAL_TRANS' AND gro.ID = fin.ID_GROUP AND fin.VALUE_OUT_PAY > 0 "+filter+"),0) as VALUE_OUT_PAY " +

				" from dbd_group as gro" + //ON ( fin.ID_GROUP = gro.ID ) " + 
                " where " + 
				" (gro.MIX = 'FINANCIAL_OUT' OR gro.MIX = 'FINANCIAL_IN') AND  " + 
                " gro.LEVEL = 0 " + 
                " group by gro.ID " + 
			
                " UNION ALL " + 
			
                " Select " + 
                " gro.ID, " + 
                " (Select NAME from dbd_group WHERE ID = gro.ID_FATHER) as NAME_FATHER, " + 
                " gro.ID_FATHER as ID_FATHER, " + 
                " gro.LEVEL     as LEVEL, " + 
                " gro.MIX       as groMIX, " + 
                " gro.ID        as ID_GROUP, " + 
                " gro.NAME      as NAME_GROUP, " + 
                " round(coalesce(SUM(fin.VALUE_IN_PAY ),0),2) as VALUE_IN_PAY, " + 
                " round(coalesce(SUM(fin.VALUE_OUT_PAY),0),2) as VALUE_OUT_PAY   " + 

                " from dbd_group as gro inner JOIN dbd_financial as fin ON ( fin.ID_GROUP = gro.ID )  " + 
                " where " + 
                " (gro.MIX = 'FINANCIAL_OUT' OR gro.MIX = 'FINANCIAL_IN')  AND  " + 
                " LEFT(fin.DATE_FINAL,7) like LEFT('"+dateFull+"',7) AND  " + 
                " fin.MIX <> 'FINANCIAL_TRANS' " + 
				filter +
				" group by gro.ID " + 

                " order by groMIX asc,NAME_FATHER asc,NAME_GROUP asc ";
			
			//new gnncAlert(gnncGlobalStatic._parent).__alert(_sql);
			//gnncGlobalLog.__add('0');
		}

		private function __setSql():void
		{
			//gnncGlobalLog.__add('1');

		}


	}
}