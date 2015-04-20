package {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.events.Event;


	public class HexScene extends Game {

		/*
			   N(orth)
			   L
			  J|K
			 G|H|I
			  E|F
		      |D|
			  B|C
			   A
			   S(outh)
		*/

		static const Pylon2Pylon: Object = {
			"0": {
				"A": "JUMPNORTH"
			},
			"S": {
				"A": "JUMPNORTH"
			},
			"N": {
				"L": "JUMPSOUTH"
			},
			"L": {
				"J": "JUMPSOUTHLEFT",
				"H": "JUMPSOUTH",
				"K": "JUMPSOUTHRIGHT",
				"N": "JUMPNORTH"
			},
			"K": {
				"L": "JUMPNORTHLEFT",
				"H": "JUMPSOUTHLEFT",
				"F": "JUMPSOUTH",
				"I": "JUMPSOUTHRIGHT"
			},
			"I": {
				"K": "JUMPNORTHLEFT",
				"F": "JUMPSOUTHLEFT"
			},
			"J": {
				"L": "JUMPNORTHRIGHT",
				"G": "JUMPSOUTHLEFT",
				"H": "JUMPSOUTHRIGHT",
				"E": "JUMPSOUTH"
			},
			"H": {
				"J": "JUMPNORTHLEFT",
				"L": "JUMPNORTH",
				"K": "JUMPNORTHRIGHT",
				"E": "JUMPSOUTHLEFT",
				"D": "JUMPSOUTH",
				"F": "JUMPSOUTHRIGHT"
			},
			"G": {
				"J": "JUMPNORTHRIGHT",
				"E": "JUMPSOUTHRIGHT"
			},
			"F": {
				"H": "JUMPNORTHLEFT",
				"K": "JUMPNORTH",
				"I": "JUMPNORTHRIGHT",
				"D": "JUMPSOUTHLEFT",
				"C": "JUMPSOUTH"
			},
			"E": {
				"G": "JUMPNORTHLEFT",
				"J": "JUMPNORTH",
				"H": "JUMPNORTHRIGHT",
				"D": "JUMPSOUTHRIGHT",
				"B": "JUMPSOUTH"
			},
			"D": {
				"B": "JUMPSOUTHLEFT",
				"C": "JUMPSOUTHRIGHT",
				"E": "JUMPNORTHLEFT",
				"F": "JUMPNORTHRIGHT",
				"A": "JUMPSOUTH",
				"H": "JUMPNORTH"
			},
			"C": {
				"A": "JUMPSOUTHLEFT",
				"D": "JUMPNORTHLEFT",
				"F": "JUMPNORTH"
			},
			"B": {
				"A": "JUMPSOUTHRIGHT",
				"D": "JUMPNORTHRIGHT",
				"E": "JUMPNORTH"
			},
			"A": {
				"B": "JUMPNORTHLEFT",
				"C": "JUMPNORTHRIGHT",
				"D": "JUMPNORTH",
				"S": "JUMPSOUTH"
			}
		};

		public function HexScene() {

			//	initial script
			scripts = {
				scene: {
					initialize: function (): void {
						var dude: Dude = setDude("dude0", persisted_id);
						born(dude);

						PylonC.setLabel("DOWN", false);
						PylonH.setLabel("DOWN", false);
						PylonG.setLabel("DOWN", false);
						if (solvedLevel) {
							autel.setLabel("EMPTY", false);
							rightlion.setLabel("EMPTY", false);
							leftlion.setLabel("EMPTY", false);
						}
					},
					hotspots: [
						"cheat"
					],
					born: function (dude: Dude): void {
						mouseAction(dude, dudeS, null);
					}
				},
				"cheat": {
					action: function (object: HotObject, dude: Dude): void {
						autel.setLabel("RAISE");

					}
				},
				"dudeS": {
					hotspots: [
						"exitToCrossing"
					],
					action: function (object: HotObject, dude: Dude): void {
						dude = setDude("dudeS", dude.id);
					}
				},
				"dudeN": {
					hotspots: [
						"leftlion",
						"rightlion",
						"autel"
					]
				},
				"leftlion": {
					action: function (object: HotObject, dude: Dude): void {
						if (object.currentLabel == "STILL") {
							dude.visible = false;
							object.setLabel("PICKUP");
						}
					},
					end: function (object: Lion, dude: Dude): void {
						object.setLabel("STUCK", false);
						object.caught = dude;
						if (autel.currentLabel == "STILL") {
							autel.setLabel("OPEN");
						} else if (autel.currentLabel == "OPEN" || autel.currentLabel == "FALLDOWN") {
							autel.setLabel("RAISE");
						}
					},
					combo: {
						"timeRemote": {
							action: function (object: Lion, dude: Dude): void {
								if (object.currentLabel == "STUCK" && dude == object.caught) {
									dude.useItem("timeRemote");
									object.setLabel("TIMEREMOTE");
								}
							},
							end: function(object: Lion, dude: Dude):void {
								object.setLabel("EMPTY",false);
							}
						}
					}
				},
				"rightlion": {
					action: function (object: HotObject, dude: Dude): void {
						if (object.currentLabel == "STILL") {
							dude.visible = false;
							object.setLabel("PICKUP");
						}
					},
					end: function (object: Lion, dude: Dude): void {
						object.setLabel("STUCK", false);
						object.caught = dude;
						if (autel.currentLabel == "STILL") {
							autel.setLabel("OPEN");
						} else if (autel.currentLabel == "OPEN" || autel.currentLabel == "FALLDOWN") {
							autel.setLabel("RAISE");
						}
					},
					combo: {
						"timeRemote": {
							action: function (object: Lion, dude: Dude): void {
								if (object.currentLabel == "STUCK" && dude == object.caught) {
									dude.useItem("timeRemote");
									object.setLabel("TIMEREMOTE");
								}
							}
						}
					}
				},
				"autel": {
					action: function (object: HotObject, dude: Dude): void {
						if (object.currentLabel == "RAISE") {
							dude.visible = false;
							object.setLabel("PICKUP");
						} else if (object.currentLabel == "OPEN") {
							dude.visible = false;
							dude.doomed = true;
							object.setLabel("FALLDOWN");
						}
					},
					end: function (object: HotObject, dude: Dude): void {
						if (object.currentLabel == "FALLDOWN") {
							gameOver(dude);
						} else if (object.currentLabel == "PICKUP") {
							object.setLabel("EMPTY", false);
							dude.visible = true;
							dude.hero.pickupItem("idol");
						}
					}
				},
				"exitToCrossing": {
					action: function (object: HotObject, dude: Dude): void {
						dude.visible = false;
						gotoScene("Crossing", dude, dude.hero.hasItem("idol"), false);
					}
				}
			};

			//	Main pylon script
			var pylonScript: Object = {
				action: pylonAction
			};

			//	Manufacture scripts
			for (var letter: String in Pylon2Pylon) {

				var pylonDestinations: Object = Pylon2Pylon[letter];

				//	setup dudes Script
				var dudeScript: Object = scripts["dude" + letter];
				if (!dudeScript) {
					dudeScript = scripts["dude" + letter] = {
						hotspots: []
					};
				}
				for (var d: String in pylonDestinations) {
					if (d.length == 1)
						dudeScript.hotspots.push("Pylon" + d);
				}

				if (!scripts["Pylon" + letter]) {
					scripts["Pylon" + letter] = pylonScript;
				}

			}

		}

		private function pylonAction(object: HotObject, dude: Dude): void {
			if (dude.currentLabel == "STAND") {
				var fromLetter: String = dude.model.name.split("dude")[1];
				var toLetter: String = object.model.name.split("Pylon")[1];
				processMovement(dude, fromLetter, toLetter);
			}
		}

		private function processMovement(dude: Dude, fromLetter: String, toLetter: String): void {

			if (dude == mainCharacter) {
				if (toLetter == "N" && MovieClip(root).currentLabel != "APPROACH") {
					MovieClip(root).gotoAndPlay("APPROACH");
				} else if (toLetter == "L" && MovieClip(root).currentLabel == "APPROACH") {
					MovieClip(root).gotoAndPlay("RECUL");
				}
			}


			var animationLabel: String = Pylon2Pylon[fromLetter][toLetter];
			if (!animationLabel) {
				return;
			}
			var preDirection: Number = dude.scaleX;
			dude.setDirection(-1);

			dude.setLabel(animationLabel, true,
				function (dude: Dude): void {
//					trace(dude.id, ">>", toLetter);
					dude = setDude("dude" + toLetter, dude.id);
					if (animationLabel.indexOf("LEFT") >= 0) {
						dude.setDirection(-1);
					} else if (animationLabel.indexOf("RIGHT") >= 0) {
						dude.setDirection(1);
					} else {
						dude.setDirection(preDirection);
					}
					dude.setLabel("STAND", false);
					var landedPylon: Pylon = getChildByName("Pylon" + toLetter) as Pylon;
					if (landedPylon.currentLabel != "STILL" && landedPylon.currentLabel != "GOUP") {
						trace("vvvv", dude.model.name, dude.id,"<<<<",landedPylon.currentLabel);
//						setChildIndex(dude, getChildIndex(landedPylon));
						freeFall(dude);
						return;
					}
				});
			dude.addEventListener("landed",
				function (e: Event): void {
					var destinations: Object = Pylon2Pylon[toLetter];
					if (toLetter != 'S' && toLetter != 'N') {
						var landedPylon:Pylon = getChildByName("Pylon" + toLetter) as Pylon;
						if(landedPylon.currentLabel!="STILL" && landedPylon.currentLabel!="GOUP") {
							return;
						}
						for (var d: String in destinations) {
							var dest: String = d;
							var pylon: Pylon = getChildByName("Pylon" + d) as Pylon;
							if (pylon.hasLabel("GODOWN")) {
								var label: String = pylon.currentLabel == "STILL" ? "GODOWN" : "GOUP";
								pylon.setLabel(label, true,
									function (pylon: Pylon): void {
										pylon.setLabel(pylon.currentLabel == "GODOWN" ? "DOWN" : "STILL", false);
										if (pylon.currentLabel == "DOWN") {
											var dest: String = pylon.model.name.split("Pylon")[1];

											for (var i: int = 0; i < numChildren; i++) {
												var dude: Dude = getChildAt(i) as Dude;
												//trace(dude ? dude.id : null, dude ? dude.model.name : null, "dude" + dest);
												if (dude && dude.visible && dude.model.name == "dude" + dest) {
													//setChildIndex(dude, getChildIndex(pylon));
													freeFall(dude);
													trace("vvvv", dude.model.name, dude.id);
												}
											}
										}

									});
							}
						}
					}
				});
			dude.addEventListener(Event.ENTER_FRAME,
				function (e: Event): void {
					var dude:Dude = e.currentTarget as Dude;
					var org: DisplayObject = getChildByName("dude" + fromLetter);
					var dest: DisplayObject = getChildByName("dude" + toLetter);
					var progress: Number = dude.percentInTheAir;
					if (progress) {
						dude.x = dest.x * progress + org.x * (1 - progress);
					}
					if (dude.currentLabel != animationLabel) {
						e.currentTarget.removeEventListener(e.type, arguments.callee);
					}
				});
		}
	}

}