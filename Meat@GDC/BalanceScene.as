package  {
	
	import flash.display.MovieClip;
	
	
	public class BalanceScene extends Game {
		
		
		public function BalanceScene() {
			scripts = {
				scene: {
					noFadein:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						mouseAction(dude,dude1,null);

						rock.visible = !Hero.instance.hasItem("rock");
						topplate.attach(balance.topplate);
						bottomplate.attach(balance.bottomplate);
						balance.setBalance(topplate,bottomplate);
					},
					hotspots: [
						"cheat"
					]
				},
				"dude1" : {
					hotspots: [
						"rock",
						"exitToCrossing",
						"topplate",
						"bottomplate"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"rock": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("PICKUP");
					},
					end: function(object:HotObject,dude:Dude):void {
						dude.visible = true;
						object.visible = false;
						if(dude==mainCharacter) {
							Hero.instance.pickupItem("rock");
						}
					}					
				},
				"topplate": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("JUMPIN");
					},
					end: function(object:HotObject,dude:Dude):void {
//						dude.visible = true;
						
					}					
				},
				"bottomplate": {
					action : function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("JUMPIN");
					},
					end: function(object:HotObject,dude:Dude):void {
//						dude.visible = true;
					}					
				},
				"exitToCrossing": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Crossing",false);
					}
				}
			};
		}
	}
	
}
