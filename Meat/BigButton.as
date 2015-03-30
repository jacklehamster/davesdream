package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class BigButton extends HotObject {
		
		private var _weight:int = 0;
		
		public function BigButton() {
			// constructor code
		}
		
		public function set weight(value:int):void {
			_weight = value;
			gotoAndStop(_weight?"DOWN":"UP");
			if(_weight && master.gate.currentLabel!="OPEN")
				master.gate.gotoAndPlay("OPEN");
			else if(!_weight && master.gate.currentLabel!="CLOSE")
				master.gate.gotoAndPlay("CLOSE");
			master.ledge.blocked = master.gate.currentLabel!="OPEN";
			
		}
		
		public function get weight():int {
			return _weight;
		}
		
		public function steppedOn(meatly:Meatly):void {
			weight++;
			meatly.addEventListener("move",
				function(e:Event):void {
					e.currentTarget.removeEventListener(e.type,arguments.callee);
					weight--;
				});
		}
	}
	
}
