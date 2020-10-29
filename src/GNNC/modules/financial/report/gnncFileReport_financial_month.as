package GNNC.modules.financial.report
{
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.DateUtils;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.file.gnncFileReport;
	
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.colors.CMYKColor;
	import org.alivepdf.colors.SpotColor;

	public class gnncFileReport_financial_month extends gnncFileReport
	{
		private var valueInTotal:Number = 0;
		private var valueOutTotal:Number = 0;
		private var valueTotal:Number = 0;
		private var financialRows:uint = 0;
		
		private var week0:uint = 0;
		private var week1:uint = 0;
		private var week2:uint = 0;
		private var week3:uint = 0;
		private var week4:uint = 0;
		private var week5:uint = 0;
		private var week6:uint = 0;

		public function gnncFileReport_financial_month()
		{
		}
		
		override protected function __addHeader(e:*=null):void
		{
			addCellTitle(
				'Movimento de Caixa Diário/Mensal',
				'Mês de '+getDateEndMonth()+' '+_dateEnd.fullYear
			);

			addCellHeader(
				['Data','Dia','Semana','Lançamentos','Receitas (R$)','Despesas (R$)','Balanço do Dia'],
				[22,10,18,20,40,40,40]
			);
		} 
		
		override protected function __addResume(object_:Object):void
		{
			addCellResume(
				[
					'Resumo',
					financialRows,
					gnncDataNumber.__safeReal(valueInTotal),
					gnncDataNumber.__safeReal(valueOutTotal),
					gnncDataNumber.__safeReal(valueTotal)
				],
				[50,20,40,40,40],null,null,
				['L','C','R','R','R']
			);
			
			/*
			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();

			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__breakLine(2);

			_gnncFilePdf.__setFontWeight(false,_normalFont+1);
			_gnncFilePdf.__addLine(0x444444,0.3);
			_gnncFilePdf.__addCell("Resumo",50,"L",_normalRow+4,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(financialRows+'',20,"C",_normalRow+4,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueInTotal)	,40,"R",_normalRow+4,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueOutTotal)	,40,"R",_normalRow+4,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(valueTotal), 40,"R",_normalRow+4,_headerBg,_normalBorder);
			*/

			_gnncFilePdf.__breakLine(2);

			_gnncFilePdf.__setFontWeight(true,_normalFont);

			_gnncFilePdf.__addCell(week0+'', 27.14,"C",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(week1+'', 27.14,"C",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(week2+'', 27.14,"C",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(week3+'', 27.14,"C",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(week4+'', 27.14,"C",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(week5+'', 27.14,"C",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(week6+'', 27.14,"C",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow+2);

			_gnncFilePdf.__addCell(gnncGlobalArrays._WEEK.getItemAt(0).label, 27.14,"C",_normalRow+2,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncGlobalArrays._WEEK.getItemAt(1).label, 27.14,"C",_normalRow+2,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncGlobalArrays._WEEK.getItemAt(2).label, 27.14,"C",_normalRow+2,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncGlobalArrays._WEEK.getItemAt(3).label, 27.14,"C",_normalRow+2,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncGlobalArrays._WEEK.getItemAt(4).label, 27.14,"C",_normalRow+2,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncGlobalArrays._WEEK.getItemAt(5).label, 27.14,"C",_normalRow+2,_headerBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncGlobalArrays._WEEK.getItemAt(6).label, 27.14,"C",_normalRow+2,_headerBg,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow+2);

		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			return;
			
			//A4 wth margin = 190 or 260
			//return;

			//_gnncFilePdf.__setXY(_gnncFilePdf._pageMarginLeft,_gnncFilePdf._pageHeightWithoutMargin+0);
			
			var arrIn:ArrayCollection = new ArrayCollection([
				//{label:'Tipo: Receita' ,percent:0},
				{label:'Dinheiro'      ,percent:2},
				{label:'C.Crédito'     ,percent:2},
				{label:'C.Débito'      ,percent:2},
				{label:'Cheque'        ,percent:3},
				{label:'Crédito Próp.' ,percent:3},
				{label:'Depósito CC'   ,percent:3},
				{label:'Transf. Banc.' ,percent:4},
				{label:'Outros'        ,percent:1}
			]);
			_gnncFilePdf.__addChartPie(arrIn,true,20,0,0,true,3,2,0.5,'Receita');
			
			return;

			// create a SpotColor object with a name and specific CMYKColor
			var sc:SpotColor = new SpotColor ("PANTONE 280 CV", new CMYKColor ( 90, 20, 30, 10 ) );
			
			// pass it to the lineStyle, textStyle or beginFill methods
			_gnncFilePdf._PDF.lineStyle( sc );
			
			// draw the spot color
			_gnncFilePdf._PDF.drawRect( new Rectangle ( 10, 10, 30, 30 ) );

		}

		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			var h:uint = 7;
			var w:uint = DateUtils.dayOfWeek(gnncDate.__string2Date(object_.DATE_FINAL,false));
			var wLabel:String = gnncGlobalArrays._WEEK.getItemAt(w).label;
			var bg:uint = 0;
			var bgTotal:uint = Number(object_.VALUE_TOTAL) > 0 ? _headerBg : 0xcccccc ;
			
			switch(w){
				case 0: week0 += 1; bg = 0xdddddd; break;
				case 1: week1 += 1; bg = 0xeeeeee; break;
				case 2: week2 += 1; bg = 0xffffff; break;
				case 3: week3 += 1; bg = 0xffffff; break;
				case 4: week4 += 1; bg = 0xffffff; break;
				case 5: week5 += 1; bg = 0xffffff; break;
				case 6: week6 += 1; bg = 0xffffff; break;
			}

			//A4 wth margin = 190 or 260 
			
			_gnncFilePdf.__setFontStyle(_normalFont);
			_gnncFilePdf.__setFontWeight(true,_normalFont);
			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_FINAL)				,22,"C",_normalRow+2,_normalBg,_normalBorder);			
			
			_gnncFilePdf.__setFontStyle(_normalFont+1,0xffffff);
			_gnncFilePdf.__setFontWeight(false,_normalFont);
			_gnncFilePdf.__addCell(gnncDataNumber.__setZero(object_.DAY)					,10,"C",_normalRow+2,0x666666,_normalBorder);			

			_gnncFilePdf.__setFontStyle(_normalFont);
			_gnncFilePdf.__setFontWeight(true,_normalFont);
			_gnncFilePdf.__addCell(wLabel                                                   ,18,"C",_normalRow+2,bg,_normalBorder);
			_gnncFilePdf.__addCell(object_.ROWS_FINANCIAL									,20,"C",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN,2,'')			,40,"R",_normalRow+2,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT,2,'')		,40,"R",_normalRow+2,_normalBg,_normalBorder);
			
			_gnncFilePdf.__setFontWeight(false,_normalFont+1);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_TOTAL,2,'')		,40,"R",_normalRow+2,bgTotal,_normalBorder);
			_gnncFilePdf.__breakLine(_normalRow+2);
			
			//w==1
			//_gnncFilePdf.__addLine(0x444444,0.3);
			
			valueInTotal  += Number(object_.VALUE_IN);
			valueOutTotal += Number(object_.VALUE_OUT);
			valueTotal    += Number(object_.VALUE_TOTAL);
			financialRows += Number(object_.ROWS_FINANCIAL);
		}
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			_fileName 		= "DAYBYDAY - MONEY - Movimento Mensal";
			_documentTitle 	= "Movimento de Caixa Diário/Mensal - Período " +getDateEndMonth()+' '+_dateEnd.fullYear
			
			var _whereDateGeneral:String = " " +
				" LEFT(fin.DATE_FINAL,7) >= LEFT('"+getDateStart()+" ',7) AND " +
				" LEFT(fin.DATE_FINAL,7) <= LEFT('"+getDateEnd()+" ',7) " ;

			_sql = "" +
				
				" select " +
				
				" LEFT(fin.DATE_FINAL,10) as DATE_FINAL, " +
				" COUNT(fin.ID) as ROWS_FINANCIAL, " +

				//valor + juro + multa - desconto de pontualidade
				" CASE WHEN DATEDIFF(NOW(),fin.DATE_END) > 0 THEN ROUND((fin.VALUE_IN + fin.VALUE_OUT) * (1 + ((fin.FINE_PERCENT/100)/fin.FINE_PERCENT_TIME) * DATEDIFF(NOW(),fin.DATE_END) )+(fin.FINE_VALUE)+(fin.FINE_VALUE_PERCENT/100*(fin.VALUE_IN + fin.VALUE_OUT)),2) ELSE ROUND((fin.VALUE_IN + fin.VALUE_OUT)-fin.DISCOUNT_PUNCTUALITY,2) END as VALUE_FINAL, " +

				" coalesce(DAY(fin.DATE_FINAL),0) as DAY, " +
				" coalesce(ROUND(SUM(fin.VALUE_IN_PAY),2),0) as VALUE_IN, " +
				" coalesce(ROUND(SUM(fin.VALUE_OUT_PAY),2),0) as VALUE_OUT, " + 
				" coalesce(ROUND(SUM(fin.VALUE_IN_PAY)-SUM(fin.VALUE_OUT_PAY),2),0) as VALUE_TOTAL " +

				" from " +
				" dbd_financial as fin " +
				
				" where " + 
				_whereDateGeneral + 
				" AND fin.MIX <> 'FINANCIAL_TRANS' " +
				" AND (fin.VALUE_IN_PAY > 0  OR fin.VALUE_OUT_PAY > 0) " + 

				" group by " +
				" DAY " +
				" ORDER BY " +
				" fin.DATE_FINAL asc,DAY asc ";
		
		}
		
	}
}