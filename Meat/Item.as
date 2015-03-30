package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Item extends MovieClip {

		public function Item() {
			buttonMode = true;
			addEventListener(MouseEvent.CLICK,onSelect);
		}

		private function onSelect(e:MouseEvent):void {
			(root as MovieClip).game.select(name);
		}
	}
	
}
