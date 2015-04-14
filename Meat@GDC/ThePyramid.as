package  {
	
	import flash.display.MovieClip;
	
	
	public class ThePyramid extends Game {
		
		
		public function ThePyramid() {
			scripts = {
				scene: {
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						if(lastLevel=="Crossing") {
							dude.setPosition(door);
						}
						mouseAction(dude,dude1,null);
						if(solvedLevel) {
							leftped.supports++;
							rightped.supports++;
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
						"ground"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
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
						if(dude==mainCharacter) {
							solveLevel();
							gotoScene("Crossing");
						}
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
