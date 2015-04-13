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
		
		public function stopWalking(changeLabel:Boolean=true):void {
			if(changeLabel && currentLabel=="WALK")
				setLabel("STAND");
			removeEventListener(Event.ENTER_FRAME,onWalk);
			goal = null;
			goalObject = null;
		}
		
		public function walkTo(hotObject:HotObject=null):void {
			var hot:DisplayObject = hotObject.walkPoint;
			var point:Point = master.globalToLocal(hot.localToGlobal(new Point()));
			if(goal) {
				stopWalking(false);
			}
			setLabel(master && master.crawlScene?"CRAWL":"WALK");
			goal = point;
			goalObject = hotObject;
			addEventListener(Event.ENTER_FRAME,onWalk);
		}
		

		override public function follow(mover:IMover):void {
			stopWalking(true);
			super.follow(mover);
		}
		
		private function onWalk(e:Event):void {
			var dx:Number = goal.x-x;
			var dy:Number = goal.y-y;
			var dist:Number = Math.sqrt(dx*dx+dy*dy);
			var interactGoal:HotObject = null, reachedGoal:Boolean = false;
			var didWalk:Boolean = false;
			if(dist>1) {
				var spd:Number = Math.min(dist,speed);
				var mx:Number = dx/dist*spd;
				var my:Number = dy/dist*spd;
				if(master.canGo(e.currentTarget as Dude,x+mx,y+my)) {
					didWalk = true;
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
			
			if(didWalk && dudemover && distanceTo(dudemover)>100) {
				setMover(null);
			}
			
			if(master)
				master.detect(e.currentTarget as Dude,x,y);
		}
		
		override public function setDirection(dir:Number):void {
			if(currentLabel=="CRAWLBLOCK") {
				oozie.gotoAndStop(dir*scaleX>0?"LEFT":"RIGHT");
			}
			else {
				super.setDirection(dir);
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
					doomed = true;
					master.preVanish(dude);
					setLabel(currentLabel=="BURIED"?"BURIEDREMOTE":master.crawlScene?"CRAWLTIMEREMOTE":"TIMEREMOTE",true,
						function():void {
							dude.visible = false;
							master.gameOver(dude);
						});
					break;
			}
		}
		
		public function get hero():Hero {
			return ActionSpace.heroes[id];
		}
	}
	
}
 