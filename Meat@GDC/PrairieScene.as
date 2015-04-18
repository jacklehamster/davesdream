package  {
	
	import flash.display.MovieClip;
	
	
	public class PrairieScene extends Game {
		
		override protected function get music():Class {
			return CareFreeSong;
		}
		
		
		public function PrairieScene() {
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
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"exitToCrevasse": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Crevasse",dude,false,false);
					}
					
				},
				"creatureEscape": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						Wearable.fullUpdate(dude,object);
						object.setLabel("ESCAPE");
					},
					end: function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				}
			};
		}
	}
	
}
