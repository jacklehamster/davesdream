package  {
	
	import flash.display.MovieClip;
	
	
	public class IntroLevel extends Game {
		
		
		public function IntroLevel() {
			scripts = {
				scene: {
					nonStop:true,
					noNeedRemote:true,
					initialize : function():void {
						persisted_id = 1;
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude,{lastLevel:previousLevel});
						programmingBy.visible = dude.hero.hasItem("daveRequest") && !dude.hero.hasItem("seenTitle");
					},
					born: function(dude:Dude):void {
						if(dude.lastLevel=="Daves") {
							dude.setPosition(door1);
							dude1.setPosition(switch1);
							door1.setLabel("OPEN");
							switch1.setLabel("DOWN",false);
						}
						mouseAction(dude,dude1,null);
					},
					hotspots: [
						"cheat",
						"balancecheat",
						"programmingBy"
					]
				},
				"dude1" : {
					hotspots: [
						"switch1",
						"door1",
						"drawer",
						"toHallway",
						"bed"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"toHallway": {
					action: function(object:HotObject,dude:Dude):void {
						if(dude.hero.hasItem("daveRequest")) {
							gotoScene("Hallway",dude,false,false);
						}
						else {
							mouseAction(dude,dude1,null);
						}
					}
				},
				"balancecheat": {
					action: function(object:HotObject,dude:Dude):void {
//						dude.hero.pickupItem("daveRequest");
//						dude.hero.pickupItem("wallet");
						gotoScene(Game.jumpScene,dude,false,false);
					}
				},
				"drawer": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						if(dude.hero.hasItem("daveRequest") && !dude.hero.hasItem("wallet")) {
							object.setLabel("GETWALLET");
						}
						else {
							object.setLabel("OPENDRAWER");
						}
					},
					end : function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="GETWALLET") {
							dude.hero.pickupItem("wallet");
						}
						dude.visible = true;
						object.setLabel("STILL",false);
					}
				},
				"bed": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						if(object.currentLabel=="STILL") {
							object.setLabel("SLEEP");
						}
						else if(object.currentLabel=="SLEEP") {
							object.setLabel("WAKE");
						}
					},
					end : function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="SLEEP") {
							object.activator = dude;
						}
						else if(object.currentLabel=="WAKE") {
							object.setLabel("STILL",false);
							dude.visible = true;
						}
					}
				},
				"switch1" : {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						
						object.setLabel(object.currentLabel=="UP"?"SWITCHDOWN":"SWITCHUP");
					},
					activate: function(object:HotObject,dude:Dude):void {
						door1.setLabel(object.currentLabel=="SWITCHDOWN"?"OPEN":"CLOSE");
					},
					end : function(object:HotObject,dude:Dude):void {
						dude.visible = true;
						object.setLabel(object.currentLabel=="SWITCHDOWN"?"DOWN":
							object.currentLabel=="SWITCHUP"?"UP":object.currentLabel,false);
					}
				},
				"door1": {
					action: function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="OPEN") {
							dude = setDude("dude2",dude.id);
							mouseAction(dude,dude3,null);
						}
					}
				},
				"dude3": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Daves",dude,false,false);
					}
				}
			}
		}	
		
		override protected function get music():Class {
			return IntroMusic;
		}
	}
	
}
