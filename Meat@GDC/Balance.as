package  {
	
	import flash.display.MovieClip;
	
	
	public class Balance extends HotObject {

		private var left:Plate, right:Plate;
		
		public function Balance() {
			gotoAndStop(1+int(totalFrames/2));
		}
		
		override protected function refresh():void {
		}
		
		public function setBalance(left:Plate,right:Plate):void {
			this.left = left;
			this.right = right;
			left.balance = this;
			right.balance = this;
		}

	}
	
}
