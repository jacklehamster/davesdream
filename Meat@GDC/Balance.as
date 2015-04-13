package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Balance extends HotObject {

		private var left:Plate, right:Plate, _balancing:Boolean;
		private var momentum:Number, position:Number;
		
		public function Balance() {
			gotoAndStop(1+int(totalFrames/2));
			updateBalance();
		}
		
		public function get pos():Number {
			return position;
		}
		
		public function affectMomentum(value:Number):void {
			momentum += value;
			updateBalance();
		}
		
		override protected function refresh():void {
			if(_balancing) {
				position += momentum*.1;
				var leftWeight:Number = left.weight;
				var rightWeight:Number = right.weight;
				var posGoal:Number = leftWeight/(leftWeight+rightWeight);
				var diff:Number = posGoal-position;
				momentum += diff/5;
				momentum *= .9;
				gotoAndStop(1+int(totalFrames*position));
				if(Math.abs(diff)<.01 && Math.abs(momentum)<.01) {
					_balancing = false;
				}
			}
		}
		
		public function setBalancePlate(left:Plate,right:Plate):void {
			this.left = left;
			this.right = right;
			left.balance = this;
			right.balance = this;
			updateBalance();
		}
		
		public function get balancing():Boolean {
			return _balancing;
		}
		
		public function updateBalance():void {
			if(left&&right) {
				var leftWeight:Number = left.weight;
				var rightWeight:Number = right.weight;
				trace(leftWeight,"vs",rightWeight);
			}
			
			if(!_balancing) {
				_balancing = true;
				position = currentFrame/totalFrames
				momentum = 0;
			}
		}

	}
	
}
