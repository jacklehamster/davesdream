package  {
	
	import flash.display.MovieClip;
	
	
	public class PyramidDoor extends HotObject {
		

		private var _activations:int = 0;
		
		override protected function refresh():void {
			var frameGoal:int = _activations==0?1:_activations==1?totalFrames/2:totalFrames;
			if(currentFrame!=frameGoal) {
				gotoAndStop(frameGoal<currentFrame?currentFrame-1:currentFrame+1);
			}
		}
		
		public function set activations(value:int):void {
			_activations = value;
		}
		
		public function get activations():int {
			return _activations;
		}
		
		public function get opened():Boolean {
			return currentLabel=="OPENED";
		}
	}
	
}
