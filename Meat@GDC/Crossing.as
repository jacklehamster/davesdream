﻿package  {
	
	import flash.display.MovieClip;
	
	
	public class Crossing extends Game {
		
		function Crossing():void {
			scripts = {
				scene: {
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude,{lastLevel:previousLevel});
					},
					born: function(dude:Dude):void {
						if(dude.lastLevel=="Giant" || dude.lastLevel=="Precipice") {
							dude.setPosition(north);
						}
						else if(dude.lastLevel=="Balance") {
							dude.setPosition(west);
						}
						else if(dude.lastLevel=="Hex") {
							dude.setPosition(east);
						}
						
						mouseAction(dude,dude1,null);
					}
				},
				"dude1" : {
					hotspots: [
						"north",
						"west",
						"east",
						"exitToPyramid"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"exitToPyramid": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						gotoScene("ThePyramid",dude,false,true);
					}
				},
				"north" : {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("EXIT");
					},
					end : function(object:HotObject,dude:Dude):void {
						object.setLabel("STILL",false);
						gotoScene("Precipice",dude,false,false);
					}
				},
				"west" : {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("EXIT");
					},
					end : function(object:HotObject,dude:Dude):void {
						object.setLabel("STILL",false);
						gotoScene("Balance",dude,false,false);
					}
				},
				"east" : {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						object.setLabel("EXIT");
					},
					end : function(object:HotObject,dude:Dude):void {
						object.setLabel("STILL",false);
						gotoScene("Hex",dude,false,false);
					}
				}
			};
		}
		
		
	}
	
}
