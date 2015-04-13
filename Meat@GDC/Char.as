package  {
	import flash.geom.Point;
	
	public class Char extends Moveable 
	{

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
		

	}
	
}
