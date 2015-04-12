package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	public class Cursor extends MovieClip {
		
		
		public function Cursor() {
			mouseEnabled = mouseChildren = false;
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,offStage);
		}
		
		private function onStage(e:Event):void {
			visible = false;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouse);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouse);
		}
		
		private function offStage(e:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouse);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouse);
		}
		
		private function onMouse(e:MouseEvent):void {
			if(visible) {
				var pos:Point = parent.globalToLocal(new Point(e.stageX,e.stageY));
				x = pos.x;
				y = pos.y;
				if(e.type==MouseEvent.MOUSE_DOWN) {
					if(e.target is HotObject) {
					}
					else {
						var item:Item = Inventory.instance.getChildByName(currentLabel) as Item;
						if(item) {
							item.flyFrom(x,y);
						}
						visible = false;
						Inventory.instance.updateInventory(Hero.instance.items);
					}
				}
				e.updateAfterEvent();
			}
		}
	}
	
}
