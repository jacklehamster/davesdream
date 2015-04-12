package  {
	
	import flash.display.MovieClip;
	
	
	public class Crossing extends Game {
		
		function Crossing():void {
			scripts = {
				scene: {
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						if(lastLevel=="Giant") {
							dude.setPosition(north);
						}
						else if(lastLevel=="Balance") {
							dude.setPosition(west);
						}
						
						mouseAction(dude,dude1,null);
					}
				},
				"dude1" : {
					hotspots: [
						"north",
						"west",
						"exitToPyramid"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"exitToPyramid": {
					action: function(object:HotObject,dude:Dude):void {
						gotoScene("ThePyramid");
					}
				},
				"north" : {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("EXIT");
					},
					end : function(object:HotObject,dude:Dude):void {
						object.setLabel("STILL",false);
						gotoScene("Giant",false);
					}
				},
				"west" : {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("EXIT");
					},
					end : function(object:HotObject,dude:Dude):void {
						object.setLabel("STILL",false);
						gotoScene("Balance",false);
					}
				}
			};
		}
		
		
	}
	
}
