package  {
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	public class Dude extends Char {

		private var goal:Point, goalObject:HotObject;
		public var speed:Number = 3;
		public var usingItem:String;
		public var doomed:Boolean;
		
		public function Dude() {
			visible = false;
			activator = this;
		}
		
		private function stopWalking(changeLabel:Boolean=true):void {
			if(changeLabel)
				setLabel("STAND");
			removeEventListener(Event.ENTER_FRAME,onWalk);
			goal = null;
			goalObject = null;
		}
		
		public function walkTo(hotObject:HotObject=null):void {
			var hot:DisplayObject = hotObject.hotPos?hotObject.hotPos:hotObject;
			var point:Point = master.globalToLocal(hot.localToGlobal(new Point()));
			if(goal) {
				stopWalking(false);
			}
			setLabel("WALK");
			goal = point;
			goalObject = hotObject;
			addEventListener(Event.ENTER_FRAME,onWalk);
		}
		
		public function setDirection(dir:Number):void {
			if(scaleX*dir<0) {
				scaleX = -scaleX;
			}
		}
		
		public function setPosition(hotObject:HotObject,direction:Number=0):void {
			var hot:DisplayObject = hotObject.hotPos ? hotObject.hotPos : hotObject;
			var point:Point = master.globalToLocal(hot.localToGlobal(new Point()));
			x = point.x;
			y = point.y;
			setDirection(direction);
		}
		
		override public function follow(mover:DudeMover):void {
			stopWalking(true);
			super.follow(mover);
		}
		
		private function onWalk(e:Event):void {
			var dx:Number = goal.x-x;
			var dy:Number = goal.y-y;
			var dist:Number = Math.sqrt(dx*dx+dy*dy);
			var interactGoal:HotObject = null, reachedGoal:Boolean = false;
			if(dist>1) {
				var spd:Number = Math.min(dist,speed);
				var mx:Number = dx/dist*spd;
				var my:Number = dy/dist*spd;
				if(master.canGo(x+mx,y+my)) {
					x += mx;
					y += my;
					setDirection(dx);
				}
				else {
					if(goalObject && goalObject.canInteract(this)) {
						interactGoal = goalObject;
						reachedGoal = true;
					}
					else {
						interactGoal = goalObject;
					}
					stopWalking();
				}
			}
			else {
				x = goal.x;
				y = goal.y;
				if(goalObject && goalObject.canInteract(this)) {
					interactGoal = goalObject;
					reachedGoal = true;
				}
				stopWalking();
			}
			
			if(interactGoal) {
				if(reachedGoal) {
					if(interactGoal.hotPos)
						setDirection(interactGoal.hotPos.direction);
					interact(interactGoal,false);
				}
				else {
					interact(interactGoal,true);
				}
			}
			
			if(dudemover && distanceTo(dudemover)>100) {
				setMover(null);
			}
		}
		
		public function interact(hotObject:HotObject,fail:Boolean=false):void {
			var item:String = usingItem;
			usingItem = null;
			if(fail) {
				master.failaction(hotObject,this,item);
			}
			else {
				master.action(hotObject,this,item);
			}
		}
		
		public function useItem(item:String):void {
			var dude:Dude = this;
			switch(item) {
				case "timeRemote":
					setLabel("TIMEREMOTE",true,
						function():void {
							master.gameOver(dude);
						});
					break;
			}
		}
	}
	
}
 