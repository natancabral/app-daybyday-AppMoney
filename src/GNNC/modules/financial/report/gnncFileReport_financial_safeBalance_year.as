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
	
	public class gnncFileReport_financial_safeBalance_year extends gnncFileReport_financial_safeBalance_month
	{

		public function gnncFileReport_financial_safeBalance_year(csv_:Boolean=false)
		{
			_csvReturn = csv_;

			title = "Balanço Anual";
		}
		
		override protected function __setValues():void
		{
			_gnncFilePdf._pageOrientation = Orientation.PORTRAIT;
			_fileName = "DAYBYDAY - MONEY - "+title;
			_documentTitle = "Plano de Contas -  "+title+" - "+_dateStart.fullYear;
			
			nameDateInterval = String(_dateStart.fullYear);

			var idAccount:String 		= _object['idAccount']		? " AND fin.ID_FINANCIAL_ACCOUNT = '" + _object['idAccount'] 		+ "' " : '' ;
			var idDepartament:String 	= _object['idDepartament']	? " AND fin.ID_DEPARTAMENT = '" 	+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= _object['idGroup']		? " AND fin.ID_GROUP = '" 			+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= _object['idCategory']		? " AND fin.ID_CATEGORY = '" 		+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= _object['documentType']	? " AND fin.DOCUMENT_TYPE = '" 		+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= _object['payType']		? " AND fin.PAY_TYPE = '" 			+ _object['payType'] 		+ "' " : '' ;
			
			//start
			var dateStartCurrent:String   = gnncDate.__date2String(_dateStart,false);
			var dateStartYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart),false);
			//end
			var dateEndCurrent:String     = gnncDate.__date2String(_dateEnd,false);
			var dateEndYesterday:String   = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateEnd),false);
			
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

                " (select round(coalesce(SUM(fin.VALUE_IN_PAY ),0),2) from dbd_financial as fin where LEFT(fin.DATE_FINAL,4) like LEFT('"+dateFull+"',4) AND fin.MIX <> 'FINANCIAL_TRANS' AND gro.ID = fin.ID_GROUP AND fin.VALUE_IN_PAY > 0  "+filter+") as VALUE_IN_PAY, " +
                " (select round(coalesce(SUM(fin.VALUE_OUT_PAY),0),2) from dbd_financial as fin where LEFT(fin.DATE_FINAL,4) like LEFT('"+dateFull+"',4) AND fin.MIX <> 'FINANCIAL_TRANS' AND gro.ID = fin.ID_GROUP AND fin.VALUE_OUT_PAY > 0 "+filter+") as VALUE_OUT_PAY " +

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
                " LEFT(fin.DATE_FINAL,4) like LEFT('"+dateFull+"',4) AND  " + 
                " fin.MIX <> 'FINANCIAL_TRANS' " + 
				filter +
				" group by gro.ID " + 

                " order by groMIX asc,NAME_FATHER asc,NAME_GROUP asc ";
			
			//new gnncAlert(gnncGlobalStatic._parent).__alert(_sql);
		}


	}
}