/**
 * Initialization code: new __SAVEPOINT__TEST6__(new FlxPoint(448, 352),new FlxPoint(16, 16));
 * tilesize: 16
 */
package
{
	import org.flixel.*;
	public class __SAVEPOINT__TEST6__ extends TopDownLevel
	{
		/** 
		 * FLOORS layer 
		 * tilesheet: celesteFloorTilesheetFin 
		 */ 
		protected static var FLOORS:Array = new Array( 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
		); 

		/** 
		 * WALLS layer 
		 * tilesheet: celesteFloorTilesheetFin 
		 */ 
		protected static var WALLS:Array = new Array( 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
		); 

		/** 
		 * FOREGROUND layer 
		 * tilesheet: celesteFloorTilesheetFin 
		 */ 
		protected static var FOREGROUND:Array = new Array( 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		); 

		protected var decalGroup:FlxGroup;
		public function __SAVEPOINT__TEST6__(levelSize:FlxPoint, blockSize:FlxPoint):void {
			super(levelSize, blockSize, new FlxPoint(168.0,88.0));
			legOutfit = new PlayerOutfit(72*7,55*16,Assets.RANGER2_PANTS,PlayerOutfit.LEGS_OUTFIT,Assets.RANGER2LEGS_SPRITE, OutfitHandler.GUARD_OUTFIT);
			add(legOutfit);
			bodyOutfit = new PlayerOutfit(42*16,49*16,Assets.RANGER2_SHIRT,PlayerOutfit.BODY_OUTFIT,Assets.RANGER2BODY_SPRITE, OutfitHandler.GUARD_OUTFIT);
			add(bodyOutfit);
			headOutfit = new PlayerOutfit(72*16,55*16,Assets.RANGER2_HAT,PlayerOutfit.HEAD_OUTFIT,Assets.RANGER2HEAD_SPRITE, OutfitHandler.GUARD_OUTFIT);
			add(headOutfit);
			setLevelName("Dungeon");
			var dungeonMusic: FlxSound = new FlxSound;
			dungeonMusic.loadEmbedded(Assets.DUNGEON_SONG,true);
			FlxG.music = (dungeonMusic);
			FlxG.music.volume = 0.6;
			FlxG.music.play();
			//SAFEZONE
			//SAFEZONE
		}

		//SAFEZONE2
		//SAFEZONE2

		override protected function addHideableObjects():void {
			super.addHideableObjects();
		}

		override protected function savePointCreation():void{
			super.savePointCreation();
			savePoints.push(new SavePoint(48.0, 48.0));
			savePoints.push(new SavePoint(80.0, 64.5));
			savePoints.push(new SavePoint(128.5, 97.5));
		}

		override protected function createMap():void {
			var tiles:FlxTilemap;

			tiles = new FlxTilemap();
			tiles.loadMap(
				FlxTilemap.arrayToCSV(FLOORS, 14),
				Assets.celesteFloorTilesheetFin, tileSize.x, tileSize.y, 0, 0, 0, uint.MAX_VALUE
			);
			floorGroup.add(tiles);

			tiles = new FlxTilemap();
			tiles.loadMap(
				FlxTilemap.arrayToCSV(WALLS, 14),
				Assets.celesteFloorTilesheetFin, tileSize.x, tileSize.y
			);
			wallGroup.add(tiles);

			tiles = new FlxTilemap();
			tiles.loadMap(
				FlxTilemap.arrayToCSV(FOREGROUND, 14),
				Assets.celesteFloorTilesheetFin, tileSize.x, tileSize.y
			);
			foreGroundGroup.add(tiles);
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			playerLight = new Light(Assets.LightImageClass, FlxG.width / 2, FlxG.height / 2, darkness);
			createObjects();
		}

		protected function createObjects():void {
			var sprite:FlxSprite;
			decalGroup = new FlxGroup();
			objectGroup = new FlxGroup();

			sprite = new FlxSprite(64.5,137.5,Assets.Cauldron);
			sprite.immovable=true;
			objectGroup.add(sprite);

			sprite = new FlxSprite(104.5,128.0,Assets.plant3);
			sprite.immovable=true;
			objectGroup.add(sprite);

			sprite = new FlxSprite(98.5,66.5,Assets.wallTorch2);
			sprite.immovable=true;
			objectGroup.add(sprite);

		}

		override protected function createPlayer():void {
			player = new Player(playerStart.x, playerStart.y);
		}

		override protected function createGUI():void {
			super.createGUI();
		}

		override protected function createWaterDroplets():void {
			var waterDrop:FlxSprite;
			waterDrops = new Vector.<FlxSprite>();

			waterDrop = new FlxSprite(168.0, 152.0, Assets.WATER_DROP);
			waterDrops.push(waterDrop);

			waterDrop = new FlxSprite(200.0, 152.0, Assets.WATER_DROP);
			waterDrops.push(waterDrop);

		}

		override protected function addEnemies(): void {

			var enemies:Vector.<Enemy> = new Vector.<Enemy>();
			var enemyLight:Light;
			var enemyLight2:Light;
			var waypointList3: Vector.<FlxPoint> = new Vector.<FlxPoint>(); 

			waypointList3.push(new FlxPoint(24.0,152.0)); 
			waypointList3.push(new FlxPoint(56.0,152.0)); 
			waypointList3.push(new FlxPoint(104.0,152.0)); 

			enemyLight = new Light(Assets.LightImageClass, FlxG.width*3/ 4, FlxG.height/ 4, darkness, 0xFFFFFFFF); add(enemyLight); enemyLight.scale=new FlxPoint(0.75,0.75);

			var enemy3:Enemy = new Enemy(Assets.GUARD_SPRITE, waypointList3, player, enemyLight, 16.0, 144.0); 
			enemies.push(enemy3); 

			enemyController = new EnemyController(enemies);
		}

		override protected function addGroups(): void {
			add(floorGroup);
			add(wallGroup);
			var i: int;
			if(hideableObjects!=null)
			{
				for(i =0; i<hideableObjects.length; i++)
				{
					add(hideableObjects[i]);
				}
			}
			if(savePoints!=null)			{
				for(i =0; i<savePoints.length; i++)
				{
					add(savePoints[i]);
				}
			}
			add(objectGroup);
			add(decalGroup);
			if(waterDrops!=null)			{
				for(i = 0; i<waterDrops.length; i++)
				{
					add(waterDrops[i]);
				}
			}
			add(player);
			player.addSprites(this);
			add(enemyController);
			add(foreGroundGroup);
			enemyController.addGUIBits(this);
			add(playerLight);
			add(darkness);
			add(guiGroup);
			//absolutely necessary for some reason
			debugText = new FlxText(FlxG.camera.scroll.x,FlxG.camera.scroll.y,100);
			debugText.text = "Debug: ";
		}

		override public function draw():void {
			darkness.fill(0xff888888);
			super.draw();
		}

		override public function transferLevel(): TopDownLevel{
			if(super.reloadThisLevel)
			{
				return new __SAVEPOINT__TEST6__(new FlxPoint(448, 352),new FlxPoint(16, 16));
			}
			else
			{
				return null;
			}
		}

		override public function update():void {
			super.update();
		}

		override public function normalGameplay():void {
			super.normalGameplay();
			FlxG.collide(objectGroup, player);
		}
	}
}