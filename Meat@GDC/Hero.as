package  {
	
	public class Hero {

		static public var instance:Hero = new Hero();
		
		public var items:Array = [];
		
		public function Hero():void {
			resetInventory();
		}
		
		public function resetInventory():void {
			items = [];
			pickupItem("timeRemote");
		}
		
		public function pickupItem(item:String):void {
			if(items.indexOf(item)<0) {
				items.push(item);
			}
			Inventory.instance.updateInventory(items);
		}
		
		public function dropItem(item:String):void {
			var index:int = items.indexOf(item);
			if(index>=0)
				items.splice(index);
			Inventory.instance.updateInventory(items);
		}
		
		public function hasItem(item:String):Boolean {
			return items.indexOf(item)>=0;
		}

	}
	
}
