package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	
	public class OozieStuck extends Dude {
		
		public function OozieStuck() {
	
			visible = true;
			addEventListener(Event.ADDED_TO_STAGE,
				function(e:Event):void {
					var h:HotObject = parent is HotObject ? parent as HotObject :
						parent.parent is HotObject ? parent.parent as HotObject : null;
					if(h) {
						id = h.activator.id;
	//					activator = (parent is HotObject) ? (parent as HotObject).activator : null;
						Wearable.fullUpdate((e.currentTarget as Dude));
					}
				});
		}
	}
	
}
