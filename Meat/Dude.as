package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class Dude extends Meatly {
		
		private var walkingCallback:Function = null;

		public function destroyed():void {
			master.scriptEnded(self);
			dispatchEvent(new Event("move"));
		}
		
		public function stopMoving():void {
			if(walkingCallback!=null) {
				removeEventListener(Event.ENTER_FRAME,walkingCallback);
				walkingCallback = null;
			}
		}
		
		public function walkTo(object:HotObject,callback:Function):void {
			dispatchEvent(new Event("move"));
//			if(currentLabel=="STOP"||currentLabel=="STOPLEFT"||currentLabel=="ANGRY") {
				gotoAndPlay("WALK");
				if(walkingCallback!=null) {
					removeEventListener(Event.ENTER_FRAME,walkingCallback);
					walkingCallback = null;
				}
				addEventListener(Event.ENTER_FRAME,
					walkingCallback = function(e:Event):void {
						if(object.blocked) {
							objX = object.x,objY = object.y;
							if(object.hotPos) {
								point = parent.globalToLocal(object.hotPos.localToGlobal(new Point()));
								objX = point.x;
								objY = point.y
							}
							dx= objX-x;
							dy = objY-y;
							if(dx*scaleX>0) {
								scaleX = -scaleX;
							}
							e.currentTarget.removeEventListener(e.type,arguments.callee);
							walkingCallback = null;
							gotoAndStop("STOP");							
						}
						else {
							var objX:Number = object.x,objY:Number = object.y;
							if(object.hotPos) {
								var point:Point = parent.globalToLocal(object.hotPos.localToGlobal(new Point()));
								objX = point.x;
								objY = point.y
							}
//							objX += (Math.random()-.5)*10;
//							objY += (Math.random()-.5)*10;
							var dx:Number = objX-x;
							var dy:Number = objY-y;
							if(dx*scaleX>0) {
								scaleX = -scaleX;
							}
							var dist:Number = Math.sqrt(dx*dx+dy*dy);
							x += dx/dist*5;
							y += dy/dist*5;
							if(dist<5) {
								if(object.hotPos) {
									if(object.hotPos.direction*scaleX>0) {
										scaleX = -scaleX;
									}
								}
								e.currentTarget.removeEventListener(e.type,arguments.callee);
								walkingCallback = null;
								gotoAndStop("STOP");
								callback(self,object);
							}
						}
					});
//			}
		}
	}
	
}
