package  {
	
	import flash.display.MovieClip;
	
	
	public class LobbyScene extends Game {
		
		
		public function LobbyScene() {
			scripts = {
				scene: {
					nonStop:true,
					noNeedRemote:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude,{lastLevel:previousLevel});
						if(dude.hero.hasItem("seenTitle")) {
							credits.visible = false;
						}
					},
					born: function(dude:Dude):void {
						if(dude.lastLevel=="Outside") {
							dude.setPosition(dude0_2);
							dude1.setPosition(dude1_2);
						}
						mouseAction(dude,dude1,null);
					}
				},
				"dude1" : {
					hotspots: [
						"toHallway",
						"toOutside"
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
				"toHallway": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Hallway",dude,false,false);
					}
				},
				"toOutside": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Outside",dude,false,false);
					}
				}
			};
		}
		
		override protected function get music():Class {
			return IntroMusic;
		}
	}
	
}
