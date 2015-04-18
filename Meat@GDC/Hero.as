package  {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class Hero extends EventDispatcher{

		static public var persistentItems:Array = null;
		
		public var items:Array = [];
		public var state:Object = {};
		

		public function Hero():void {
			resetInventory();
		}
		
		public function resetInventory():void {
			items = persistentItems?persistentItems:[];
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function pickupItem(item:String):void {
			if(items.indexOf(item)<0) {
				items.push(item);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function dropItem(item:String):void {
			var index:int = items.indexOf(item);
			if(index>=0) {
				items.splice(index);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function hasItem(item:String):Boolean {
			return items.indexOf(item)>=0;
		}

	}
	
}
