package  {
	
	import flash.display.MovieClip;
	
	
	public class PrecipiceScene extends Game {
		
		
		public function PrecipiceScene() {
			scripts = {
				scene: {
					initialize : function():void {
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						
						mouseAction(dude,dude1,null);
					}
				},
				"dude1" : {
					hotspots: [
						"exitToCrossing",
						"rightprecipice",
						"leftprecipice",
						"skully"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					}
				},
				"exitToCrossing": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						gotoScene("Crossing",dude,false,false);
					}
				},
				"leftprecipice": {
					failaction: function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="STILL") {
							dude.visible = false;
							object.setLabel("CROSS");
						}
					},
					end: function(object:HotObject,dude:Dude):void {
						trace("HERE");
						object.activator = dude;
						object.setLabel("BRIDGE",false);
						dude = setDude("dudeinvis",dude.id);
						dude.alpha = 0;
					}
				},				
				"rightprecipice": {
					failaction: function(object:HotObject,dude:Dude):void {
						if(object.currentLabel=="STILL") {
							dude.visible = false;
							object.setLabel("CROSS");
						}
					},
					end: function(object:HotObject,dude:Dude):void {
						object.activator = dude;
						object.setLabel("BRIDGE",false);
						dude = setDude("dudeinvis",dude.id);
						dude.alpha = 0;
					}
				},
				"precipiceGap": {
					inactive : function(dude:Dude):Boolean {
						return leftprecipice.currentLabel=="BRIDGE"||rightprecipice.currentLabel=="BRIDGE";
					}
				},
				"dudeinvis": {
					preVanish: function(dude:Dude):void {
						if(leftprecipice.currentLabel=="BRIDGE") {
							leftprecipice.setLabel("TIMEREMOTE",true,
								function(object:HotObject):void {
									object.activator = null;
									rightprecipice.setLabel("FLASH",true,
										function():void {
											object.setLabel("STILL",false);
										});
									leftprecipice.setLabel("FLASH",true,
										function():void {
											object.setLabel("STILL",false);
										});
								});
						}
						if(rightprecipice.currentLabel=="BRIDGE") {
							rightprecipice.setLabel("TIMEREMOTE",true,
								function(object:HotObject):void {
									object.activator = null;
									rightprecipice.setLabel("FLASH",true,
										function():void {
											object.setLabel("STILL",false);
										});
									leftprecipice.setLabel("FLASH",true,
										function():void {
											object.setLabel("STILL",false);
										});
								});
						}
					}
				}
			};
		}
	}
	
}
