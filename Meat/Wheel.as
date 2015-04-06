package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Wheel extends HotObject {
		
		
		public function Wheel() {
			addEventListener(Event.ADDED_TO_STAGE,onStage);
			addEventListener(Event.REMOVED_FROM_STAGE,offStage);
		}
		
		private function onStage(e:Event):void {
			addEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function offStage(e:Event):void {
			removeEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		override public function canGo():Boolean {
			return currentFrame==1;
		}
		
		private function onFrame(e:Event):void {
			var includeSelf:Boolean = false;
			if(currentLabel=="WALKRIGHT") {
				master.movingplatform.x=Math.max(775,master.movingplatform.x-3);
				master.daveplatform.x = master.movingplatform.x;
				for each(var meatly:Meatly in master.movingplatform.holders) {
					if(!meatly.root) {
						delete master.movingplatform.holders[meatly.id];
					}
					meatly.x = master.movingplatform.x;
					if(meatly==master.meat)
						includeSelf = true;
				}
//				if(master.movingplatform.activator)
//					master.movingplatform.activator.x = master.movingplatform.x;
				if(master.movingplatform.x<=775) {
					activator.gotoAndStop("STOP");
					gotoAndStop(1);
				}
			}
			else if(currentLabel=="WALKLEFT") {
				master.movingplatform.x=Math.min(1330,master.movingplatform.x+3);
				master.daveplatform.x = master.movingplatform.x;
				for each(meatly in master.movingplatform.holders) {
					if(!meatly.root) {
						delete master.movingplatform.holders[meatly.id];
					}
					meatly.x = master.movingplatform.x;
					if(meatly==master.meat)
						includeSelf = true;
				}
//				if(master.movingplatform.activator) {
//					master.movingplatform.activator.x = master.movingplatform.x;
					if(includeSelf) {//master.meat==master.movingplatform.activator) {
						if(master.movingplatform.x>1000) {
							if(MovieClip(root).currentLabel!="GOEAST") {
								MovieClip(root).gotoAndPlay("GOEAST");
							}
						}
					}
//				}
				if(master.movingplatform.x>=1330) {
					activator.gotoAndStop("STOP");
					gotoAndStop(1);
				}
			}
		}
	}
	
}
