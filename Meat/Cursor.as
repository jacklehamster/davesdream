package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Cursor extends MovieClip {
		
		
		public function Cursor() {
			mouseEnabled = mouseChildren = false;
			visible = false;
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,offStage);
		}
		
		private function onStage(e:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
		}
		
		private function offStage(e:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
		}
		
		private function onMove(e:MouseEvent):void {
			x = e.stageX;
			y = e.stageY;
			e.updateAfterEvent();
		}
	}
	
}
