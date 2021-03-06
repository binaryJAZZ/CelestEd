CelestEd
========

A level editor for "Dame Celeste." The following is a guide for using the level editor. You can read it in order
as a sort of tutorial, or use the table of contents to skip to a section interest.

Table of Contents 
-----------------
- [Loading Tilesheets](#tilesheets)
- [Building a map with tiles](#tiles)
- [Navigation and Zooming](#navigation)
- [See the collision map and other options](#options)
- [Importing and Exporting](#saving)
- [Adding Rooms](#rooms)
- [Setting the Player's starting location](#player)
- [Adding enemies](#enemies)
- [Defining enemy paths with waypoints](#waypoints)

### Tilesheets ###
A tilesheet is just an image (either png, jpg, or gif) containing a set of YxY smaller images, or tiles 
(where Y represents the pixel dimension of tile). Your CelestEd source folder should have a sub-folder
named "tilesheets." Within that folder there will be sub-folders following the naming pattern "tilesheets_Y."
I believe the project currently has folders where "Y" is 8, 16, 17, and 32. 

If you have a tilesheet of 16x16 tiles all you have to do is drop it in the appropriately numbered folder and the editor will
load it automatically when it starts. If you need a tile size that isn't currently available, for example
64x64, simply add a new sub-folder, like "tilesheets_64" and then put your tilesheet in that folder.

>NOTE: When creating tilesheets, make sure there is NO space between adjacent tiles!

### Tiles ###
#### Intro ####
Once you have your tilesheets ready, go ahead and run CelestEd. You should see a white grid on a blue
background, a few buttons on the left side of the screen, and a dark blue bar at the bottom of the screen.

When CelestEd starts, the current "tool" is TILES, which means you can place tiles on the map. There should
be a button that says "Switch tool (TILES);" you can click that whenever you want to move to another tool.
The tools are:

* TILES: place tiles on any layer (floor, foreground, wall)
* ROOMS: create rooms and change camera focus position
* PLAYER: pick the player's starting location
* ENEMY: add enemies and define their paths

#### Selecting Tiles ####
For now, stick with "TILES." The blue bar at the bottom of the screen is the "tile drawer."
This is where you can navigate between different tilesheets, and select tiles to place on the map.
To cycle between sheets press the "< Prev Sheet" and "Next Sheet >" buttons in the drawer. The
name of the current tilesheet will appear in the top left corner of the drawer. If you get to the
right tilesheet, but don't see the tile you want, use "< Prev Page" and "Next Page >" to navigate
*within* a tilesheet.

Once you've found the tile you want, click on it in the drawer. A white border should show you've
selected it. The selected tile will also appear in the top right corner of the editor.

#### Placing and Deleting Tiles ####
Move your mouse onto the white grid. A transparent square cursor should show which grid space you're
mouse is hovering over. The color of the cursor helps indicate what layer you're placing the tile on:
white is a non-colliding layer (floor or foreground), and black is a collding layer (wall). 

>NOTE: In the top left corner you can see the coordinates "(X, Y)" of the grid square you're cursor is in.

Click on an empty square in the grid to place the currently selected tile there. To delete a tile, click
on it again. 

>NOTE: You can only delete a tile while using the TILES tool *and* while on the same layer. If you try
>to delete a tile on the floor layer while you're on the wall layer, you'll end up adding a wall tile
>instead!

>IMPORTANT: The following paragraph contains a *change* from the previous version.

To place several of the same type of tile at once, keep moving your mouse as you hold it down. Until
you release the mouse you will keep placing tiles. The same goes for deleting tiles.

#### Mass Editing of Tiles ####
To select a large mass of tiles simultaneously, right click (or ctrl-click on Macs) and drag. A transparent
white rectangle will show the selection area. You can un-select by right clicking somewhere else *without* dragging.

Once you have an area selected, you can press 'Q' to fill that area (on the current layer) with the tile type you
have selected in the tile drawer. If you press 'E' every tile in that area will be erased (if it's on the current layer).

#### Copy-and-Pasting ####
When you have an area of tiles selected, you can copy that area by pressing 'C'. Once an area has been copied,
you can paste it somewhere else by first selecting the target area, and then pressing 'V'. Note that the top
left corner of the copied group of tiles will correspond with the top left corner of the target area. You will
copy and paste from whichever layer you have currently selected.

>IMPORTANT: If you copy tiles from one tileset and switch to another before pasting, everything will get
>messed up. Sorry.

#### Switching Layers ###
While you're using the TILES tool, there will be a button under the "Switch tools" button that should 
say something like "Switch layer (FLOOR)." To cycle through the three different layers (FLOOR, FOREGROUND,
WALL), just keep clicking that button. The current layer is the one whose name is in parentheses.

### Navigation ###
To move around the map, use W-A-S-D as though they were the arrow keys, with W == up, S == down, 
and A & D == left & right. One key press will move you one tile in any direction.

You can also move *much faster* by holding down the SPACE bar and clicking and dragging across the entire screen.
This is obviously less accurate, but more convenient sometimes.

To change the zoom level, press "-" to zoom out and "+" to zoom in.

### Options ###
To reduce visual clutter, there are a set of option buttons that let you select what elements of the
current map are visible at any give time. The option menu starts hidden, but if you press the "Show Options"
button located on the left-hand side of the screen it will reveal the following options:

* Hide/Show Collision Map: overlays a collision map (white = non-collideable, black = collideable)
* Hide/Show Level Bounds: displays a gold rectangle that indicates the edges of the level
* Hide/Show Grid: turn the white grid-lines on and off
* Hide/Show Textures: make the tiles visible or invisible
* Hide/Show Rooms: Show the outlines of the room boundaries
* Hide/Show Tile Drawer: Open and close the tile drawer to give you more space on the grid to work
* Hide/Show Player Start: Make the square where the player starts visible (transparent white)
* Hide/Show Enemies: Show squares where each enemy starts (transparent black)
* Hide/Show Enemy Waypoints: Shows the path each enemy travels on

>NOTE: When you use the "Switch tools" buttons to go between tools, some of the options will be automatically toggled
>to try to match the work mode you are entering. You can always toggle them back by opening the option menu, however.

### Saving ###
#### Export To File ####
When you are done working on a level and want to use it the game, or you just want to save your progress, you can
save the current level as an ActionScript file by pressing the "Export To File" button. This will give you a dialog
box prompting you to select a location and name for your file. Any name will do, but the most appropriate format
is "MapName.as" since the file being exported is a full-fledged ActionScript file which can be added directly to the
project.

>NOTE: Whatever name you put before the ".as" in the filename (in this example "MapName") will become the class name
>of your new map, which inherits from TopDownLevel.

>BUG NOTE: As of now, you can't save a map that doesn't have a tile from *ALL THREE* layers (FLOOR, FOREGROUND, WALL).
>Also, it is not advisable to create a map that has NO rooms, though it won't crash the program.

#### Import From File ####
Now that you've saved a file, you may want to re-open it at a later date in order to edit it. To do that, press the "Import
From File" button, located under the "Export" button. Then navigate to the file you want to open, and, if the file format
is still correct, it should load your level automatically.

### Rooms ###
To switch to the ROOMS tool, press the "Switch tools" button until you arrive at "Switch tools (ROOMS)." Your cursor
should now look like a white circle.

#### Creating Rooms ####
To make a new room click anywhere on the screen where there is no button or pre-existing room in the way. Wherever
you click will make one corner of the room. Drag your mouse to expand the room and set the position of the opposite
corner. You should see a gold rectangle with gold circles at each corner. Let go of your mouse to finish creating the
room. 

#### Editing Rooms ####
When you move your mouse away from the room, the rectangle should turn black and the circles will dissapear -
this means you are not hovering over that room. When you have multiple rooms, they will all appear as black rectangles.
If you move our mouse back over a room, it will turn gold again and the circles will reappear. These are handles: click
and drag any of the gold circles to change the position of that corner of the room.

#### Neighbors ####
When you hover over a room, some other rooms may turn from black to white. Those rooms are the neighbors of the room
you are hovering over. Any room that overlaps with another room will automatically become its neighbor.

#### Moving the Camera ####
When you hover over a room, you will notice a gold circle with a smaller circle inside of it that appears in the center
of the rectangle. This circle represents the position the camera will move to when the player enters that room. Click
and drag it to move it. If you resize your room, the camera position will adjust to relative to the size and position
of the room.

#### Deleting Rooms ####
To delete a room, grab one of its corners and pull it over to its opposite corner. When a room is squeezed so that 
all of its corners are touching, the room will turn red. If you let go of your mouse then, the room will be deleted.

### Player ###
To switch to the PLAYER tool, press the "Switch tools" button until it reads "Switch tools (PLAYER)." This tool lets
you decide where the player's starting position should be. Click on any grid space and the player's starting position
will move there: you should see a white square and, above it, the word player.

>NOTE: You cannot delete the player. By default, the player will start at grid coordinates (0,0).

### Enemies ###
To switch to the ENEMY tool, press the "Switch tools" button until it reads "Switch tools (ENEMY)." This tool lets
you place and delete enemies, as well as add waypoints for the enemies to follow.

To add an enemy click on any grid square that does not alread contain an enemy. A gold square with the word "Enemy"
above it should appear. The enemy you currently have selected is always a gold square. Once you add more than one
enemy, unselected enemies are represented by black squares.

To select an enemy, click on it. It should turn gold.

To delete an enemy, select it, and then click on it again. It should dissapear.

### Waypoints ###
When using the ENEMY tool, a button labeled "Switch mode" should appear beneath the "Switch tools" button.
It starts out as "Switch mode (ENEMY)," which means you're in the enemy placement mode, but press it again
and it will toggle to "Switch mode (WAYPOINT)," which lets you place waypoints.

Once you're in WAYPOINT mode and you have an enemy selected, you can add new waypoints by clicking into any
grid square that is currently unoccupied by a waypoint. The new waypoint will be represented by a circle,
and a line connecting it to other waypoints belonging to the selected enemy, and a number which tells you
which what order the enemy will visit the waypoints. The waypoint path of a selected enemy will be gold,
all others will be black.

To delete a waypoint, click on it while using the ENEMY tool, with the desired enemy selected, in WAYPOINT mode.

>NOTE: You currently can't select enemies in WAYPOINT mode. To switch which enemy's waypont path you're editing, you
>have to go back to ENEMY mode, select the enemy, and then return to WAYPOINT mode.

To see all enemies' fields of view (FOVs) as they walk along their waypoint paths, go under the options menu
and press the "Show enemy FOVs" button. Press it again (when it reads "Hide enemy FOVs") to make the FOVs
dissapear. FOVs will also be invisible if enemies are invisible.
