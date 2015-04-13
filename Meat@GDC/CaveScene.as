package  {
	
	import flash.display.MovieClip;
	
	
	public class CaveScene extends Game {
		
		public function CaveScene() {
			scripts = {
				scene: {
					noFadein:true,
					initialize : function():void {
						
						var dude:Dude = setDude("dude1",persisted_id);
						born(dude);
						dude.visible = false;
						enterCave.activator = dude;
						enterCave.setLabel("ENTER",true,
							function():void {
								enterCave.setLabel("STILL",false);
								dude.visible = true;
								dude.setDirection(-1);
							});
					},
					hotspots: [
						"cheat"
					]
				},
				"dude1" : {
					hotspots: [
						"toAlley",
						"spear"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"toAlley": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						enterCave.setLabel("EXIT",true,
							function():void {
								if(dude==mainCharacter) {
									gotoScene("Alley",false);
								}
							});
					}
				},
				"spear": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("PICKUP");
					},
					end: function(object:HotObject,dude:Dude):void {
						dude.visible = true;
						object.visible = false;
						dude.hero.pickupItem("spear");
					}
				}
			};
		}
	}
	
}
