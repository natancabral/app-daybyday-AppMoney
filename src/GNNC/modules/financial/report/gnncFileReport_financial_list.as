package GNNC.modules.financial.report
{
	import mx.collections.ArrayCollection;
	
	import GNNC.data.globals.gnncGlobalStatic;

	public class gnncFileReport_financial_list extends gnncFileReport_financial_addToday
	{
		override protected function __addFinalObservation(object_:Object):void
		{
			//A4 wth margin = 190 or 260
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
			_fileName = "DAYBYDAY - "+gnncGlobalStatic._programName+" - Listagem";
			_documentTitle = "Listagem";
			_sql = "";
		}

	}
}