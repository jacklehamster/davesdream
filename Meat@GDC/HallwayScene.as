package  {
	
	import flash.display.MovieClip;
	
	
	public class HallwayScene extends Game {
		
		
		public function HallwayScene() {
			scripts = {
				scene: {
					nonStop:true,
					noNeedRemote:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude,{lastLevel:previousLevel});
						if(dude.hero.hasItem("seenTitle")) {
							musicBy.visible = false;
						}
					},
					born: function(dude:Dude):void {
						if(dude.lastLevel=="Lobby") {
							dude.setPosition(dude0_2);
							dude1.setPosition(dude1_2);
						}						
						mouseAction(dude,dude1,null);
					},
					hotspots: [
						"musicBy"
					]
				},
				"dude1" : {
					hotspots: [
						"toLobby",
						"toIntroLevel"
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
				"toLobby": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Lobby",dude,false,false);
					}
				},
				"toIntroLevel": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("IntroLevel",dude,false,false);
					}
				}
			}
		}
		
		override protected function get music():Class {
			return IntroMusic;
		}
	}
	
}
