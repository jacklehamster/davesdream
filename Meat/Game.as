package  {
	
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.ui.MouseCursor;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import by.blooddy.crypto.MD5;
	import flash.display.BlendMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.newgrounds.API;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	//	sound assets: http://www.flashkit.com/soundfx/Communication/Typewriter/Keyboard-Submersi-8700/index.php
	//	music: http://www.newgrounds.com/audio/listen/616467
	//	http://www.newgrounds.com/audio/listen/604401
	
	
	public class Game extends MovieClip {
		
		var debug:Boolean = false;
		static public var global_history:Array = [];
		
		const SCRIPTS:Object = {
			"dev": {
				hotspots: [
					"uparrow"
				]
			},
			"dev2": {
				hotspots: [
					"goback"
				]
			},
			"finaldev": {
				hotspots: [
					"sleepy"
				]
			},
			"dave1": {
				hotspots: [
					"pipe1"
				]
			},
			"dave2": {
				hotspots: [
					"pipe2"
				]
			},
			"dave3": {
				hotspots: [
					"wheel",
					"movingplatform"
				]
			},
			"dave4": {
				hotspots: [
					"leftwalk",
					"rightwalk",
					"pipe2"
				]
			},
			"daveplatform": {
				hotspots: [
					"longplatform",
					"pipe2"
				]
			},
			"daveswitcher": {
				hotspots: [
					"lightswitch"
				]
			},
			"walkend": {
				hotspots: [
					"leftdoor",
					"bigbutton",
					"gate",
					"ladder",
					"ledge"
				]
			},
			"walk2": {
				hotspots: [
					"platform1"
				]
			},
			"walk3": {
				hotspots: [
					"platform2"
				]
			},
			"walk4": {
				hotspots: [
					"fire1",
					"fire2",
				]
			},
			"walk5": {
				hotspots: [
					"platformalmost"
				]
			},
			"walk6": {
				hotspots: [
					"platformside"
				]
			},
			"walk7": {
				hotspots: [
					"switch2"
				]
			},
			"walkalmost": {
				hotspots: [
					"endplatform"
				]
			},
			"meat1": {
				hotspots: [
					"westcircle",
					"highplatform",
					"northcircle"
				]
			},
			"meat2": {
				hotspots: [
					"westcircle",
					"northcircle",
					"lowplatform",
					"pickuppaddle",
					"highplatform"
				]
			},
			"meat3": {
				hotspots: [
					"highplatform",
					"paddleplatform"
				]
			},
			"meat4": {
				hotspots: [
					"lowplatform",
					"paddlegift"
				]
			},
			"meat5": {
				hotspots: [
					"ladder2",
					"eastcircle",
					"plank",
					"northcircle",
					"westcircle",
					"highplatform"
				]
			},
			"meatplank": {
				hotspots: [
					"water",
					"backcircle"
				]
			},
			"robinson": {
				hotspots: [
					"sun2",
					"boat",
					"lightswitch2"
				]
			},
			"robinsonwell": {
				hotspots: [
					"well",
					"boat2"
				]
			},
			"sun" :{
				
			},
			"sun2": {
				
			},
			"boat" :{
				canWalkTo:true
			},
			"boat2": {
				
			},
			"sleepy": {
				
			},
			"gun_": {
				action: function(object:HotObject,meatly:Meatly):void {
					meatly.scaleX = Math.abs(meatly.scaleX);
					if(meatly is Dude)
						(meatly as Dude).stopMoving();
					meatly.runScript("SELFDESTROY",true);
					if(meatly.model.name=="dave4") {
						wheel.gotoAndStop(1);
					}
				},
				end: function(object:HotObject,meatly:Meatly):void {
					if(meatly.parent) {
						meatly.parent.removeChild(meatly);
					}
					delete meatlies[meatly.id];
					if(meatly==meat)
						setLabel(SFX?1:2,"ShootScene");
//						MovieClip(parent).gotoAndPlay(1,"ShootScene");
//					else
//						addItem("gun");
				}
			},
			"paddle_highplatform": {
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("THROWPADDLE",true);
					if(meat==meatly)
						removeItem("paddle");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					meatly.visible = true;
					object.occupied = false;
					object.gotoAndStop(1);
					pickuppaddle.visible = true;
				}
			},
			"paddle_boat": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("ROW",true);
				},
				end:function(object:HotObject,meatly:Meatly):void {
					//boat2.visible = true;
					meatly.visible = true;
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,robinsonwell,"STOP");
					
					object.visible = false;
					var timeout:int = setTimeout(function():void { clearTimeout(timeout); object.visible = true; },3000);
					
					if(meatly==meat) {
						setLabel("WELL");
					}
				}
			},
			"paddle_boat2": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("ROWBACK",true);
				},
				end:function(object:HotObject,meatly:Meatly):void {
					meatly.visible = true;
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,robinson,"STOP");
					
					object.visible = false;
					var timeout:int = setTimeout(function():void { clearTimeout(timeout); object.visible = true; },3000);
					
					if(meatly==meat) {
						setLabel("BACKTOISLAND");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="BACKTOISLAND") {
//						MovieClip(parent).gotoAndPlay("BACKTOISLAND");
//					}
				}
			},
			"rope_sun2": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					if(object.currentLabel=="MOON") {
						object.occupied = true;
						meatly.visible = false;
						object.runScript("INDIANA");
					}
				},
				end:function(object:HotObject,meatly:Meatly):void {
					if(meat==meatly) {
						removeItem("rope");
					}
					object.occupied = false;
					object.gotoAndStop("MOON");
					meatly = setMeat(meatly.id,dev,"STOP");
					meatly.scaleX = -Math.abs(meatly.scaleX);

					if(meatly==meat) {
						setLabel("STAIRS");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="STAIRS") {
//						MovieClip(parent).gotoAndPlay("STAIRS");
//					}
				}
				
			},
			"bucket_sleepy": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("WAKE");
				}
				
			},
			"uparrow": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					meatly = setMeat(meatly.id,dev2,"ANGRY");
					meatly.scaleX = -Math.abs(meatly.scaleX);
					if(meatly==meat) {
						setLabel("DEV");
//					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="DEV") {
//						MovieClip(parent).gotoAndPlay("DEV");
					}
				}
			},
			"goback": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					stairs.visible = false;
					uparrow.visible = false;
					sleepy.visible = true;
					meatly = setMeat(meatly.id,finaldev,"STOP");
					meatly.scaleX = -Math.abs(meatly.scaleX);
					if(meatly==meat) {
						setLabel("FINAL");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="FINAL") {
//						MovieClip(parent).gotoAndPlay("FINAL");
//					}
				}
			},
			"platformside": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("WALK");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					setMeat(meatly.id,walk7,"STOP");
				}
			},
			"platform2": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("WALK");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					setMeat(meatly.id,walk4,"STOP");
				}
			},
			"movingplatform": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("JUMP");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,daveplatform,"STOP");
					object.activator = meatly;
					meatly.scaleX = -Math.abs(meatly.scaleX);
					(object as MovingPlatform).holders[meatly.id] = meatly;
				}
			},
			"longplatform": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("JUMPDOWN");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,daveswitcher,"STOP");
				}
			},
			"ladder": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("CLIMB");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,meat1,"STOP");
					if(meatly==meat) {
						setLabel("TOLEDGE");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="TOLEDGE") {
//						MovieClip(parent).gotoAndPlay("TOLEDGE");
//					}
				}
			},
			"ladder2": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("CLIMB");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,dave1,"STOPLEFT");
					meatly.scaleX = -Math.abs(meatly.scaleX);
					if(meatly==meat) {
						setLabel("UPSTAGE");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="UPSTAGE") {
//						MovieClip(parent).gotoAndPlay("UPSTAGE");
//					}
				}
			},
			"paddleplatform": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("JUMPDOWN");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					setMeat(meatly.id,meat4,"STOPLEFT");
				}
			},
			"paddlegift": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("GETGIFT");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					if(meat==meatly)
						addItem("paddle");
					meatly = setMeat(meatly.id,meat4,"STOP");
					var timeout:int = setTimeout(
						function():void {
							clearTimeout(timeout);
							if(object.currentFrame==object.totalFrames) {
								object.gotoAndStop(1);
							}
						},5000);
				}
			},
			"well": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("TAKEBUCKET");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					if(meat==meatly) {
						addItem("bucket");
						addItem("rope");
					}
					meatly.visible = true;
					object.gotoAndStop(1);
				}
			},
			"platform1": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("WALK");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					setMeat(meatly.id,walk3,"STOP");
				}
			},
			"water": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("JUMP");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,robinson,"STOP");
					if(meatly==meat) {
						setLabel("ISLAND");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="ISLAND") {
//						MovieClip(parent).gotoAndPlay("ISLAND");
//					}					
				}
			},
			"pipe1": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("CLIMB");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					setMeat(meatly.id,dave2,"STOP");
				}
			},
			"pipe2": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					if(meatly.model.name=="dave4") {
						meatly = setMeat(meatly.id,dave3,"STOP");
						wheel.gotoAndStop(1);
					}
					else if(meatly.model.name=="daveplatform") {
						if(meatly.x<800) {
							object.occupied = true;
							meatly.visible = false;
							object.runScript("CLIMBBACK",true);
						}
					}
					else {
						object.occupied = true;
						meatly.visible = false;
						object.runScript("CLIMB",true);
					}
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,dave3,"STOP");
					if(meatly==meat) {
						setLabel("WHEEL");
					}
