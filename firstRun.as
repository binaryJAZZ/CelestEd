/**
 * Initialization code: new firstRun(new FlxPoint(288, 320),new FlxPoint(16, 16));
 * tilesize: 16
 */
package
{
	import org.flixel.*;
	public class firstRun extends TopDownLevel
	{
		/** 
		 * FLOORS layer 
		 * tilesheet: floor_wood_opengameart 
		 */ 
		protected static var FLOORS:Array = new Array( 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0
		); 

		/** 
		 * WALLS layer 
		 * tilesheet: walls_opengameart 
		 */ 
		protected static var WALLS:Array = new Array( 
			1, 2, 2, 2, 2, 2, 2, 2, 2, 
			1, 0, 0, 0, 0, 0, 0, 0, 0, 
			1, 0, 0, 0, 0, 0, 0, 0, 0, 
			1, 0, 0, 0, 0, 0, 0, 0, 0, 
			1, 0, 0, 0, 0, 0, 0, 0, 0, 
			1, 0, 0, 0, 0, 0, 0, 0, 0, 
			1, 0, 0, 0, 0, 0, 0, 0, 0, 
			1, 0, 0, 0, 0, 0, 0, 0, 0, 
			1, 0, 0, 0, 0, 0, 0, 0, 0, 
			1, 0, 0, 0, 0, 0, 0, 0, 0
		); 

		/** 
		 * FOREGROUND layer 
		 * tilesheet: walls_opengameart 
		 */ 
		protected static var FOREGROUND:Array = new Array( 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 9, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0
		); 

		protected var decalGroup:FlxGroup;
		protected var objectGroup:FlxGroup;

		private var darkness:FlxSprite;
		private var playerLight:Light;

		private var enemyController:EnemyController;

		public function firstRun(levelSize:FlxPoint, blockSize:FlxPoint):void {
			super(levelSize, blockSize, new FlxPoint(8.0,8.0));
		}

		override protected function createMap():void {
			var tiles:FlxTilemap;

			tiles = new FlxTilemap();
			tiles.loadMap(
				FlxTilemap.arrayToCSV(FLOORS, 9),
				Assets.FLOORS_TILE, tileSize.x, tileSize.y, 0, 0, 0, uint.MAX_VALUE
			);
			floorGroup.add(tiles);

			tiles = new FlxTilemap();
			tiles.loadMap(
				FlxTilemap.arrayToCSV(WALLS, 9),
				Assets.WALLS_TILE, tileSize.x, tileSize.y
			);
			wallGroup.add(tiles);

			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			playerLight = new Light(Assets.LightImageClass, FlxG.width / 2, FlxG.height / 2, darkness);

			//room data

			currRoom = room0; //replace with room of your choice
			focusOnCurrRoom();

			createObjects();
		}

		protected function createObjects():void {
			var sprite:FlxSprite;
			decalGroup = new FlxGroup();
			objectGroup = new FlxGroup();
		}

		override protected function createPlayer():void {
			player = new Player(playerStart.x, playerStart.y);
		}

		override protected function createGUI():void {
		}

		override protected function addGroups(): void {
			add(floorGroup);
			add(wallGroup);
			add(decalGroup);
			add(objectGroup);
			add(player);
			add(player.mySprite);

			var enemies:Vector.<Enemy> = new Vector.<Enemy>();
			var light5:Light = new Light(Assets.LightImageClass, FlxG.width*3/ 4, FlxG.height/ 4, darkness, 0xFFFFFFFF);
			add(light5);

			enemyController = new EnemyController(enemies);
			add(enemyController);

			add(playerLight);
			add(darkness);
			add(guiGroup);
		}

		override public function draw():void {
			darkness.fill(0xff000000);
			super.draw();
		}

		override public function transferLevel(): TopDownLevel{
			return null;
		}

		override public function update():void {
			super.update();
		}

		override public function normalGameplay():void {
			super.normalGameplay();
			playerLight.x = (player.x+player.width/2);
			playerLight.y = (player.y-player.height/2);
			FlxG.collide(objectGroup, player);

			var enemyMessage:int = enemyController.commandEnemies();
		}
	}
}