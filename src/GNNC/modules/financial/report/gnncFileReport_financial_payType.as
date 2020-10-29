package GNNC.modules.financial.report
{
	import GNNC.UI.gnncAlert.gnncAlert;
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataArrayCollection;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.DateUtils;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.file.gnncFileReport;

	public class gnncFileReport_financial_payType extends gnncFileReport
	{
		public function gnncFileReport_financial_payType()
		{
		}

		private var tt:String = '';
		private var tl:String = '';
		private var idDepart:uint = 0;

		private var totalValueIn:Number = 0;
		private var totalValueOut:Number = 0;
		private var totalValueInPerDepartament:Number = 0;
		private var totalValueOutPerDepartament:Number = 0;

		override protected function __addHeader(e:*=null):void
		{
			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();

			//start
			var dateStartCurrent:String   = gnncDate.__date2String(_dateStart,false);
			var dateStartYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart),false);
			//end
			var dateEndCurrent:String   = gnncDate.__date2String(_dateEnd,false);
			var dateEndYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateEnd),false);
			
			var dateLegend:String = dateStartCurrent.substr(0,10)==dateEndCurrent.substr(0,10)? gnncDate.__date2Legend('',_dateStart) : gnncDate.__date2Legend('',_dateStart) + ' até ' + gnncDate.__date2Legend('',_dateEnd);
			
			var days:Number = DateUtils.dateDiff(DateUtils.DAY_OF_MONTH,_dateStart,_dateEnd)+1;
			var dayesLegend:String = ' ('+days+' '+(days==1?'dia':'dias')+')';

			//-------------------------------------------------------------------------------------
			_gnncFilePdf.__setFontWeight(true,13);
			_gnncFilePdf.__addCellInLine('Formas de Pagamentos por Centro de Custos','C',8);
			_gnncFilePdf.__setFontWeight(true,_gnncFilePdf._normalFontSize-1);
			_gnncFilePdf.__addCellInLine(dateLegend + dayesLegend,'C',3);
			//-------------------------------------------------------------------------------------
			
			_gnncFilePdf.__breakLine(4);
			
			//A4 wth margin = 190 or 260 
			/*_gnncFilePdf.__setFontStyle(_headerFont); //FONT
			_gnncFilePdf.__addCell("DEPARTAMENTO"										,40,"L",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("REF."												,20,"L",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("TIPO DE PAGAMENTO"									,30,"L",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("RECEITA (R$)"										,20,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("QNT",10,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("DESPESA (R$)"										,20,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell("QNT",10,"C",_normalRow,_headerBg,_headerBorder);
			_gnncFilePdf.__breakLine(_normalRow+1);

			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();*/
		} 
		
		override protected function __addResume(object_:Object):void
		{
			//A4 wth margin = 190 or 260 
			_gnncFilePdf.__clearAll();

			_gnncFilePdf.__setFontWeight(false,_normalFont);
			_gnncFilePdf.__addCell('Total Centro de Custo',90,"L",_normalRow+4,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(totalValueInPerDepartament,2,''),50,"R",_normalRow+4,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(totalValueOutPerDepartament,2,''),50,"R",_normalRow+4,_headerBg,_headerBorder);
			_gnncFilePdf.__breakLine(_normalRow+4);

			_gnncFilePdf.__breakLine(4);
			
			_gnncFilePdf.__setFontWeight(false,_normalFont+2);
			_gnncFilePdf.__addLine(0x444444,0.3);
			_gnncFilePdf.__addCell('Resumo',90,"L",_normalRow+4,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(totalValueIn,2,''),50,"R",_normalRow+4,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(totalValueOut,2,''),50,"R",_normalRow+4,_headerBg,_headerBorder);
			_gnncFilePdf.__breakLine(_normalRow+4);

			_gnncFilePdf.__setFontWeight(false,_normalFont+2);
			_gnncFilePdf.__addLine(0x444444,0.3);
			_gnncFilePdf.__addCell('Balanço',90,"L",_normalRow+4,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(totalValueIn-totalValueOut,2,''),100,"R",_normalRow+4,_headerBg,_headerBorder);
			_gnncFilePdf.__breakLine(_normalRow+4);

		}
		
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
		}
		
		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();

			if(i_==0){
			}

			//A4 wth margin = 190 or 260 
			
			if(!object_.PAY_TYPE && object_.DOCUMENT_TYPE==99)
			{
				tt = '-';
				tl = 'Transf. entre Contas';
			}
			else if(!object_.PAY_TYPE && object_.DOCUMENT_TYPE==99)
			{
				tt = '-';
				tl = 'Desconhecido';
			}
			
			if(idDepart != object_.ID_DEPARTAMENT)
			{
				if(i_!=0){
					_gnncFilePdf.__setFontWeight(false,_normalFont);
					_gnncFilePdf.__addCell('Total Centro de Custo',90,"L",_normalRow+4,_headerBg,_headerBorder);
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(totalValueInPerDepartament,2,''),50,"R",_normalRow+4,_headerBg,_headerBorder);
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(totalValueOutPerDepartament,2,''),50,"R",_normalRow+4,_headerBg,_headerBorder);
					_gnncFilePdf.__breakLine(_normalRow+4);
				}

				_gnncFilePdf.__breakLine(3);
				idDepart = object_.ID_DEPARTAMENT;

				_gnncFilePdf.__setFontStyle(_normalFont+1,0xFFFFFF); //FONT
				_gnncFilePdf.__addCell(object_.NAME_DEPARTAMENT==''?'Nenhum':String(' '+object_.NAME_DEPARTAMENT).toUpperCase(),90,"L",_normalRow+4,0x777777,0x777777);
				/*_gnncFilePdf.__addCell("RECEITA",20,"C",_headerRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("DESPESA",20,"C",_headerRow,_headerBg,_headerBorder);*/
				_gnncFilePdf.__breakLine(_normalRow+4+1);

				_gnncFilePdf.__setFontStyle(_normalFont-2); //FONT
				_gnncFilePdf.__addCell("Taxas"														,30,"L",_normalRow,_headerBg,_normalBorder);
				_gnncFilePdf.__addCell("R"															,10,"C",_normalRow,_headerBg,_normalBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_TAX,2)			,20,"L",_normalRow,_normalBg,_normalBorder);
				_gnncFilePdf.__addCell("D"															,10,"C",_normalRow,_headerBg,_normalBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT_TAX,2)			,20,"L",_normalRow,_normalBg,_normalBorder);
				_gnncFilePdf.__breakLine(_normalRow);
				
				_gnncFilePdf.__addCell("Taxas de Transf."											,60,"L",_normalRow,_headerBg,_normalBorder);
				/*_gnncFilePdf.__addCell("R"															,10,"C",_normalRow,_headerBg,_normalBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_TAXTRANS,2)		,20,"L",_normalRow,_normalBg,_normalBorder);*/
				_gnncFilePdf.__addCell("D"															,10,"C",_normalRow,_headerBg,_normalBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT_TAXTRANS,2)		,20,"L",_normalRow,_normalBg,_normalBorder);
				_gnncFilePdf.__breakLine(_normalRow);
				_gnncFilePdf.__breakLine(1);

				_gnncFilePdf.__clearFillStyle();
				_gnncFilePdf.__clearFontStyle()
				_gnncFilePdf.__clearStrokeStyle();
				
				//A4 wth margin = 190 or 260 
				_gnncFilePdf.__setFontStyle(_headerFont); //FONT
				_gnncFilePdf.__addCell("DEPARTAMENTO"										,40,"L",_normalRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("REF."												,20,"L",_normalRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("TIPO DE PAGAMENTO"									,30,"L",_normalRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("RECEITA (R$)"										,35,"C",_normalRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("QNT",15,"C",_normalRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("DESPESA (R$)"										,35,"C",_normalRow,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("QNT",15,"C",_normalRow,_headerBg,_headerBorder);
				_gnncFilePdf.__breakLine(_normalRow);
				
				_gnncFilePdf.__clearFillStyle();
				_gnncFilePdf.__clearFontStyle()
				_gnncFilePdf.__clearStrokeStyle();
				
				totalValueInPerDepartament  = 0;
				totalValueOutPerDepartament = 0;
			}
			
			_gnncFilePdf.__setFontStyle(_normalFont-1); //FONT
			_gnncFilePdf.__addCell(object_.NAME_DEPARTAMENT==''?'Nenhum':gnncData.__firstLetterUpperCase(' '+object_.NAME_DEPARTAMENT),40,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(object_.PAY_TYPE==''?tt:object_.PAY_TYPE											,20,"R",_normalRow+1,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell(object_.PAY_TYPE==''?tl:new gnncDataArrayCollection().__filter(gnncGlobalArrays._FINANCIAL_PAY_TYPE,'data',object_.PAY_TYPE,false,false).getItemAt(0).label,30,"L",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_PAY,2,'')								,35,"R",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(object_.ROWS_IN_PAY																,15,"C",_normalRow+1,_headerBg,_headerBorder);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT_PAY,2,'')							,35,"R",_normalRow+1,_normalBg,_normalBorder);
			_gnncFilePdf.__addCell(object_.ROWS_OUT_PAY																,15,"C",_normalRow+1,_headerBg,_headerBorder);
			_gnncFilePdf.__breakLine(_normalRow+1);

			totalValueIn                += Number(object_.VALUE_IN_PAY);
			totalValueOut               += Number(object_.VALUE_OUT_PAY);
			totalValueInPerDepartament  += Number(object_.VALUE_IN_PAY);
			totalValueOutPerDepartament += Number(object_.VALUE_OUT_PAY);

			if(i_==_itemRenderLength-1)
			{
				/*_gnncFilePdf.__breakLine(1);
				_gnncFilePdf.__addCell("Taxas"																		,40,"L",_normalRow+2,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("R"																			,10,"C",_normalRow+2,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_TAX,2)							,20,"L",_normalRow+2,_normalBg,_normalBorder);
				_gnncFilePdf.__addCell("D"																			,10,"C",_normalRow+2,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT_TAX,2)							,20,"L",_normalRow+2,_normalBg,_normalBorder);
				_gnncFilePdf.__breakLine(_normalRow+2);
				_gnncFilePdf.__addCell("Taxas de Transferências"													,40,"L",_normalRow+2,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell("R"																			,10,"C",_normalRow+2,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_TAXTRANS,2)						,20,"L",_normalRow+2,_normalBg,_normalBorder);
				_gnncFilePdf.__addCell("D"																			,10,"C",_normalRow+2,_headerBg,_headerBorder);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT_TAXTRANS,2)						,20,"L",_normalRow+2,_normalBg,_normalBorder);
				*/
			}

			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();
		}
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			//start
			var dateStartCurrent:String   = gnncDate.__date2String(_dateStart,false);
			var dateStartYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart),false);
			//end
			var dateEndCurrent:String   = gnncDate.__date2String(_dateEnd,false);
			var dateEndYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateEnd),false);
			
			var dateLegend:String = dateStartCurrent.substr(0,10)==dateEndCurrent.substr(0,10)? gnncDate.__date2Legend('',_dateStart) : gnncDate.__date2Legend('',_dateStart) + ' até ' + gnncDate.__date2Legend('',_dateEnd);
			
			var days:Number = DateUtils.dateDiff(DateUtils.DAY_OF_MONTH,_dateStart,_dateEnd)+1;
			var dayesLegend:String = ' ('+days+' '+(days==1?'dia':'dias')+')';
			
			_fileName 		= "DAYBYDAY - MONEY Formas de Pagamentos";
			_documentTitle 	= "Formas de Pagamentos - "+dateLegend;
			
			var idAccount:String 		= _object['idAccount']		? " AND ID_FINANCIAL_ACCOUNT = '" 	+ _object['idAccount'] 		+ "' " : '' ;
			var idDepartament:String 	= _object['idDepartament']	? " AND ID_DEPARTAMENT = '" 		+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= _object['idGroup']		? " AND ID_GROUP = '" 				+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= _object['idCategory']		? " AND ID_CATEGORY = '" 			+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= _object['documentType']	? " AND DOCUMENT_TYPE = '" 			+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= _object['payType']		? " AND PAY_TYPE = '" 				+ _object['payType'] 		+ "' " : '' ;
			
			//var _filter:String = idAccount + idDepartament + idGroup + idCategory + documentType + payType;
			var _filter:String = idAccount + idGroup + idCategory ;

			var _whereDate:String = " " +
				" f.DATE_FINAL >= '"+dateStartCurrent+" 00:00:00' AND " +
				" f.DATE_FINAL <= '"+dateEndCurrent+" 23:59:59' ";

			var _whereDateGeneral:String = " " +
				" fin.DATE_FINAL >= '"+dateStartCurrent+" 00:00:00' AND " +
				" fin.DATE_FINAL <= '"+dateEndCurrent+" 23:59:59' ";

			//var _where:String = _whereDate + _filter;

			_sql = "" +
				" select " +
				" fin.DOCUMENT_TYPE, fin.PAY_TYPE, fin.ID_DEPARTAMENT as ID_DEPARTAMENT, " +
				" coalesce((Select NAME from dbd_departament d where d.ID = fin.ID_DEPARTAMENT ),'') as NAME_DEPARTAMENT, " +
				
				" ROUND(SUM(fin.VALUE_IN_PAY),2) 		as VALUE_IN_PAY, "+ 
				" ROUND(SUM(fin.VALUE_OUT_PAY),2) 		as VALUE_OUT_PAY, "+
				
				//" COUNT(fin.VALUE_IN_PAY)   as ROWS_IN_PAY, " +
				//" COUNT(fin.VALUE_OUT_PAY)  as ROWS_OUT_PAY, " +

				" coalesce((Select COUNT(f.ID) from dbd_financial f where f.ID_DEPARTAMENT = fin.ID_DEPARTAMENT AND "+_whereDate+" AND f.PAY_TYPE = fin.PAY_TYPE AND f.VALUE_IN_PAY > 0  ),0) as ROWS_IN_PAY, " +
				" coalesce((Select COUNT(f.ID) from dbd_financial f where f.ID_DEPARTAMENT = fin.ID_DEPARTAMENT AND "+_whereDate+" AND f.PAY_TYPE = fin.PAY_TYPE AND f.VALUE_OUT_PAY > 0 ),0) as ROWS_OUT_PAY, " +

				//" (Select ROUND(SUM(f.VALUE_IN_PAY),2)  from dbd_financial f where f.ID_DEPARTAMENT = fin.ID_DEPARTAMENT AND "+_whereDate+" AND f.PAY_TYPE = fin.PAY_TYPE       ) as VALUE_IN_PAY2, " +
				//" (Select ROUND(SUM(f.VALUE_OUT_PAY),2) from dbd_financial f where f.ID_DEPARTAMENT = fin.ID_DEPARTAMENT AND "+_whereDate+" AND f.PAY_TYPE = fin.PAY_TYPE       ) as VALUE_OUT_PAY2, " +
				
				" coalesce((Select ROUND(SUM(f.VALUE_IN_PAY),2)  from dbd_financial f where f.ID_DEPARTAMENT = fin.ID_DEPARTAMENT AND "+_whereDate+" AND f.IS_TAX = 1 AND f.IS_TRANS = 0 ),0) as VALUE_IN_TAX, " +
				" coalesce((Select ROUND(SUM(f.VALUE_OUT_PAY),2) from dbd_financial f where f.ID_DEPARTAMENT = fin.ID_DEPARTAMENT AND "+_whereDate+" AND f.IS_TAX = 1 AND f.IS_TRANS = 0 ),0) as VALUE_OUT_TAX, " +
				" coalesce((Select ROUND(SUM(f.VALUE_IN_PAY),2)  from dbd_financial f where f.ID_DEPARTAMENT = fin.ID_DEPARTAMENT AND "+_whereDate+" AND f.IS_TAX = 1 AND f.IS_TRANS = 1 ),0) as VALUE_IN_TAXTRANS, " +
				" coalesce((Select ROUND(SUM(f.VALUE_OUT_PAY),2) from dbd_financial f where f.ID_DEPARTAMENT = fin.ID_DEPARTAMENT AND "+_whereDate+" AND f.IS_TAX = 1 AND f.IS_TRANS = 1 ),0) as VALUE_OUT_TAXTRANS " +
				
				" " +
				" from "+ 
				" dbd_financial as fin " +
				//" JOIN dbd_group as gro 		on ( gro.ID like cli.ID_GROUP ) " +
				//" JOIN dbd_departament as dep 	on ( dep.ID like cli.ID_DEPARTAMENT ) " +
				" where " + 
				_whereDateGeneral + " AND fin.MIX <> 'FINANCIAL_TRANS' " +
				" group by " +
				" fin.ID_DEPARTAMENT,fin.PAY_TYPE "+
				" order by "+
				" NAME_DEPARTAMENT,fin.PAY_TYPE ";
			
			//new gnncAlert().__alert(_sql);
		}
	
		
	}
}