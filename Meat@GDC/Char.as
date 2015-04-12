package  {
	import flash.geom.Point;
	
	public class Char extends HotObject 
		implements IMoveable
	{

		protected var dudemover:DudeMover;
		
		override protected function onEndAnimation():void {
			if(callback!=null) {
				var c:Function = callback;
				callback = null;
				c(this);
			}
			else {
				var info:Object = frameInfos[currentLabel];
				gotoAndPlay(info.start);
			}
		}
		
		public function setMover(mover:DudeMover):void {
			if(dudemover) {
				delete dudemover.moveables[id];
			}
			dudemover = mover;
			if(dudemover)
				dudemover.moveables[id] = this;
		}
		
		public function get mover():DudeMover {
			return dudemover;
		}
		
		public function get inTransit():Boolean {
			return dudemover && dudemover.inTransit;
		}
		
		public function follow(mover:DudeMover):void {
			if(!master) {
				setMover(null);
			}
			else {
				var point:Point = master.globalToLocal(mover.hotPos.localToGlobal(new Point()));
				x = point.x;
				y = point.y;
			}
		}

	}
	
}
