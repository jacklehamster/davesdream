package  {
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	
	public class Wearable extends MovieClip {

		public function Wearable() {
			update();
		}
		
		static public function fullUpdate(dude:Dude,container:DisplayObjectContainer=null):void {
			if(!container) {
				container = dude;
			}
			for(var i:int=0;i<container.numChildren;i++) {
				var child:DisplayObjectContainer = container.getChildAt(i) as DisplayObjectContainer;
				if(child) {
					if(child is Wearable) {
						(child as Wearable).update(dude);
					}
					else {
						fullUpdate(dude,child);
					}
				}
			}
			
		}
		
		protected function update(dude:Dude=null):void {
			if(!dude) {
				var p:DisplayObjectContainer = this;
				while(p && !(p is HotObject)) {
					p = p.parent;
				}
				if(p && p.visible) {
					dude = (p is Dude) ? (p as Dude) : (p as HotObject).activator;
				}
			}
			if(dude) {
				processWithDude(dude);
			}
		}
		
		protected function processWithDude(dude:Dude):void {
			
		}
	}
	
}
