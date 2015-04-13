package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	
	public class Inventory extends MovieClip {
		
		static public var instance:Inventory;
		
		public function Inventory() {
			mouseEnabled = false;
			instance = this;
			var mainHero:Hero = Game.instance?Game.instance.mainHero:null;
			updateInventory(mainHero?mainHero.items:[]);
		}
		
		public function updateInventory(items:Array):void {
			for(var i:int=0;i<numChildren;i++) {
				var child:Item = getChildAt(i) as Item;
				if(child) {
					var wasVisible:Boolean = child.visible;
					child.visible = items.indexOf(child.name)>=0 && (!cursor.visible || cursor.currentLabel!=child.name);
					if(!wasVisible && visible) {
						popout(child);
					}
				}
			}
		}
		
		private function popout(child:DisplayObject):void {
			var scale:Number = child.scaleX;
			var ymov:Number = .3;
			
			var array:Array = [scale];
			while(scale>0) {
				scale = Math.max(0,scale+ymov);
				ymov -= .1;
				array.push(scale);
			}
			
			child.scaleX = child.scaleY = scale;
			addEventListener(Event.ENTER_FRAME,
				function(e:Event):void {
					if(array.length) {
						var scale:Number = array.pop();
						child.scaleX = child.scaleY = scale;
					}
					else {
						e.currentTarget.removeEventListener(e.type,arguments.callee);
					}
				});
		}
		
		public function setCursor(value:String):void {
			cursor.visible = value!=null;
			if(value) {
				cursor.gotoAndStop(value);
				cursor.x = mouseX;
				cursor.y = mouseY;
			}
			var mainHero:Hero = Game.instance.mainHero;
			if(mainHero) {
				updateInventory(mainHero.items);
			}
			Game.instance.resetHotspots();
		}
		
		public function get activeItem():String {
			return cursor.visible ? cursor.currentLabel : null;
		}
	}
	
}
