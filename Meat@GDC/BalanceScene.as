package  {
	
	import flash.display.MovieClip;
	
	
	public class BalanceScene extends Game {
		
		
		public function BalanceScene() {
			scripts = {
				scene: {
					noFadein:true,
					initialize : function():void {
						topplate.attach(balance.topplate);
						bottomplate.attach(balance.bottomplate);
						balance.setBalancePlate(topplate,bottomplate);
						
						var dude:Dude = setDude("dude0",persisted_id);
						born(dude);
						rock.visible = !dude.hero.hasItem("rock");
						if(Game.lastLevel=="Alley") {
							dude = setDude("dudeleft",dude.id);
							dude.setMover(topplate as IMover);
							dude.visible = false;
							topplate.activator = dude;
							topplate.setLabel("LAND",true,
								function():void {
									topplate.setLabel("STILL",false);
									dude.visible = true;
								});
						}
						else {
							mouseAction(dude,dude1,null);
						}						
					},
					hotspots: [
						"cheat",
						"rock"
					]
				},
				"dude1" : {
					hotspots: [
						"exitToCrossing",
						"topplate",
						"bottomplate"
					],
					action : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
					},
					preDestroy: function(dude:Dude):void {
						if(dude.hero.hasItem("rock")) {
							rock.visible = true;
							rock.setPosition(dude);
							setChildIndex(rock,getChildIndex(dude));
							rock.setLabel("DROP",true,
								function():void {
									rock.setLabel("STILL",false);
									resetHotspots();
								});
						}
					}
				},
				"ledge": {
					action: function(object:HotObject,dude:Dude):void {
						if(balance.pos>.85 || balance.pos<.1) {
							dude.setDirection(1);
							dude.setLabel("LOOKUP",true,
								function():void {
									dude.setLabel("STAND",false);
									unblock(dude);
								});
						}
						else {
							dude.setMover(null);
							dude.visible = false;
							object.setLabel(dude.model.name=="duderight"?"JUMPON":"STEPON");
						}
					},
					end : function(object:HotObject,dude:Dude):void {
						dude = setDude("dude1",dude.id);
						dude.setPosition(object);
						object.setLabel("STILL",false);
					}
				},
				"duderight": {
					cantWalk : function(dude:Dude):Boolean {
						return true;
					},
					hotspots: [
						"ledge"
					],
					preDestroy: function(dude:Dude):void {
						if(dude.hero.hasItem("rock")) {
							rock.visible = true;
							rock.setPosition(dude);
							var scaleRatio:Number = Math.abs(dude.scaleX / dude1.scaleX);
							rock.scaleX = rock.scaleY = rock.scaleX*scaleRatio;
							setChildIndex(rock,getChildIndex(dude));
							rock.setLabel("DROP",true,
								function():void {
									rock.setMover(bottomplate);
									rock.setLabel("STILL",false);
									balance.affectMomentum(-.1);
									resetHotspots();
								});
						}
					}
				},
				"dudeleft": {
					cantWalk : function(dude:Dude):Boolean {
						return true;
					},
					hotspots: [
						"ledge",
						"trou"
					],
					preDestroy: function(dude:Dude):void {
						if(dude.hero.hasItem("rock")) {
							rock.visible = true;
							rock.setPosition(dude);
							var scaleRatio:Number = Math.abs(dude.scaleX / dude1.scaleX);
							rock.scaleX = rock.scaleY = rock.scaleX*scaleRatio;
							setChildIndex(rock,getChildIndex(dude));
							rock.setLabel("DROP",true,
								function():void {
									rock.setMover(topplate);
									rock.setLabel("STILL",false);
									balance.affectMomentum(.1);
									resetHotspots();
								});
						}
					}
				},
				"trou": {
					action: function(object:HotObject,dude:Dude):void {
						var dist:Number = dude.distanceTo(object);
						if(dist>100) {
							dude.setDirection(-1);
							dude.setLabel("LOOKUP",true,
								function():void {
									dude.setLabel("STAND",false);
									unblock(dude);
								});
						}
						else {
							dude.visible = false;
							object.setLabel("EXIT");
						}
					},
					end : function(object:HotObject,dude:Dude):void {
						if(dude==mainCharacter) {
							solveLevel();
							gotoScene("Alley");
						}
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
						dude.hero.pickupItem("rock");
					},
					cantAccess : function(object:HotObject,dude:Dude):Boolean {
						return (object as IMoveable).mover != dude.mover;
					}
				},
				"topplate": {
					action : function(object:HotObject,dude:Dude):void {
						trace(balance.pos);
						dude.visible = false;
						object.setLabel("JUMPIN");
					},
					end: function(object:HotObject,dude:Dude):void {
						dude = setDude("dudeleft",dude.id);
						dude.setMover(object as IMover);
						object.setLabel("STILL",false);
					},
					combo: {
						"rock": {
							action: function(object:HotObject,dude:Dude):void {
								block(dude);
								dude.setDirection(-1);
								dude.hero.dropItem("rock");
								dude.setLabel("THROWROCK",true,
									function(dude:Dude):void {
										unblock(dude);
										var anim:HotAnimation = new FlyingRock();
										addChildAt(anim,getChildIndex(dudeleft));
										anim.x = object.x;
										anim.y = object.y;
										anim.setLabel("FLY",true,
											function():void {
												removeChild(anim);
												rock.visible = true;
												rock.setPosition(dudeleft);
												setChildIndex(rock,getChildIndex(dudeleft));
												rock.setMover(topplate);
												rock.setLabel("STILL",false);
												balance.affectMomentum(.2);
											});
									});
							}
						}
					}
				},
				"bottomplate": {
					action : function(object:HotObject,dude:Dude):void {
						trace(balance.pos);
						dude.visible = false;
						object.setLabel("JUMPIN");
					},
					end: function(object:HotObject,dude:Dude):void {
						dude = setDude("duderight",dude.id);
						dude.setMover(object as IMover);
						dude.setDirection(1);
						object.setLabel("STILL",false);
					},
					combo: {
						"rock": {
							action: function(object:HotObject,dude:Dude):void {
								block(dude);
								dude.setDirection(1);
								dude.hero.dropItem("rock");
								dude.setLabel("THROWROCK",true,
									function(dude:Dude):void {
										unblock(dude);
										var anim:HotAnimation = new FlyingRock2();
										var scaleRatio:Number = Math.abs(duderight.scaleX / dude1.scaleX);
										anim.scaleX = anim.scaleY = anim.scaleX*scaleRatio;
										anim.setDirection(-1);
										
										addChildAt(anim,getChildIndex(duderight));
										anim.x = object.x;
										anim.y = object.y;
										anim.setLabel("FLY",true,
											function():void {
												removeChild(anim);
												rock.visible = true;
												rock.scaleX = rock.scaleY = rock.scaleX*scaleRatio;
												rock.setPosition(duderight);
												setChildIndex(rock,getChildIndex(duderight));
												rock.setMover(bottomplate);
												rock.setLabel("STILL",false);
												balance.affectMomentum(-.2);
											});
									});
							}
						}
					}
				},
				"exitToCrossing": {
					action: function(object:HotObject,dude:Dude):void {
						dude.visible = false;
						if(dude==mainCharacter)
							gotoScene("Crossing",false);
					}
				}
			};
		}
	}
	
}
