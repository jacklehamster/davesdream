package  {
	
	import flash.display.MovieClip;
	
	
	public class ThePyramid extends Game {
		
		public function ThePyramid() {
			scripts = {
				scene: {
					initialize : function():void {
						creatureEscape.visible = false;
						if(solvedLevel) {
							leftped.supports++;
							rightped.supports++;
						}
						
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude,{lastLevel:previousLevel});
					},
					born: function(dude:Dude):void {
						if(dude.hero.state.ridingCreature) {
							dude.visible = false;
							leftped.supports++;
							rightped.supports++;
							creatureEscape.visible = true;
							mouseAction(dude,creatureEscape,null);
						}
						else {
							if(dude.lastLevel=="Crossing") {
								dude.setPosition(door);
								dude1.setPosition(ground);
							}
							else if(dude.lastLevel=="Crevasse") {
								dude.setPosition(exitToCrevasse);
								dude1.setPosition(ground);
							}
							mouseAction(dude,dude1,null);
						}					
					},
					hotspots: [
						"cheat"
					]
				},
				"dude1" : {
					hotspots: [
						"leftped",
						"rightped",
						"door",
						"entrance",
						"ground",
						"exitToCrevasse",
						"exitToLevel1"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"creatureEscape": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						Wearable.fullUpdate(dude,object);
						object.setLabel("ESCAPE");
					},
					end: function(object:HotObject,dude:Dude):void {
						gotoScene("Crevasse",dude,false,false);
					}
				},
				cheat: {
					action: function(object:HotObject,dude:Dude):void {
						leftped.supports++;
						rightped.supports++;
					}
				},
				"dudepedleft": {
					hotspots: [
						"leftped",
						"ground"
					],
					preDestroy : function(dude:Dude):void {
						leftped.supports--;
					}
				},
				"dudepedright": {
					hotspots: [
						"rightped",
						"ground"
					],
					preDestroy : function(dude:Dude):void {
						rightped.supports--;
					}
				},
				"ground": {
					failaction : function(object:HotObject,dude:Dude):void {
						trace(dude.model);
						if(dude.model==dudepedright) {
							mouseAction(dude,rightped,null);
						}
						else if(dude.model==dudepedleft) {
							mouseAction(dude,leftped,null);
						}
					}
				},
				"leftped": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel(dude.model.name=="dude1"?"GOUP":"GODOWN");
					},
					end : function(object:HotObject,dude:Dude):void {
						if(dude.model.name=="dude1") {
							dude = setDude("dudepedleft",dude.id);
						}
						else {
							dude = setDude("dude1",dude.id);
						}
						object.setLabel("STILL",false);
					},
					activate : function(object:HotObject,dude:Dude):void {
						door.activations = (leftped.pushed?1:0) + (rightped.pushed?1:0);
					},
					deactivate : function(object:HotObject,dude:Dude):void {
						door.activations = (leftped.pushed?1:0) + (rightped.pushed?1:0);
					},
					updated : function(object:HotObject):void {
						door.activations = (leftped.pushed?1:0) + (rightped.pushed?1:0);						
					}
				},
				"rightped": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel(dude.model.name=="dude1"?"GOUP":"GODOWN");
					},
					end : function(object:HotObject,dude:Dude):void {
						if(dude.model.name=="dude1") {
							dude = setDude("dudepedright",dude.id);
						}
						else {
							dude = setDude("dude1",dude.id);
							dude.setPosition(dude3,dude3.scaleX);
						}
						object.setLabel("STILL",false);
					},
					activate : function(object:HotObject,dude:Dude):void {
						door.activations = (leftped.pushed?1:0) + (rightped.pushed?1:0);
					},
					deactivate : function(object:HotObject,dude:Dude):void {
						door.activations = (leftped.pushed?1:0) + (rightped.pushed?1:0);
					},
					updated : function(object:HotObject):void {
						door.activations = (leftped.pushed?1:0) + (rightped.pushed?1:0);						
					}
				},
				"entrance": {
					action: function(object:HotObject,dude:Dude):void {
						if(door.currentLabel=="OPENED") {
							dude.visible = false;
							object.activator = dude;
							object.setLabel("ENTER",true);
						}
					},
					"end": function(object:HotObject,dude:Dude):void {
						entrance.setLabel("STILL",false);
						gotoScene("Crossing",dude,true,true);
					}
				},
				"exitToCrevasse": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Crevasse",dude,false,false);
					}					
				},
				"exitToLevel1": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Level1",dude,false,false);
					}					
				},
				"door": {
					action: function(object:HotObject,dude:Dude):void {
						mouseAction(dude,entrance,null);
					}
				}
				
			};
		}
	}
	
}
