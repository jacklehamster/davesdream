package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class DudeMover extends Mover 
	{
		
		private var _hotDests:Array = [];
		public var speed:Number = 5;
		private var location:int = 0;
		private var _locationGoal:int = 0;
		private var intransit:Boolean;
		
		function DudeMover():void {
			for(var i:int=0;i<numChildren;i++) {
				if(getChildAt(i) is HotDestination) {
					_hotDests.push(getChildAt(i));
				}
			}
			_hotDests.sortOn("name");
			for (i=0;i<_hotDests.length;i++) {
				_hotDests[i] = master.globalToLocal(_hotDests[i].localToGlobal(new Point()));
			}
			_hotDests.unshift(new Point(x,y));
			intransit= false;
		}
		
		public function set locationGoal(value:int):void {
			_locationGoal = value%_hotDests.length;
		}
		
		public function get locationGoal():int {
			return _locationGoal;
		}
		
		override protected function refresh():void {
			if(location!=_locationGoal || intransit) {
				intransit = true;
				var nextLocation:int = (location+1)%_hotDests.length;
				var nextPoint:Point = _hotDests[nextLocation];
				var dx:Number = nextPoint.x-x;
				var dy:Number = nextPoint.y-y;
				var dist:Number = Math.sqrt(dx*dx+dy*dy);
				if(dist>1) {
					var spd:Number = Math.min(speed,dist);
					x += dx/dist * spd;
					y += dy/dist * spd;
				}
				else {
					intransit = false;
					x = nextPoint.x;
					y = nextPoint.y;
					location = nextLocation;
				}
				for each(var moveable:IMoveable in moveables) {
					moveable.follow(this);
				}
			}
		}
		
		override public function get inTransit():Boolean {
			return intransit;
		}
	}
	
}