//					if(meatly==meat && MovieClip(parent).currentLabel!="WHEEL")
//						MovieClip(parent).gotoAndPlay("WHEEL");
				}
			},
			"wheel": {
				direct:true,
				canGoFunction : function(object:HotObject,meatly:Meatly):Boolean {
					return object.currentFrame==1;
				},
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("CLIMB",true);
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,dave4,"STOP");
					object.activator = meatly;
					if(meatly==meat) {
						setLabel("WHEEL");
					}
//					if(meatly==meat && MovieClip(parent).currentLabel!="WHEEL")
//						MovieClip(parent).gotoAndPlay("WHEEL");
				}
			},
			"rightwalk": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					meatly.gotoAndPlay("WALK");
					meatly.scaleX = -Math.abs(meatly.scaleX);
					wheel.gotoAndPlay("WALKRIGHT");
				}
			},
			"leftwalk": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					meatly.gotoAndPlay("WALK");
					meatly.scaleX = Math.abs(meatly.scaleX);
					wheel.gotoAndPlay("WALKLEFT");
				}
			},
			"pickuppaddle": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					highplatform.runScript("PICKPADDLE",true);
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					meatly = setMeat(meatly.id,meat2,"STOP");
					meatly.scaleX = -Math.abs(meatly.scaleX);
					highplatform.gotoAndStop(1);
					if(meat==meatly) {
						addItem("paddle");						
					}
				}
			},
			"highplatform": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					if(meatly.model.name=="meat3") {
						object.occupied = true;
						meatly.visible = false;
						object.runScript("TOOHIGH",true);
					}
					else {
						object.occupied = true;
						meatly.visible = false;
						object.runScript("JUMP",true);
					}
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,meatly.model.name=="meat3"?meat3:meat2,"STOP");
					meatly.scaleX = -Math.abs(meatly.scaleX);
				}
			},
			"lowplatform": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript(meatly.model.name=="meat4"?"JUMPUP":"JUMPDOWN",meatly.model.name!="meat4");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					meatly = setMeat(meatly.id,meat3,"STOP");
					if(meatly==meat) {
						setLabel("PADDLE");
					}
