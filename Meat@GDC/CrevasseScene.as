package  {
	
	import flash.display.MovieClip;
	
	
	public class CrevasseScene extends Game {
		
		
		public function CrevasseScene() {
			scripts = {
				scene: {
					noFadein:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude,{speed:2});
						if(dude.hero.state.ridingCreature) {
							dude.visible = false;
							creatureEscape.visible = true;
							mouseAction(dude,creatureEscape,null);
						}
						else if(lastLevel=="Prairie") {
							dude.setPosition(dude0_2);
							mouseAction(dude,dude1_2,null);
						}
						else {
							mouseAction(dude,dude1,null);
						}
					},
					hotspots: [
						"cheat"
					]
				},
				"dude1" : {
					hotspots: [
						"exitToPyramid",
						"exitToPrairie",
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"dude1_2" : {
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"exitToPyramid": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("ThePyramid",dude,false,false);
					}
					
				},
				"creatureEscape": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						Wearable.fullUpdate(dude,object);
						object.setLabel("ESCAPE");
					},
					end: function(object:HotObject,dude:Dude):void {
						gotoScene("Prairie",dude,false,false);
					}
				}
			};
		}
	}
	
}
