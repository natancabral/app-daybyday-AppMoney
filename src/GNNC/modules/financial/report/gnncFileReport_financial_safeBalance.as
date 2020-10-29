package GNNC.modules.financial.report
{
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataArrayCollection;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.DateUtils;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.globals.gnncGlobalLog;
	import GNNC.data.file.gnncFileReport;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.layout.Orientation;
	
	public class gnncFileReport_financial_safeBalance extends gnncFileReport
	{
		
		private var firstTime:uint = 0;
		private var nameKeyFather:String = '';
		private var nameKeyGroup:String = '';
		
		private var M1:Number = 0;
		private var M2:Number = 0;
		private var M3:Number = 0;
		private var M4:Number = 0;
		private var M5:Number = 0;
		private var M6:Number = 0;
		private var M7:Number = 0;
		private var M8:Number = 0;
		private var M9:Number = 0;
		private var M10:Number = 0;
		private var M11:Number = 0;
		private var M12:Number = 0;
		private var M0:Number = 0;
	
		public function gnncFileReport_financial_safeBalance(csv_:Boolean=false)
		{
			_csvReturn = csv_;
		}
		
		override protected function __addHeader(e:*=null):void
		{
			_gnncFilePdf.__clearAll();

			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle(_headerFont); //FONT
			_gnncFilePdf.__addCell("NÍVEL"												,8,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("SUB-GRP DE"											,15,"L",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("PLANO DE CONTAS"									,45,"L",_headerRow,_headerBg,_headerBorder);
			
			_gnncFilePdf.__addCell("JAN/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("FEV/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("MAR/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("ABR/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("MAI/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("JUN/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("JUL/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("AGO/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("SET/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("OUT/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("NOV/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("DEZ/"+_dateStart.fullYear							,16,"C",_headerRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("TOTAL (R$)"											,16,"C",_headerRow,_headerBg,_headerBorder);
			
			_gnncFilePdf.__breakLine(_headerRow+1);

			_csvHeader = new Array(
				'Nível',
				'Tipo',
				'Plano de Contas',
				'JAN',
				'FEV',
				'MAR',
				'ABR',
				'MAI',
				'JUN',
				'JUL',
				'AGO',
				'SET',
				'OUT',
				'NOV',
				'DEZ',
				'TOTAL'
			);

			
			_gnncFilePdf.__clearAll();
		} 
		
		override protected function __addResume(object_:Object):void
		{
			_gnncFilePdf.__clearAll();
			
			var _normalBg:uint  = (!object_.LEVEL) ? 0xDDDDDD : (object_.LEVEL==1) ? gnncFileReport._normalBg : (object_.LEVEL==2) ? 0xEEEEEE : gnncFileReport._normalBg;
			var _normalRow:uint = (!object_.LEVEL) ? gnncFileReport._normalRow+1 : gnncFileReport._normalRow;
			var space:String 	= !object_.LEVEL ? "": object_.LEVEL==1 ? "  " : object_.LEVEL==2 ? "      " : "        "; 
			
			if(firstTime != 0 && object_.LEVEL == 0 && ( nameKeyGroup!=object_.NAME_GROUP || nameKeyFather!=object_.NAME_FATHER ) ){
				
				//A4 wth margin = 190 or 260 
				//_gnncFilePdf.__breakLine(0.2);
				_gnncFilePdf.__addLine(0x444444,0.3);
				//_gnncFilePdf.__breakLine(0.2);
				
				_gnncFilePdf.__setFontStyle(_normalFont-2,0xffffff); //FONT
				_gnncFilePdf.__addCell("Total do Grupo",23,"C",_normalRow,0x777777,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(nameKeyFather),45,"L",_normalRow,0x777777,0xCCCCCC);
				
				_gnncFilePdf.__setFontStyle( _normalFont-2); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M1,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M2,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M3,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M4,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M5,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M6,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M7,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M8,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M9,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M10,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M11,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M12,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				
				M0 = M1+M2+M3+M4+M5+M6+M7+M8+M9+M10+M11+M12;
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M0,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				
				_gnncFilePdf.__breakLine(_normalRow+1);

				var csvTotal:Array = new Array( 
					'',
					"Total do Grupo",
					space+gnncData.__firstLetterUpperCase(nameKeyFather) ,
					gnncDataNumber.__safeReal(M1,2,""),
					gnncDataNumber.__safeReal(M2,2,""),
					gnncDataNumber.__safeReal(M3,2,""),
					gnncDataNumber.__safeReal(M4,2,""),
					gnncDataNumber.__safeReal(M5,2,""),
					gnncDataNumber.__safeReal(M6,2,""),
					gnncDataNumber.__safeReal(M7,2,""),
					gnncDataNumber.__safeReal(M8,2,""),
					gnncDataNumber.__safeReal(M9,2,""),
					gnncDataNumber.__safeReal(M10,2,""),
					gnncDataNumber.__safeReal(M11,2,""),
					gnncDataNumber.__safeReal(M12,2,""),
					gnncDataNumber.__safeReal(M0,2,"")
				);

				_csvContent += csvTotal.join(_csvSeparator) + _csvBreakLine;

			}

			
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle(_titleFont,0x000000);
			_gnncFilePdf.__addCell("RESUMO DOS MESES",260,"C",10);
			_gnncFilePdf.__breakLine(10);
			
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell("Total R$ (soma dos valores)"										,68,"L",_normalRow+3,_normalBg,_normalBorder);
			
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_1_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_1_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_2_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_2_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_3_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_3_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_4_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_4_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_5_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_5_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_6_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_6_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_7_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_7_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_8_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_8_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_9_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_9_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_10_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_10_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_11_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_11_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_12_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_12_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_0_TOTAL?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_0_TOTAL,2,"")	,16,"R",_normalRow+3,_normalBg,_normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRow+3);
			
			_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
			_gnncFilePdf.__addCellInLine("* As transferências não são demonstradas neste relatório.","L",7);

			
			var csvResume:Array = new Array( 
				'',
				'',
				"Resumo dos Meses (Total do Balanço R$)",
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_1_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_2_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_3_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_4_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_5_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_6_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_7_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_8_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_9_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_10_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_11_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_12_TOTAL,2,""),
				gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_0_TOTAL,2,"")
			);

			_csvContent += _csvSeparator + _csvBreakLine;
			_csvContent += csvResume.join(_csvSeparator) + _csvBreakLine;
			_csvContent += _csvSeparator + _csvBreakLine;

		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		private var MIX:String = '';
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			_gnncFilePdf.__clearAll();

			var _normalBg:uint  = (!object_.LEVEL) ? 0xDDDDDD : (object_.LEVEL==1) ? gnncFileReport._normalBg : (object_.LEVEL==2) ? 0xEEEEEE : gnncFileReport._normalBg;
			var _normalRow:uint = (!object_.LEVEL) ? gnncFileReport._normalRow+1 : gnncFileReport._normalRow;
			var space:String 	= !object_.LEVEL ? "": object_.LEVEL==1 ? "   " : object_.LEVEL==2 ? "      " : "         "; 

			if(firstTime != 0 && object_.LEVEL == 0 && ( nameKeyGroup!=object_.NAME_GROUP || nameKeyFather!=object_.NAME_FATHER ) ){
				
				//A4 wth margin = 190 or 260 
				//_gnncFilePdf.__breakLine(0.2);
				_gnncFilePdf.__addLine(0x444444,0.3);
				//_gnncFilePdf.__breakLine(0.2);
				
				_gnncFilePdf.__setFontStyle(_normalFont-2,0xffffff); //FONT
				_gnncFilePdf.__addCell("Total do Grupo",23,"C",_normalRow,0x777777,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(nameKeyFather),45,"L",_normalRow,0x777777,0xCCCCCC);
				
				_gnncFilePdf.__setFontStyle( _normalFont-2); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M1,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M2,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M3,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M4,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M5,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M6,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M7,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M8,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M9,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M10,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M11,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M12,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				
				M0 = M1+M2+M3+M4+M5+M6+M7+M8+M9+M10+M11+M12;
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(M0,2,"")		,16,"R",_normalRow,_headerBg,0xCCCCCC);
				
				_gnncFilePdf.__breakLine(_normalRow+1);

				var csvTotal:Array = new Array( 
					'',
					"Total do Grupo",
					space+gnncData.__firstLetterUpperCase(nameKeyFather) ,
					gnncDataNumber.__safeReal(M1,2,""),
					gnncDataNumber.__safeReal(M2,2,""),
					gnncDataNumber.__safeReal(M3,2,""),
					gnncDataNumber.__safeReal(M4,2,""),
					gnncDataNumber.__safeReal(M5,2,""),
					gnncDataNumber.__safeReal(M6,2,""),
					gnncDataNumber.__safeReal(M7,2,""),
					gnncDataNumber.__safeReal(M8,2,""),
					gnncDataNumber.__safeReal(M9,2,""),
					gnncDataNumber.__safeReal(M10,2,""),
					gnncDataNumber.__safeReal(M11,2,""),
					gnncDataNumber.__safeReal(M12,2,""),
					gnncDataNumber.__safeReal(M0,2,"")
				);
				
				_csvContent += csvTotal.join(_csvSeparator) + _csvBreakLine;
				
				M1 = 0;
				M2 = 0;
				M3 = 0;
				M4 = 0;
				M5 = 0;
				M6 = 0;
				M7 = 0;
				M8 = 0;
				M9 = 0;
				M10 = 0;
				M11 = 0;
				M12 = 0;
				M0 = 0;
								
			}
			nameKeyGroup  = object_.NAME_GROUP;
			nameKeyFather = object_.NAME_FATHER ? object_.NAME_FATHER : object_.NAME_GROUP ;
			firstTime = 1;

			if(MIX!=object_.MIX)
			{
				//_gnncFilePdf.__addCell('',260,'C',0.1,0,0); //remove style
				//_gnncFilePdf.__breakLine(0.1);
				
				_gnncFilePdf.__clearAll();
				
				var balanceType:String = String(object_.MIX).indexOf("OUT")<0?"Balanço - Receitas":"Balanço - Despesas";
				
				_gnncFilePdf.__setFontStyle(_titleFont,0x00000010);
				_gnncFilePdf.__setFontWeight(false,_titleFont);
				_gnncFilePdf.__addCell(balanceType,290,"C",10);
				_gnncFilePdf.__breakLine(10);
				MIX = object_.MIX;
				_gnncFilePdf.__setFontWeight(true,_normalFont);
				
				var csvType:Array = new Array( 
					'',
					balanceType
				);
				
				_csvContent += _csvSeparator + _csvBreakLine;
				_csvContent += csvType.join(_csvSeparator) + _csvBreakLine;
				_csvContent += _csvSeparator + _csvBreakLine;
				
			}

			M1 = M1 + Number(object_.VALUE_TOTAL_MONTH_1);
			M2 = M2 + Number(object_.VALUE_TOTAL_MONTH_2);
			M3 = M3 + Number(object_.VALUE_TOTAL_MONTH_3);
			M4 = M4 + Number(object_.VALUE_TOTAL_MONTH_4);
			M5 = M5 + Number(object_.VALUE_TOTAL_MONTH_5);
			M6 = M6 + Number(object_.VALUE_TOTAL_MONTH_6);
			M7 = M7 + Number(object_.VALUE_TOTAL_MONTH_7);
			M8 = M8 + Number(object_.VALUE_TOTAL_MONTH_8);
			M9 = M9 + Number(object_.VALUE_TOTAL_MONTH_9);
			M10 = M10 + Number(object_.VALUE_TOTAL_MONTH_10);
			M11 = M11 + Number(object_.VALUE_TOTAL_MONTH_11);
			M12 = M12 + Number(object_.VALUE_TOTAL_MONTH_12);

			//M0 = M1+M2+M3+M4+M5+M6+M7+M8+M9+M10+M11+M12;

			M0 = Number(
				Number(object_.VALUE_TOTAL_MONTH_1) +
				Number(object_.VALUE_TOTAL_MONTH_2) +
				Number(object_.VALUE_TOTAL_MONTH_3) +
				Number(object_.VALUE_TOTAL_MONTH_4) +
				Number(object_.VALUE_TOTAL_MONTH_5) +
				Number(object_.VALUE_TOTAL_MONTH_6) +
				Number(object_.VALUE_TOTAL_MONTH_7) +
				Number(object_.VALUE_TOTAL_MONTH_8) +
				Number(object_.VALUE_TOTAL_MONTH_9) +
				Number(object_.VALUE_TOTAL_MONTH_10) +
				Number(object_.VALUE_TOTAL_MONTH_11) +
				Number(object_.VALUE_TOTAL_MONTH_12)
			);
			
			_gnncFilePdf.__clearAll();

			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__setFontStyle	(_normalFont-2); //FONT
			if(!object_.LEVEL)
			_gnncFilePdf.__setFontWeight(false,_normalFont-2);

			_gnncFilePdf.__addCell(object_.LEVEL													,8 ,"L",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_FATHER)				,15,"L",_normalRow,_normalBg,_normalBorder);

			_gnncFilePdf.__setFontStyle( !object_.LEVEL ? _normalFont-1 : _normalFont-2); //FONT
			if(!object_.LEVEL)
				_gnncFilePdf.__setFontWeight(false,!object_.LEVEL ? _normalFont-1 : _normalFont-2);

			_gnncFilePdf.__addCell(space+gnncData.__firstLetterUpperCase(object_.NAME_GROUP)		,45,"L",_normalRow,_normalBg,_normalBorder);
			
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_1 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_1,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_2 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_2,2,"")		,16,"R",_normalRow,0xfafafa,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_3 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_3,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_4 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_4,2,"")		,16,"R",_normalRow,0xfafafa,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_5 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_5,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_6 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_6,2,"")		,16,"R",_normalRow,0xfafafa,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_7 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_7,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_8 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_8,2,"")		,16,"R",_normalRow,0xfafafa,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_9 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_9,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_10?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_10,2,"")		,16,"R",_normalRow,0xfafafa,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_11?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_11,2,"")		,16,"R",_normalRow,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(!object_.VALUE_TOTAL_MONTH_12?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_12,2,"")		,16,"R",_normalRow,0xfafafa,_normalBorder);
			
			_gnncFilePdf.__addCell(!M0?'-':gnncDataNumber.__safeReal(M0,2,""),16,"R",_normalRow,_normalBg,_normalBorder);
			
			_gnncFilePdf.__breakLine(_normalRow);

			_gnncFilePdf.__setFontWeight(true,_normalFont-2);

			_gnncFilePdf.__clearAll();
						
			/*if(id_father != object_.ID_FATHER)
			_gnncFilePdf.__addLine(0x000000,0.2);
			else
			id_father = object_.ID_FATHER;*/
			
			var csv:Array = new Array(
				object_.LEVEL,
				object_.LEVEL==0?'Grupo Chave':'',
				//gnncData.__firstLetterUpperCase(object_.NAME_FATHER),
				space+gnncData.__firstLetterUpperCase(object_.NAME_GROUP) ,
				!object_.VALUE_TOTAL_MONTH_1  ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_1,2,"") ,
				!object_.VALUE_TOTAL_MONTH_2  ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_2,2,"") ,
				!object_.VALUE_TOTAL_MONTH_3  ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_3,2,"") ,
				!object_.VALUE_TOTAL_MONTH_4  ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_4,2,"") ,
				!object_.VALUE_TOTAL_MONTH_5  ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_5,2,"") ,
				!object_.VALUE_TOTAL_MONTH_6  ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_6,2,"") ,
				!object_.VALUE_TOTAL_MONTH_7  ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_7,2,"") ,
				!object_.VALUE_TOTAL_MONTH_8  ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_8,2,"") ,
				!object_.VALUE_TOTAL_MONTH_9  ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_9,2,"") ,
				!object_.VALUE_TOTAL_MONTH_10 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_10,2,"") ,
				!object_.VALUE_TOTAL_MONTH_11 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_11,2,"") ,
				!object_.VALUE_TOTAL_MONTH_12 ?'-':gnncDataNumber.__safeReal(object_.VALUE_TOTAL_MONTH_12,2,"") ,
				!M0?'-':gnncDataNumber.__safeReal(M0,2,"")
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
			_gnncFilePdf._pageOrientation = Orientation.LANDSCAPE;
			_fileName = "DAYBYDAY - MONEY - Balanco";
			_documentTitle = "Plano de Contas -  Balanço - [ Receita (-) Despesa ] - "+_dateStart.fullYear;

			var idAccount:String 		= _object['idAccount']		? " AND f.ID_FINANCIAL_ACCOUNT = '" + _object['idAccount'] 		+ "' " : '' ;
			var idDepartament:String 	= _object['idDepartament']	? " AND f.ID_DEPARTAMENT = '" 		+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= _object['idGroup']		? " AND f.ID_GROUP = '" 			+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= _object['idCategory']		? " AND f.ID_CATEGORY = '" 			+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= _object['documentType']	? " AND f.DOCUMENT_TYPE = '" 		+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= _object['payType']		? " AND f.PAY_TYPE = '" 			+ _object['payType'] 		+ "' " : '' ;
			
			//start
			var dateStartCurrent:String   = gnncDate.__date2String(_dateStart,false);
			var dateStartYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart),false);
			//end
			var dateEndCurrent:String   = gnncDate.__date2String(_dateEnd,false);
			var dateEndYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateEnd),false);

			var dateLegend:String = dateStartCurrent.substr(0,10)==dateEndCurrent.substr(0,10)? gnncDate.__date2Legend('',_dateStart) : gnncDate.__date2Legend('',_dateStart) + ' até ' + gnncDate.__date2Legend('',_dateEnd);
			
			var dateMonthStart:String = gnncGlobalArrays._MONTH.getItemAt(_dateStart.month).label;
			var dateMonthEnd:String   = gnncGlobalArrays._MONTH.getItemAt(_dateEnd.month).label;
			
			var filter:String = idDepartament + idAccount;

			_sql = "" +
				" Select " +
				//" (select ID from dbd_group where dbd_group.ID like ID_GROUP) as ID_GROUP, "+
				//" (select NAME from dbd_group where dbd_group.ID like ID_GROUP) as NAME_GROUP, "+
				//" CASE " +
				//" WHEN gro.MIX like 'FINANCIAL_IN'  THEN 'Receita' " +
				//" WHEN gro.MIX like 'FINANCIAL_OUT' THEN 'Despesa' " +
				//" END as MIX, "+
				" gro.ID_FATHER 					as ID_FATHER, " +
				" gro.LEVEL 						as LEVEL, " +
				" gro.MIX 							as MIX, " +
				" gro.NAME 							as NAME_GROUP, " +
				" (Select NAME from dbd_group WHERE ID = gro.ID_FATHER) as NAME_FATHER, " +
				" gro.ID 							as ID_GROUP, " ;
			
			for(var e:uint=1; e<=12; e++)
			{
				_sql += " (select round(SUM(f.VALUE_IN_PAY)-SUM(f.VALUE_OUT_PAY),2) from dbd_financial f where LEFT(f.DATE_FINAL,7) like LEFT('"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"',7) AND f.MIX <> 'FINANCIAL_TRANS' "+filter+" AND f.ID_GROUP = gro.ID ) as VALUE_TOTAL_MONTH_"+e+", ";
				_sql += " (select round(SUM(f.VALUE_IN_PAY)-SUM(f.VALUE_OUT_PAY),2) from dbd_financial f where LEFT(f.DATE_FINAL,7) like LEFT('"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"',7) AND f.MIX <> 'FINANCIAL_TRANS' "+filter+"					     ) as VALUE_TOTAL_MONTH_"+e+"_TOTAL, ";
			}
			
			_sql += "" +
				" (Select round(SUM(f.VALUE_IN_PAY)-SUM(f.VALUE_OUT_PAY),2) 	from dbd_financial f where YEAR(f.DATE_FINAL) like YEAR('"+_dateStart.fullYear+"') AND f.MIX <> 'FINANCIAL_TRANS' "+filter+" AND f.ID_GROUP = gro.ID ) as VALUE_TOTAL_MONTH_"+0+", "+
				" (Select round(SUM(f.VALUE_IN_PAY)-SUM(f.VALUE_OUT_PAY),2) 	from dbd_financial f where YEAR(f.DATE_FINAL) like YEAR('"+_dateStart.fullYear+"') AND f.MIX <> 'FINANCIAL_TRANS' "+filter+" 						 ) as VALUE_TOTAL_MONTH_"+0+"_TOTAL "+
				
				" from "+ 
				" dbd_group as gro "+
				
				" where " +
				" (gro.MIX = 'FINANCIAL_OUT' OR gro.MIX = 'FINANCIAL_IN') " + 
				" AND gro.MIX <> 'FINANCIAL_TRANS' "+
				" order by "+
				" gro.MIX asc,NAME_GROUP asc";
			
			//new gnncAlert().__alert(_sql);
			gnncGlobalLog.__add('0');
		}

		private function __setSql():void
		{
			gnncGlobalLog.__add('1');
			/*

			var idAccount:String 		= _object['idAccount']		? " AND ID_FINANCIAL_ACCOUNT = '" 	+ _object['idAccount'] 		+ "' " : '' ;
			var idDepartament:String 	= _object['idDepartament']	? " AND ID_DEPARTAMENT = '" 		+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= _object['idGroup']		? " AND ID_GROUP = '" 				+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= _object['idCategory']		? " AND ID_CATEGORY = '" 			+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= _object['documentType']	? " AND DOCUMENT_TYPE = '" 			+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= _object['payType']		? " AND PAY_TYPE = '" 				+ _object['payType'] 		+ "' " : '' ;
			
			//start
			var dateStartCurrent:String   = gnncDate.__date2String(_dateStart,false);
			var dateStartYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart),false);
			//end
			var dateEndCurrent:String   = gnncDate.__date2String(_dateEnd,false);
			var dateEndYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateEnd),false);

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
				_sql += " (Select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) 	from dbd_financial where DATE_FINAL >= '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"-01 00:00:00' AND DATE_FINAL <= '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"-31 23:59:59' AND MIX <> 'FINANCIAL_TRANS' AND ID_GROUP = gro.ID	) as VALUE_TOTAL_MONTH_"+e+", ";
				_sql += " (Select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) 	from dbd_financial where DATE_FINAL >= '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"-01 00:00:00' AND DATE_FINAL <= '"+_dateStart.fullYear+"-"+gnncDataNumber.__setZero(e)+"-31 23:59:59' AND MIX <> 'FINANCIAL_TRANS'						) as VALUE_TOTAL_MONTH_"+e+"_TOTAL, ";
			}
			
			_sql += "" +
				"(Select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) 	from dbd_financial where DATE_FINAL >= '"+_dateStart.fullYear+"-01-01 00:00:00' AND DATE_FINAL <= '"+_dateStart.fullYear+"-12-31 23:59:59' AND MIX <> 'FINANCIAL_TRANS' AND ID_GROUP = gro.ID	) as VALUE_TOTAL_MONTH_"+0+", "+
				"(Select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) 	from dbd_financial where DATE_FINAL >= '"+_dateStart.fullYear+"-01-01 00:00:00' AND DATE_FINAL <= '"+_dateStart.fullYear+"-12-31 23:59:59' AND MIX <> 'FINANCIAL_TRANS' 						) as VALUE_TOTAL_MONTH_"+0+"_TOTAL "+
				
				"from "+ 
				"dbd_group as gro "+
				
				"where " +
				"gro.MIX = 'FINANCIAL_OUT' OR gro.MIX = 'FINANCIAL_IN' " + 
				"AND gro.MIX <> 'FINANCIAL_TRANS' "+
				
				"order by "+
				"gro.MIX asc,NAME_GROUP asc";*/
		
		}

		
		public function __month(obj_:Object=null,dateStart_:Date=null,dateEnd_:Date=null):void
		{
			gnncGlobalLog.__add('2');
			_dateStart 					= dateStart_;
			_dateEnd 					= dateEnd_;
			
			//gnncDate.__date2String(date_,false);
			_object 				= new Object();
			_object['whereFinal']	= "";
			_object['dateStart']	= ""+gnncDate.__date2String(dateStart_).substr(0,10);
			_object['datehEnd']		= ""+gnncDate.__date2String(dateEnd_).substr(0,10);
			_object['monthStart']	= ""+gnncDate.__date2String(dateStart_).substr(5,2);
			_object['monthEnd']		= ""+gnncDate.__date2String(dateEnd_).substr(5,2);
			
			_documentTitle  		= "@@Relação de Cheques - Diário ("+gnncDate.__date2Legend('',_dateStart)+")";
			
			__setSql();
			__create();
		}

	}
}