//					if(meatly==meat && MovieClip(parent).currentLabel!="PADDLE")
//						MovieClip(parent).gotoAndPlay("PADDLE");
				}
			},
			"platformalmost": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("WALK");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					setMeat(meatly.id,walkalmost,"STOP");
				}
			},
			"endplatform": {
				direct:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("WALK");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					setMeat(meatly.id,walkend,"STOP");
				}
			},
			"fire1": {
				direct:true,
				canGoFunction : function(object:HotObject,meatly:Meatly):Boolean {
					return meatly!=meat || object.currentLabel=="NONE";
				},
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("WALK");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					setMeat(meatly.id,walk5,"STOP");
				}
			},
			"fire2": {
				direct:true,
				canGoFunction : function(object:HotObject,meatly:Meatly):Boolean {
					return meatly!=meat || object.currentLabel=="NONE";
				},
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					meatly.visible = false;
					object.runScript("WALK");
				},
				end:function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					object.gotoAndStop(1);
					setMeat(meatly.id,walk6,"STOP");
				}
			},
			"drawer1": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					block(meatly);
					meatly.visible = false;
					object.runScript("OPEN");
				},
				activate: function(object:HotObject,meatly:Meatly):void {
					if(items.gun && meat==meatly) {
						object.gotoAndPlay("CLOSE");
					}
				},
				end: function(object:HotObject,meatly:Meatly):void {
					unblock(meatly);
					meatly.visible = true;
					object.gotoAndStop(1);
					if(meat==meatly)
						addItem("gun");
					object.occupied = false;
				}
			},
			"wake": {
				hotspots: [
					"wake"
				],
				end: function(object:HotObject,meatly:Meatly):void {
					var m:Meatly = setMeat(meatly?meatly.id:null,walk1,"STOP");
					recordBirth(m);
					unblock(m);
				}
			},
			"walk1": {
				hotspots: [
					"switch1",
					"door1",
					"drawer1",
					"lightswitch"
				]
			},
			"ledge": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					if(meatly==meat) {
						setLabel("TOLEDGE");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="TOLEDGE") {
//						MovieClip(parent).gotoAndPlay("TOLEDGE");
//					}
				}
			},
			"westcircle": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					if(meatly==meat) {
						setLabel("WESTCIRCLE");
					}
					
