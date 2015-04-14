package  {
	
	import flash.display.MovieClip;
	
	
	public class IntroLevel extends Game {
		
		
		public function IntroLevel() {
			scripts = {
				scene: {
					nonStop:true,
					noNeedRemote:true,
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude,{speed:2});
						mouseAction(dude,dude1,null);
					},
					hotspots: [
						"cheat",
						"balancecheat"
					]
				},
				"dude1" : {
					hotspots: [
						"switch1",
						"door1"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"balancecheat": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("Giant",false);
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
						gotoScene("Daves",false);
					}
				}
			}
		}
	}
	
}
