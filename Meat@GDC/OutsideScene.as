package  {
	
	import flash.display.MovieClip;
	
	
	public class OutsideScene extends Game {
		
		
		public function OutsideScene() {
			scripts = {
				scene: {
					nonStop:true,
					noNeedRemote:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						mouseAction(dude,dude1,null);
						if(!dude.hero.hasItem("seenTitle")) {
							dude.hero.pickupItem("seenTitle");
							title.setLabel("APPROACH",true,
								function():void {
									title.visible = false;
								}
							);
						}
						else {
							title.visible = false;
						}
						if(dude.hero.hasItem("brokenSnowman")) {
							snowman.setLabel("BROKEN",false);
						}

					}
				},
				"dude1" : {
					hotspots: [
						"entrance",
						"stairs"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"dude2": {
					hotspots: [
						"snowman",
						"stairs",
						"road",
						"platformToBuilding"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"snowman": {
					action : function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="STILL") {
							dude.visible = false;
							object.setLabel("KICK");
						}
					},
					end: function(object:HotObject,dude:Dude):void {
						dude.visible = true;
						dude.hero.pickupItem("brokenSnowman");
						object.setLabel("BROKEN",false);
					}
				},
				"entrance": {
					action : function(object:HotObject,dude:Dude):void {
						gotoScene("Lobby",dude,false,false);
					}
				},
				"road": {
					action : function(object:HotObject,dude:Dude):void {
						gotoScene("OnTheRoad",dude,false,false);
					}
				},
				"stairs": {
					action : function(object:HotObject,dude:Dude):void {
						if(dude.model==dude1) {
							dude.visible = false;
							object.setLabel("JUMPDOWN");
						}
						else if(dude.model==dude2) {
							mouseAction(dude,platformToBuilding,null);
						}
					},
					end: function(object:HotObject,dude:Dude):void {
						dude = setDude("dude2",dude.id);
						object.setLabel("STILL",false);
					}
				},
				"platformToBuilding": {
					action : function(object:HotObject,dude:Dude):void {
						if(dude.model==dude2) {
							mouseAction(dude,dude1,null);
						}
					}
				}
			}
		}
		
		override protected function get music():Class {
			return OutsideSong;
		}
	}
	
}
