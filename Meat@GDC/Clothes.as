package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	
	
	public class Clothes extends MovieClip {
		
		
		public function Clothes() {
			update();
		}
		
		static public function updateClothes(dude:Dude,container:DisplayObjectContainer=null):void {
			if(!container) {
				container = dude;
			}
			for(var i:int=0;i<container.numChildren;i++) {
				var child:DisplayObjectContainer = container.getChildAt(i) as DisplayObjectContainer;
				if(child) {
					if(child is Clothes) {
						(child as Clothes).update(dude);
					}
					else {
						updateClothes(dude,child);
					}
				}
			}
			
		}
		
		public function update(dude:Dude=null):void {
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
				gotoAndStop(1+((dude.id+totalFrames-1)%totalFrames));
			}
		}
	}
	
}
