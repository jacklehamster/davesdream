package  {
	
	import flash.display.MovieClip;
	
	
	public class Pedestral extends HotObject {


		private var _supports:int = 0;
		
		public function get supports():int {
			return _supports;
		}
		
		public function set supports(value:int):void {
			_supports = value;
			if(_supports && (buttonDown.currentLabel=="UP"||buttonDown.currentLabel=="PUSHUP")) {
				buttonDown.gotoAndPlay("PUSHDOWN");
			}
			else if(!_supports && (buttonDown.currentLabel=="DOWN"||buttonDown.currentLabel=="PUSHDOWN")) {
				buttonDown.gotoAndPlay("PUSHUP");
			}
			updated();
		}
		
		public function get pushed():Boolean {
			return buttonDown.currentLabel=="DOWN" || buttonDown.currentLabel=="PUSHDOWN";
		}
		
		override public function activate():void {
			supports++;
			super.activate();
		}
		
		override public function deactivate():void {
			supports--;
			super.deactivate();
		}
	}
	
}
