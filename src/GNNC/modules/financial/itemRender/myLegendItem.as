
package GNNC.modules.financial.itemRender
{
	import flash.events.MouseEvent;
	
	import mx.charts.LegendItem;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataNumber;
	
	
	
	public class myLegendItem extends LegendItem
	{
		private var bgElement:Canvas;
		private var _highlight:Boolean;
		
		public function myLegendItem()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_OVER, handleEvent);
			addEventListener(MouseEvent.MOUSE_OUT, handleEvent);
			
		}
		
		override protected function createChildren():void {
			super.createChildren();
			bgElement = new Canvas();
			bgElement.setStyle("backgroundColor", 0xEEEEEE);
			addChildAt(bgElement,0);
		}
		
		private function handleEvent(event:MouseEvent):void{
			if(event.type == MouseEvent.MOUSE_OVER)
				highlight = true;
			else if(event.type == MouseEvent.MOUSE_OUT)
				highlight = false;
		}
		
		
		public function set highlight(value:Boolean):void{
			_highlight = value;
			invalidateDisplayList()
		}
		
		//private var labelChanged:Boolean = false;

		/*override public function set label(value:String):void
		{
			//super.label = DAYBYDAY_DATA.__FIRST_LETTER_UPPERCASE(value);
			
			super.label = DAYBYDAY_DATA.__FIRST_LETTER_UPPERCASE(value);
			//labelChanged = true;

			invalidateSize();
			invalidateDisplayList();
		}*/
		
		protected override function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
			graphics.endFill();
			
			bgElement.setActualSize(unscaledWidth, unscaledHeight);
			if(_highlight)
				bgElement.visible = true;
			else
				bgElement.visible = false;
			
			var data:ArrayCollection = (element as Object).dataProvider as ArrayCollection;
			var dataNum:int = data.length;
			var dataSplit:Array = new Array();
			var dataSplitString:String = '';
			
			
			for (var i:int=0; i<dataNum; i++) {
				if (data[i].label == this.label) {
					// uncomment this line if you want to show all three data: Gold, Silver and Bronze
					//this.label += " (" + data[i].Gold + "/" + data[i].Silver + "/" + data[i].Bronze + ")";
					if(this.label.length>30){

						dataSplit = this.label.split(' ');

						if(dataSplit.length==1)
							dataSplitString = dataSplit[0]+"\n"+"123";
						else if(dataSplit.length==2)
							dataSplitString = dataSplit[0]+' '+(String(dataSplit[1]).length>3?String(dataSplit[1]).substr(0,3)+'.':dataSplit[1]);
						else if(dataSplit.length==3)
							dataSplitString = dataSplit[0]+' '+(String(dataSplit[1]).length>3?String(dataSplit[1]).substr(0,3)+'.':dataSplit[1])+' '+dataSplit[2];
						else
							dataSplitString = dataSplit[0]+' '+(String(dataSplit[1]).length>3?String(dataSplit[1]).substr(0,3)+'.':dataSplit[1])+' '+dataSplit[2]+' (...)';
						
						this.label = gnncData.__firstLetterUpperCase(dataSplitString); //NATAN CABRAL -> value is label, a object.
					}else{//gnnc
						this.label = gnncData.__firstLetterUpperCase(this.label); //NATAN CABRAL -> value is label, a object.
					}
					this.toolTip = this.label+ " \n" + gnncDataNumber.__safeReal(data[i].value);
					break;
				}
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
		}
		
	}
}
