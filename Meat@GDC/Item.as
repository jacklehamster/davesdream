package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	
	
	public class Item extends MovieClip {
		
		
		public function Item() {
			mouseChildren = false;
			mouseEnabled = true;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN,onMouse);
		}
		
		private function onMouse(e:MouseEvent):void {
			Inventory.instance.setCursor(name);
			e.stopPropagation();
		}
		
		public function flyFrom(fromX:Number,fromY:Number):void {
			var dist:Number;
			var array:Array = [];
			var point:Point = new Point(x,y);
			do {
				array.push(point.clone());
				var dx:Number = fromX-point.x;
				var dy:Number = fromY-point.y;
				point.x += dx*.8;
				point.y += dy*.8;
				dist = Math.sqrt(dx*dx + dy*dy);
			} while(dist>10);
			x = fromX;
			y = fromY;
			addEventListener(Event.ENTER_FRAME,
				function(e:Event):void {
					if(array.length) {
						var point:Point = array.pop();
						x = point.x;
						y = point.y;
					}
					else {
						e.currentTarget.removeEventListener(e.type,arguments.callee);
					}
				});
		}
	}
	
}