//					if(meatly==meat&&MovieClip(parent).currentLabel!="WESTCIRCLE") {
//						MovieClip(parent).gotoAndPlay("WESTCIRCLE");
//					}
				}
			},
			"northcircle": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					meatly=setMeat(meatly.id,meat5,"STOP");
					if(meatly==meat) {
						setLabel("NORTHCIRCLE");
					}
					
//					if(meatly==meat&&MovieClip(parent).currentLabel!="NORTHCIRCLE") {
//						MovieClip(parent).gotoAndPlay("NORTHCIRCLE");
//					}
				}
			},
			"eastcircle": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					
					if(meatly==meat) {
						setLabel("EASTCIRCLE");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="EASTCIRCLE") {
//						MovieClip(parent).gotoAndPlay("EASTCIRCLE");
//					}
				}
			},
			"plank": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					meatly = setMeat(meatly.id,meatplank,"STOP");
					meatly.scaleX = -Math.abs(meatly.scaleX);
					
					if(meatly==meat) {
						setLabel("PLANK");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="PLANK") {
//						MovieClip(parent).gotoAndPlay("PLANK");
//					}					
				}
			},
			"backcircle": {
				canWalkTo:true,
				action: function(object:HotObject,meatly:Meatly):void {
					meatly = setMeat(meatly.id,meat5,"STOP");
					if(meatly==meat) {
						setLabel("NORTHCIRCLE");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="NORTHCIRCLE") {
//						MovieClip(parent).gotoAndPlay("NORTHCIRCLE");
//					}
				}
			},
			"gate": {
				direct: true,
				action: function(object:HotObject,meatly:Meatly):void {
					handlePress(ledge,meatly);
				}
			},
			"leftdoor": {
				canWalkTo: true,
				action: function(object:HotObject,meatly:Meatly):void {
					if(meatly==meat) {
						setLabel(MovieClip(root).currentLabel!="LEFTDOOR"?"LEFTDOOR":"LEFTDOORRIGHT");
					}
//					if(meatly==meat)
//						MovieClip(parent(MovieClip(parent).currentLabel!="LEFTDOOR"?"LEFTDOOR":"LEFTDOORRIGHT");
				}
			},
			"bigbutton": {
				canWalkTo: true,
				action: function(object:HotObject,meatly:Meatly):void {
					if(meatly==meat) {
						setLabel("LEFTDOOR");
					}
//					if(meatly==meat&&MovieClip(parent).currentLabel!="LEFTDOOR")
//						MovieClip(parent).gotoAndPlay("LEFTDOOR");
					bigbutton.steppedOn(meatly);
				}
			},
			"lightswitch": {
				canWalkTo: true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					block(meatly);
					meatly.visible = false;
					object.runScript();
				},
				activate: function(object:HotObject,meatly:Meatly):void {
					MovieClip(parent).night.visible = !MovieClip(parent).night.visible;
					sun.gotoAndStop(MovieClip(parent).night.visible?"MOON":"SUN");
					sun2.gotoAndStop(MovieClip(parent).night.visible?"MOON":"SUN");
				},
				end: function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					unblock(meatly);
					meatly.visible = true;
				}
			},
			"lightswitch2": {
				canWalkTo: true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					block(meatly);
					meatly.visible = false;
					object.runScript();
				},
				activate: function(object:HotObject,meatly:Meatly):void {
					MovieClip(parent).night.visible = !MovieClip(parent).night.visible;
					sun.gotoAndStop(MovieClip(parent).night.visible?"MOON":"SUN");
					sun2.gotoAndStop(MovieClip(parent).night.visible?"MOON":"SUN");
				},
				end: function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					unblock(meatly);
					meatly.visible = true;
				}
			},
			"switch1": {
				canWalkTo: true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					block(meatly);
					meatly.visible = false;
					object.runScript("SWITCH");
				},
				activate: function(object:HotObject,meatly:Meatly):void {
					door1.runScript();
				},
				end: function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					unblock(meatly);
					meatly.visible = true;
					meatly.scaleX = -Math.abs(meatly.scaleX);
					object.gotoAndStop(1);
				}
			},
			"switch2": {
				canWalkTo: true,
				action: function(object:HotObject,meatly:Meatly):void {
					object.occupied = true;
					block(meatly);
					meatly.visible = false;
					object.runScript("SWITCH");
				},
				activate: function(object:HotObject,meatly:Meatly):void {
					fire1.gotoAndStop("NONE");
					fire2.gotoAndPlay("FIRE");
				},
				end: function(object:HotObject,meatly:Meatly):void {
					object.occupied = false;
					unblock(meatly);
					meatly.visible = true;
					meatly.scaleX = -Math.abs(meatly.scaleX);
					object.gotoAndStop(1);
				}
			},
			"meatlygoup": {
				end: function(object:HotObject,meatly:Meatly):void {
					unblock(meatly);
					setMeat(meatly.id,walk2,"STOP");
				}
			},
			"door1": {
				canWalkTo: true,
				action: function(object:HotObject,meatly:Meatly):void {
					//trace(object.currentLabel,meatly);
					if(object.currentLabel=="OPENED"||debug) {	//	<< BUGBUG
						if(debug) {
							addItem("paddle");
							addItem("bucket");
							addItem("rope");
						}
						addItem("gun");

						meatly = setMeat(meatly.id,meatlygoup);
						meatly.play();
						block(meatly);
						if(meatly==meat) {
							setLabel("LEVEL2");
						}
						(meatly as MeatlyGoUp).callback = function():void {
							meatly = setMeat(meatly.id,walk2,"STOP");
							unblock(meatly);
//							if(meat==meatly)
//								MovieClip(parent).gotoAndPlay("LEVEL2");							
						};
						
					}
				},
				end: function(object:HotObject,meatly:Meatly):void {
					object.gotoAndStop(1);
				}
			}
		};
		
		public var meat:Meatly = null;
		
		private var items:Object = {};
		private var selectedItem:String = null;
		private var history:Array = [];
		private var frame:int = 0;
		private var meatlies:Object = {};
		private var rescueMeat:Meatly;
		private var rescueLabel:String;
		
		private var repeater:Object = {};
		
		static private var SFX:Boolean = true;
		
		private function addItem(item:String):void {
			items[item] = true;
			updateInventory();
		}
		
		private function removeItem(item:String):void {
			delete items[item];
			updateInventory();
		}
		
		private function setLabel(label:Object,scene:String=null):void {
			if(root) {
				if(MovieClip(root).currentLabel!=label)
					MovieClip(root).gotoAndPlay(label,scene);
				rescueLabel	= ""+label;
			}
		}
		
		public function select(item:String):void {
			meat.mouseEnabled = true;
			var wasSelected:Boolean = selectedItem!=null;
			selectedItem = item;
			updateInventory();
			if(!wasSelected) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN,
					function(e:MouseEvent):void {
						e.currentTarget.removeEventListener(e.type,arguments.callee);
						select(null);
						meat.mouseEnabled = false;
					});
			}
		}
		
		private function repeatHistory():void {
			for each(var array:Array in global_history) {
				for each(var entry:Object in array) {
					if(!repeater[entry.frame])
						repeater[entry.frame] = [];
					repeater[entry.frame].push(entry);
				}
			}
		}
		
		public function Game():void {

			repeatHistory();
			
			
			global_history.push(history);
//			trace(JSON.stringify(repeater,null,"\t"));
			mouseEnabled = false;
			start();
			addEventListener(Event.ADDED_TO_STAGE,
				function(e:Event):void {
					stage.focus = root as MovieClip;
					MovieClip(parent).inventory.mouseEnabled = false;
					updateInventory();
					addEventListener(Event.ENTER_FRAME,onFrame);
					stage.addEventListener(KeyboardEvent.KEY_UP,onKey);
				});
			addEventListener(Event.REMOVED_FROM_STAGE,
				function(e:Event):void {
					removeEventListener(Event.ENTER_FRAME,onFrame);
					stage.removeEventListener(KeyboardEvent.KEY_UP,onKey);
				});
				
			if(!debug)
				fire1.gotoAndPlay("FIRE");	//	bugbug
			platform1.visible = true;
			platform2.visible = true;
			if(!debug) {
				ledge.blocked = true;
				lightswitch2.visible = false;
			}
			sleepy.visible = false;
			pickuppaddle.visible = false;
			MovieClip(parent).night.mouseEnabled = MovieClip(parent).night.mouseChildren = false;
			MovieClip(parent).night.visible = false;
			
		}
		
		private function onKey(e:KeyboardEvent):void {
			if(root) {
				switch(e.keyCode) {
					case Keyboard.ESCAPE:
						global_history = [];
						setLabel(1,"Intro");
//						MovieClip(root).gotoAndPlay(1,"Intro");
						break;
					case Keyboard.R:
						recordItem(meat,"gun",null);
						global_history.pop();
						setLabel(2,"ShootScene");
//						MovieClip(parent).gotoAndPlay(2,"ShootScene");
						break;
					case Keyboard.M:
						SoundMixer.soundTransform = new SoundTransform(1-SoundMixer.soundTransform.volume);
						break;
					case Keyboard.S:
						SoundMixer.soundTransform = new SoundTransform(1-SoundMixer.soundTransform.volume);
						setTimeout(
							function():void {
								SoundMixer.soundTransform = new SoundTransform(1-SoundMixer.soundTransform.volume);
							},1000);
						SFX = !SFX;
						break;
				}
			}
		}
		
		private function recordBirth(meatly:Meatly):void {
			if(!meatly.repeater) {
				meatly.id = MD5.hash(new Date()+""+Math.random());
				history.push({frame:frame,id:meatly.id,action:"born"});
			}
		}
		
		private function recordPress(meatly:Meatly,object:HotObject):void {
			if(meatly.id && !meatly.repeater)
				history.push({frame:frame,id:meatly.id,action:"press",model:object.model.name});
		}
		
		private function recordItem(meatly:Meatly,item:String,object:HotObject):void {
			if(meatly.id && !meatly.repeater)
				history.push({frame:frame,id:meatly.id,action:"item",item:item,model:object?object.model.name:null});
		}
		
		private function recordRescue(meatly:Meatly,rescue:Meatly,object:HotObject,label:String,x:Number,y:Number):void {
			trace("RESCUE>",meatly==meat,rescue.model.name,object.model.name,label,x,y);
			if(!meatly.repeater) {
				history.pop();
//				history.push({frame:frame,id:meatly.id,action:"rescue",rescue:rescue.model.name,model:object.model.name,label:label,pos:{x:x,y:y}});
			}
		}
		
		private function recordFastforward(meatly:Meatly,object:HotObject):void {
			if(!meatly.repeater) {
				history.push({frame:frame,id:meatly.id,action:"fastforward",model:object.model.name});
			}
		}
		
		private function onFrame(e:Event):void {
			var array:Array = repeater[frame];
			if(array) {
				var m:Meatly;
				//trace(JSON.stringify(array));
				for each(var entry:Object in array) {
					switch(entry.action) {
						case "born":
							m = createMeat(walk1,"STOP");
							m.id = entry.id;
							m.repeater = true;
							meatlies[entry.id] = m;
							break;
						case "press":
							m = meatlies[entry.id];
							handlePress(self[entry.model],m);
							break;
						case "item":
							m = meatlies[entry.id];
							performItemAction(entry.item,entry.model?self[entry.model]:m,m);
							break;
						case "rescue":
							trace("rescue repeat",entry.model,entry.label,entry.pos.x,entry.pos.y);
							//m = meatlies[entry.id];
							//performRescue(m,self[entry.rescue],self[entry.model],entry.label,entry.pos.x,entry.pos.y);
							break;
						case "fastforward":
							m = meatlies[entry.id];
							fastForward(m,self[entry.model]);
							break;
					}
				}
			}
			frame++;
		}
		
		public function updateInventory():void {
			if(parent) {
				var inventory:MovieClip = (parent as MovieClip).inventory;
				for(var i:int=0;i<inventory.numChildren;i++) {
					var child:Item = inventory.getChildAt(i) as Item;

					if(child) {
						child.visible = items[child.name] && selectedItem!=child.name;
					}
				}
				MovieClip(parent).cursor.visible = selectedItem!=null;
				if(selectedItem)
					MovieClip(parent).cursor.gotoAndStop(selectedItem.toUpperCase());
			}
		}
		
		public function start():void {
			setMeat(null,wake);
		}
		
		private function createMeat(model:Meatly,label:Object=null):Meatly {
			var meat:Meatly;
			meat = new (model.ClassObj)();
			meat.transform.matrix = model.transform.matrix;
			meat.visible = true;
			meat.model = model;
			if(label) {
				meat.gotoAndStop(label);
			}
			else {
				meat.gotoAndStop(1);
			}
			
			addChildAt(meat,getChildIndex(model));
			return meat;
		}
		
		private function setMeat(id:String,model:Meatly,label:Object=null):Meatly {
			var meatly:Meatly = id?meatlies[id]:meat;
			if(!meatly) {
				meatly = meat;
			}
			var selfMeat:Boolean = meatly==meat;
			
			if(meatly && meatly.parent) {
				meatly.parent.removeChild(meatly);
			}
			meatly = createMeat(model,label);


			if(selfMeat) {
				rescueMeat = model;
				rescueLabel = MovieClip(parent).currentLabel;
				var name:String = meatly.model.name;
				var script:Object = SCRIPTS[name];
				if(!script) {
					trace("SCRIPTS['"+name+"'] doesn't exist.");
				}
				else {
					var enables:Object = {};
					for each(var spot:String in script.hotspots) {
						enables[spot] = true;
					}
					for(var i:int=0;i<numChildren;i++) {
						var child:HotObject = getChildAt(i) as HotObject;
						if(child) {
							child.mouseEnabled = enables[child.model.name];
						}
					}
				}
			}
			
			if(!selfMeat) {
				meatlies[id] = meatly;
				meatly.id = id;
				//trace(id,">>>",meatly.model.name);
			}
			else {
				meat = meatly;
				meatly.id = id;
//				meatly.mouseEnabled = true;
			}
			addChildAt(meatly,getChildIndex(model));
			
			return meatly;
		}
		
		private function block(meatly:Meatly):void {
			if(meat==meatly) {
				MovieClip(parent).inventory.mouseChildren = false;
				mouseChildren = false;
				Mouse.cursor = MouseCursor.ARROW;
			}
		}
		
		private function unblock(meatly:Meatly):void {
			if(meat==meatly && parent) {
				Mouse.cursor = MouseCursor.AUTO;
				mouseChildren = true;
				MovieClip(parent).inventory.mouseChildren = true;
			}
		}
		
		private function get self():Game {
			return this;
		}
		
		private function performItemAction(item:String,object:HotObject,meatly:Meatly=null):void {
			var name:String = object.model.name;
			if(object is Dude) {
				name = "";
			}
			var script:Object;
			script = SCRIPTS[item + "_" + name];
			if(!script) {
				trace("NO COMBO:",item+"_"+name);
			}
			else if(script.action) {
				if(script.canWalkTo) {
					recordPress(meatly,object);
					if(script.preaction as Function)
						(script.preaction as Function).call(self,object,meatly);
					(meatly as Dude).walkTo(object,
						function(meatly:Meatly,object:HotObject):void {
							if(object.occupied && object.activator==meat) {
								performRescue(object.activator,rescueMeat,object,rescueLabel,object.activator.x,object.activator.y);
							}
							object.activator = meatly;
							object.scriptRunning = script;
							(script.action as Function).call(self,object,object.activator);
							recordItem(meatly,item,object==meatly?null:object);
						}
					);
				}
				else {
					if(object.occupied && object.activator==meat) {
						performRescue(object.activator,rescueMeat,object,rescueLabel,object.activator.x,object.activator.y);
					}
					object.activator = meatly;
					object.scriptRunning = script;
					(script.action as Function).call(self,object,object.activator);
					recordItem(meatly,item,object==meatly?null:object);
				}
			}
		}
		
		public function handlePress(object:HotObject,meatly:Meatly=null):void {
			if(!meatly)
				meatly = meat;
			var name:String = object.model.name;
			var script:Object;
			if(selectedItem && meatly==meat) {
				performItemAction(selectedItem,object,meatly);
			}
			else if(meatly==object) {
				script = SCRIPTS[name];
				switch(meatly.model) {
					case wake:
						block(meatly);
						meatly.runScript();
						object.scriptRunning = script;
						break;
				}
				recordPress(meatly,object);
			}
			else {
				if((meatly is Dude) && meatly.visible) {
					script = SCRIPTS[name];
					if(!script) {
						trace("SCRIPT missing:",name);
					}
					if(script) {
						if(script.canWalkTo && !object.blocked) {
							recordPress(meatly,object);
							if(script.preaction as Function)
								(script.preaction as Function).call(self,object,meatly);
							
							(meatly as Dude).walkTo(object,
								function(meatly:Meatly,object:HotObject):void {
									//trace(object.occupied,object.model.name);
									if(script.action && (meat!=meatly&&object.activator==meat||!object.occupied) && object.canGo())  {
										if(object.occupied && object.activator==meat) {
//											fastForward(meat,object);
											performRescue(object.activator,rescueMeat,object,rescueLabel,object.activator.x,object.activator.y);
										}
										object.scriptRunning = script;
										object.activator = meatly;
										(script.action as Function).call(self,object,object.activator);
									}
								}
							);
						}
						else if(script.direct) {
							if(script.action && (meat!=meatly&&object.activator==meat||!object.occupied) && object.canGo())  {
								if(object.occupied && object.activator==meat) {
//									fastForward(meat,object);
									performRescue(object.activator,rescueMeat,object,rescueLabel,object.activator.x,object.activator.y);
								}
								object.scriptRunning = script;
								object.activator = meatly;
								(script.action as Function).call(self,object,object.activator);
								recordPress(meatly,object);
							}
						}
					}
				}
			}
		}
		
		private function performRescue(meatly:Meatly,rescue:Meatly,object:HotObject,label:String,x:Number,y:Number):void {
			
			object.clearEnterFrame();
			recordRescue(meatly,rescue,object,label,x,y);
			meatly = setMeat(meatly.id,rescue,"STOP");
			meatly.x = x;
			meatly.y = y;
			setLabel(label);
//			if(MovieClip(root).currentLabel!=label)
//				MovieClip(root).gotoAndPlay(label);
			unblock(meatly);
		}
		
		private function fastForward(meatly:Meatly,object:HotObject):void {
			//trace("FF>>",object.model.name,meatly==meat);
			recordFastforward(meatly,object);
			object.forceScriptEnd();
			object.gotoAndStop(1);
		}
		
		public function activate(object:HotObject):void {
			var script:Object = object.scriptRunning;
			if(!script) {
				script = SCRIPTS[object.model.name];
			}
			if(script.activate)
				(script.activate as Function).call(this,object,object.activator);
		}
		
		public function scriptEnded(object:HotObject):void {
			var script:Object = object.scriptRunning;
			if(!script) {
				script = SCRIPTS[object.model.name];
			}
			if(script.end) {
				//trace("END>",object,object.scriptRunning,object.model.name,object.activator==meat);
				(script.end as Function).call(this,object,object.activator);
			}
			object.scriptRunning = null;
		}
		
		static public function finish(root:MovieClip):void {
			API.unlockMedal("WAKE UP");
			gamejoltAchieve(root);
		}
		
		static private function gamejoltAchieve(root:MovieClip):void {
			var username:String = root.loaderInfo.parameters.gjapi_username;
			var token:String = root.loaderInfo.parameters.gjapi_token;
			if(username && token) {
				var url:String = "http://gamejolt.com/api/game/v1/trophies/add-achieved/";
				var trophyID:String = "20615";
				var gameID:String = "56688";
				var key:String = "1d613c28ca0bbe8a04a96d46869b07a2";
				url += "?game_id="+gameID;
				url += "&username="+username;
				url += "&user_token="+token;
				url += "&trophy_id="+trophyID;
				url += "&format=json";
				url += "&signature="+MD5.hash(url + key);
				var request:URLRequest = new URLRequest(url);
				var urlloader:URLLoader = new URLLoader();
				urlloader.load(request);
				
			}
		}
		
	}
	
}
