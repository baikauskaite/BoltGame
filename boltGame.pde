/**
    
    "The Bolt Rush"

    The first object-oriented programming project.
    The sprite is moved around by arrow keys.
    The objective of the game is to reach the "Bolt" truck.

    @author  Viktorija Baikauskaitė, 4 gr.
    
*/

// Maps
Map baseMapSky;
Map baseMapBuildings1;
Map baseMapBuildings2;
Map baseMapGround;
Map worldLevel1;
Map worldLevel2;
Map worldLevel3;

// Buttons
int currentTileId;
Object tilemapTiles[];
int tilemapTilesNumber;
Object editedMapTiles[];
Object playButton;
Object editMapButton;
Object quitButton;
Object levelButton;
Object levelButtonLeft;
Object levelButtonRight;
Object editedMapButtonRight;
Object editedMapButtonLeft;
Object eraserButton;
Object backToMenuButton;
Object saveButton;
Object backToMenuFromPlayButton;
Object statusLives;
Object statusLivesNumber;
Object statusPoints;
Object statusPointsNumber;

// Player
Player corgi;
// Corgi player images
PImage walkingImages[];
int numberWalkingImages;
PImage jumpingImages[];
int numberJumpingImages;
int standingImage = 0;
PImage dyingImages[];
int numberDyingImages;

// Colors and fonts
PFont font, title;
color menuBackgroundColor;
color buttonsPressedColor;
color textColor;

// Game states
String gameState;
String levelState;

// Player camera offset
int cameraOffsetX;
int cameraOffsetY;

// Map editor properties
int tilemapX, tilemapY;
int editedMapX, editedMapY;
int editedMapColumns, editedMapRows;
int beginEditedMapColumn, endEditedMapColumn;
String editLevelNumber;
boolean erasingMode;
JSONObject json;
Table table;
PImage imageDrag;

// Enemy properties
PImage boltImage;
PImage woltImage;
Object woltBoxes[];
int woltBoxesNumber;
PImage woltBoxImage;

// Game properties
int livesLeft;
int hurt;
boolean isHurt;
int points;
int screenMessageTime;
int level2Introduction, level3Introduction;
int currentImage;
boolean doNotChangeLevel;
boolean left, right, up, down;

void setup(){
  
  // Game properties
  hurt = 0;
  livesLeft = 5;
  level2Introduction = 150;
  level3Introduction = 100;
  currentImage = 0;
  doNotChangeLevel = false;
  boltImage = loadImage("data/bolt.png");
  woltImage = loadImage("data/wolt.png");
  
  // Setting the gameState
  gameState = "MENU";
  levelState = "LEVEL 1";

  // Map editor properties
  tilemapX = 700;
  tilemapY = 200;
  editedMapX = 80;
  editedMapY = 50;
  editedMapColumns = 25;
  editedMapRows = 20;
  beginEditedMapColumn = 0;
  endEditedMapColumn = 25;
  editLevelNumber = "LEVEL 1";
  imageDrag = new PImage();
  erasingMode = false;
  screenMessageTime = 150;
  
  // Background
  size(1000,700);
  background(255);
  
  // Player camera offset
  cameraOffsetX = 0;
  cameraOffsetY = 0;
  
  // Loading corgi player images
  numberWalkingImages = 10;
  walkingImages = new PImage[numberWalkingImages];
  for (int i = 0; i < numberWalkingImages; ++i) {
    walkingImages[i] = loadImage("data/corgi/Walk ("+ (i+1) +").png");
  }
  numberJumpingImages = 8;
  jumpingImages = new PImage[numberJumpingImages];
  for (int i = 0; i < numberJumpingImages; ++i) {
    jumpingImages[i] = loadImage("data/corgi/Jump ("+ (i+1) +").png");
  }
  numberDyingImages = 10;
  dyingImages = new PImage[numberDyingImages];
  for (int i = 0; i < numberDyingImages; ++i) {
    dyingImages[i] = loadImage("data/corgi/Dead ("+ (i+1) +").png");
  }
  
  // Creating enemies
  woltBoxesNumber = 2;
  woltBoxes = new Object[woltBoxesNumber];
  woltBoxes[0] = new Object();
  woltBoxes[0].x = random(100, 200);
  woltBoxes[0].y = random(100, 200);
  woltBoxes[1] = new Object();
  woltBoxes[1].x = random(400, 800);
  woltBoxes[1].y = random(600, 800);
  woltBoxImage = new PImage();
  woltBoxImage = loadImage("data/wolt_box.png");

  table = loadTable("data/map/baseMap_sky.csv");
  json = loadJSONObject("data/tileset/cityBackground.json");
  baseMapSky = new Map();
  table = loadTable("data/map/baseMap_buildings1.csv");
  baseMapBuildings1 = new Map(); 
  table = loadTable("data/map/baseMap_buildings2.csv");
  baseMapBuildings2 = new Map();
  table = loadTable("data/map/baseMap_ground.csv");
  json = loadJSONObject("data/tileset/cityObjects.json");
  baseMapGround = new Map();
  table = loadTable("data/map/world_level1.csv");
  worldLevel1 = new Map();
  table = loadTable("data/map/world_level2.csv");
  worldLevel2 = new Map();
  table = loadTable("data/map/world_level3.csv");
  worldLevel3 = new Map();
  
  baseMapSky.tileIdTable = loadTable("data/map/baseMap_sky.csv");
  baseMapBuildings1.tileIdTable = loadTable("data/map/baseMap_buildings1.csv");
  baseMapBuildings2.tileIdTable = loadTable("data/map/baseMap_buildings2.csv");
  baseMapGround.tileIdTable = loadTable("data/map/baseMap_ground.csv");
  worldLevel1.tileIdTable = loadTable("data/map/world_level1.csv");
  worldLevel2.tileIdTable = loadTable("data/map/world_level2.csv");
  worldLevel3.tileIdTable = loadTable("data/map/world_level3.csv");
  
  // Loading the map images
  baseMapSky.tilesetImage = loadImage("data/tileset/cityBackground.png");
  baseMapBuildings1.tilesetImage = loadImage("data/tileset/cityBackground.png");
  baseMapBuildings2.tilesetImage = loadImage("data/tileset/cityBackground.png");
  baseMapGround.tilesetImage = loadImage("data/tileset/cityObjects.png");
  worldLevel1.tilesetImage = loadImage("data/tileset/cityObjects.png");
  worldLevel2.tilesetImage = loadImage("data/tileset/cityObjects.png");
  worldLevel3.tilesetImage = loadImage("data/tileset/cityObjects.png");
  
  baseMapSky.tilesetProperties = loadJSONObject("data/tileset/cityBackground.json");
  baseMapBuildings1.tilesetProperties = loadJSONObject("data/tileset/cityBackground.json");
  baseMapBuildings2.tilesetProperties = loadJSONObject("data/tileset/cityBackground.json");
  baseMapGround.tilesetProperties = loadJSONObject("data/tileset/cityObjects.json");
  worldLevel1.tilesetProperties = loadJSONObject("data/tileset/cityObjects.json");
  worldLevel2.tilesetProperties = loadJSONObject("data/tileset/cityObjects.json");
  worldLevel3.tilesetProperties = loadJSONObject("data/tileset/cityObjects.json");
   
  // Initializing buttons
  playButton = new Object();
  playButton.beginX = width/2-100;
  playButton.beginY = height/2-30;
  playButton.endX = width/2+100;
  playButton.endY = height/2+30;
  editMapButton = new Object();
  editMapButton.beginX = width/2-100;
  editMapButton.beginY = height/2+70;
  editMapButton.endX = width/2+100;
  editMapButton.endY = height/2+130;
  quitButton = new Object();
  quitButton.beginX = width/2-100;
  quitButton.beginY = height/2+170;
  quitButton.endX = width/2+100;
  quitButton.endY = height/2+230;
  levelButton = new Object();
  levelButton.beginX = tilemapX;
  levelButton.beginY = tilemapY-100;
  levelButton.endX = tilemapX+240;
  levelButton.endY = tilemapY+60-100;
  levelButtonLeft = new Object();
  levelButtonLeft.beginX = tilemapX;
  levelButtonLeft.beginY = tilemapY-100;
  levelButtonLeft.endX = tilemapX+30;
  levelButtonLeft.endY = tilemapY+60-100;
  levelButtonRight = new Object();
  levelButtonRight.beginX = tilemapX+210;
  levelButtonRight.beginY = tilemapY-100;
  levelButtonRight.endX = tilemapX+240;
  levelButtonRight.endY = tilemapY+60-100;
  editedMapButtonLeft = new Object();
  editedMapButtonLeft.beginX = editedMapX - 40;
  editedMapButtonLeft.beginY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2)/2 - 30;
  editedMapButtonLeft.endX = editedMapX - 10;
  editedMapButtonLeft.endY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2)/2 + 30;
  editedMapButtonRight = new Object();
  editedMapButtonRight.beginX = editedMapX + editedMapColumns*(worldLevel1.tileWidth/2) + 10;
  editedMapButtonRight.beginY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2)/2 - 30;
  editedMapButtonRight.endX = editedMapX + editedMapColumns*(worldLevel1.tileWidth/2) + 40;
  editedMapButtonRight.endY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2)/2 + 30;
  eraserButton = new Object();
  eraserButton.beginX = width/2 + 200;
  eraserButton.beginY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2) + 100;
  eraserButton.endX = width/2 + 400;
  eraserButton.endY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2) + 160;
  backToMenuButton = new Object();
  backToMenuButton.beginX = width/2 - 400;
  backToMenuButton.beginY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2) + 100;
  backToMenuButton.endX = width/2 - 200;
  backToMenuButton.endY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2) + 160;
  saveButton = new Object();
  saveButton.beginX = width/2 - 100;
  saveButton.beginY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2) + 100;
  saveButton.endX = width/2 + 100;
  saveButton.endY = editedMapY + editedMapRows*(worldLevel1.tileHeight/2) + 160;
  backToMenuFromPlayButton = new Object();
  backToMenuFromPlayButton.beginX = 30;
  backToMenuFromPlayButton.beginY = 30;
  backToMenuFromPlayButton.endX = 70;
  backToMenuFromPlayButton.endY = 70;
  statusLives = new Object();
  statusLives.beginX = 600;
  statusLives.beginY = 40;
  statusLives.endX = 720;
  statusLives.endY = 80;
  statusLivesNumber = new Object();
  statusLivesNumber.beginX = 720;
  statusLivesNumber.beginY = 40;
  statusLivesNumber.endX = 770;
  statusLivesNumber.endY = 80;
  statusPoints = new Object();
  statusPoints.beginX = 770;
  statusPoints.beginY = 40;
  statusPoints.endX = 890;
  statusPoints.endY = 80;
  statusPointsNumber = new Object();
  statusPointsNumber.beginX = 890;
  statusPointsNumber.beginY = 40;
  statusPointsNumber.endX = 940;
  statusPointsNumber.endY = 80;
  
  // Tilemap tiles
  tilemapTilesNumber = worldLevel1.imageRows * worldLevel1.imageColumns;
  tilemapTiles = new Object[tilemapTilesNumber];
  for (int i = 0; i < tilemapTilesNumber; ++i) {
   tilemapTiles[i] = new Object();
  }
  worldLevel1.createTiles();
  editedMapTiles = new Object[editedMapColumns*editedMapRows];
  for (int i = 0; i < editedMapColumns*editedMapRows; ++i) {
    editedMapTiles[i] = new Object();
  }
  worldLevel1.createEditedMapTiles();
  
  // Setting the default font
  font = createFont("data/font/Minecraft.ttf", 32);
  textFont(font);
  title = createFont("data/font/sttransmission-800-extrabold.otf", 140);
  
  // Setting the default colors
  menuBackgroundColor = color(0, 211, 117);
  buttonsPressedColor = color(72, 125, 101);
  textColor = color(255);
  
  // Initializing the player corgi
  corgi = new Player();
  
  // Setting boolean variables to false
  left = false;
  right = false;
  up = false;
  down = false;
}

void draw() {
  
  if (gameState == "MENU") {
    menuGame();
  }
  else if (gameState == "EDIT") {
    editGame();
  }
  else if (gameState == "PLAY") {
    playGame();
  }
  else if (gameState == "QUIT") {
    exit();
  }
}

void keyPressed() {
  
  switch(keyCode) {
  case 37: // left
    left = true;
    break;
   case 38: // up
    up = true;
    break;
   case 32: // up (space)
    up = true;
    break;
   case 39: // right
    right = true;
    break;
   case 40: // down
    down = true;
  }
  
}

void keyReleased() {
  
    switch(keyCode) {
  case 37: // left
    left = false;
    break;
   case 38: // up
    up = false;
    break;
   case 32: // up (space)
    up = false;
    break;
   case 39: // right
    right = false;
    break;
   case 40: // down
    down = false;
  }
  
}

void clearBackground() {
  background(40, 46, 150);
}

void menuGame() {
  
  // Name of the game
  scale(1.0);
  background(menuBackgroundColor);
  textSize(80);
  textAlign(CENTER, CENTER);
  fill(textColor);
  textFont(title);
  text ("THE", width/2-300, height/2 - 130);
  text ("RUSH", width/2+300, height/2 - 130);
  textFont(font);
  imageMode(CENTER);
  pushMatrix();
  scale(0.8);
  imageMode(CENTER);
  image(boltImage, width-400, height-440);
  popMatrix();
  
  // Menu buttons
  playButton.button("PLAY", 30);
  editMapButton.button("EDIT MAP", 30);
  quitButton.button("QUIT", 30);
  
  if (playButton.isMouseTouching() == true) {
    playButton.mouseTouchingButton("PLAY", 30);
    if (mousePressed)
      gameState = "PLAY";
  }
  if (editMapButton.isMouseTouching() == true) {
    editMapButton.mouseTouchingButton("EDIT MAP", 30);
    if (mousePressed)
      gameState = "EDIT";
  }
  if (quitButton.isMouseTouching() == true) {
    quitButton.mouseTouchingButton("QUIT", 30);
    if (mousePressed)
      gameState = "QUIT";
  }
  
}

// PLAYING THE GAME

void playGame() {

  clearBackground();
  
  if (levelState == "LEVEL 1") {
    baseMapSky.update();
    baseMapBuildings1.update();
    baseMapBuildings2.update();
    worldLevel1.updateWithObjects();
    corgi.resolvePlatformCollisions(worldLevel1.playMapTiles, worldLevel1.playMapTilesNumber);
    corgi.display();
    screenMessageTime = 150;
    statusLives.button("LIVES", 20);
    statusLivesNumber.button(str(livesLeft), 20);
    statusPoints.button("POINTS", 20);
    statusPointsNumber.button(str(points), 20);
  }
  else if (levelState == "LEVEL 2") {
    if (level2Introduction > 0) {
      background(0, 155, 228);
      textSize(100);
      textAlign(CENTER, CENTER);
      text("BEWARE!", width/2, height/2-200);
      pushMatrix();
      scale(0.8);
      image(woltImage, width/2+100, height/2+100);
      popMatrix();
      textSize(100);
      textAlign(CENTER, CENTER);
      text("INCOMING", width/2, height/2+200);
      --level2Introduction;
    }
    else {
      doNotChangeLevel = false;
      baseMapSky.update();
      baseMapBuildings1.update();
      baseMapBuildings2.update();
      worldLevel2.updateWithObjects();
      corgi.resolvePlatformCollisions(worldLevel2.playMapTiles, worldLevel2.playMapTilesNumber);
      corgi.display();
      textSize(15);
      statusLives.button("LIVES", 20);
      statusLivesNumber.button(str(livesLeft), 20);
      statusPoints.button("POINTS", 20);
      statusPointsNumber.button(str(points), 20);
      screenMessageTime = 150;
      woltBoxes[0].display(woltBoxImage);
      woltBoxes[0].update();
    }
  }
  else if (levelState == "LEVEL 3") {
    if (level3Introduction > 0) {
      background(0, 155, 228);
      textAlign(CENTER, CENTER);
      textSize(50);
      text("EVEN MORE OF THEM!", width/2, height/2);
      --level3Introduction;
    }
    else {
      baseMapSky.update();
      baseMapBuildings1.update();
      baseMapBuildings2.update();
      worldLevel3.updateWithObjects();
      corgi.resolvePlatformCollisions(worldLevel3.playMapTiles, worldLevel3.playMapTilesNumber);
      corgi.display();
      textSize(15);
      statusLives.button("LIVES", 20);
      statusLivesNumber.button(str(livesLeft), 20);
      statusPoints.button("POINTS", 20);
      statusPointsNumber.button(str(points), 20);
      screenMessageTime = 150;
      woltBoxes[0].display(woltBoxImage);
      woltBoxes[0].update();
      woltBoxes[1].display(woltBoxImage);
      woltBoxes[1].update();
      doNotChangeLevel = false;
    }
  }
  else if (levelState == "LOST") {
    background(menuBackgroundColor);
    if (screenMessageTime > 0) {
      if (screenMessageTime%10 == 0 && currentImage < 9) {
        ++currentImage;
      }
      pushMatrix();
      scale(0.8);
      imageMode(CENTER);
      image(dyingImages[currentImage%10], width/2-50, height/2+100);
      textAlign(CORNER);
      textSize(100);
      text("YOU LOST", width/2+50, height/2-50);
      popMatrix();
      --screenMessageTime;
    }
    else {
      gameState = "QUIT";
    }
  }
  else if (levelState == "WON") {
      background(menuBackgroundColor);
      if (screenMessageTime > 0) {
      if (screenMessageTime%10 == 0 && currentImage < 7) {
        ++currentImage;
      }
      pushMatrix();
      scale(0.8);
      imageMode(CENTER);
      image(jumpingImages[currentImage%8], width/2-50, height/2+100);
      textAlign(CORNER);
      textSize(100);
      text("YOU WON!", width/2+50, height/2-50);
      popMatrix();
      --screenMessageTime;
    }
    else {
      gameState = "QUIT";
    }
  }
  
  backToMenuFromPlayButton.button("<", 30);
  
  if (backToMenuFromPlayButton.isMouseTouching() == true) {
    backToMenuFromPlayButton.mouseTouchingButton("<", 30);
    if (mousePressed)
      gameState = "MENU";
  }
}

// TILEMAP EDITOR
  
void editGame() {

  background(menuBackgroundColor);
  
  baseMapSky.displayInEditMap();
  baseMapBuildings1.displayInEditMap();
  baseMapBuildings2.displayInEditMap();
  baseMapGround.displayInEditMap();

  worldLevel1.displayTileMap();
  
  for (int i = 0; i < tilemapTilesNumber; ++i) {
    if (tilemapTiles[i].isMouseTouching() == true) {
      if (mousePressed == true) {
        int imageWidth = tilemapTiles[i].endX-tilemapTiles[i].beginX;
        int imageHeight = tilemapTiles[i].endY-tilemapTiles[i].beginY;
        imageDrag = worldLevel1.tilesetImage.get(worldLevel1.tileWidth*tilemapTiles[i].idColumn, worldLevel1.tileHeight*tilemapTiles[i].idRow, imageWidth, imageHeight);
        currentTileId = i;
      }
    }
  }
  
  if (editLevelNumber == "LEVEL 2") {
    worldLevel2.displayInEditMap();
    
    for (int i = 0; i < editedMapColumns*editedMapRows; ++i) {
      if (editedMapTiles[i].isMouseTouching() == true) {
        if ( (mousePressed == true) && (erasingMode == false) ) {
          worldLevel2.addTile(i);
        }
        else if ( (erasingMode == true) && (mousePressed == true) ) {
          worldLevel2.deleteTile(i);
        }
      }
    }
  }
  else if (editLevelNumber == "LEVEL 3") {
    worldLevel3.displayInEditMap();
    
    for (int i = 0; i < editedMapColumns*editedMapRows; ++i) {
      if (editedMapTiles[i].isMouseTouching() == true) {
        if ( (mousePressed == true) && (erasingMode == false) ) {
          worldLevel3.addTile(i);
        }
        else if ( (erasingMode == true) && (mousePressed == true) ) {
          worldLevel3.deleteTile(i);
        }
      }
    }
  }
  else {
    worldLevel1.displayInEditMap();
    
    for (int i = 0; i < editedMapColumns*editedMapRows; ++i) {
      if (editedMapTiles[i].isMouseTouching() == true) {
        if ( (mousePressed == true) && (erasingMode == false) ) {
          worldLevel1.addTile(i);
        }
        else if ( (erasingMode == true) && (mousePressed == true) ) {
          worldLevel1.deleteTile(i);
        }
      }
    }
  }
  
  // BUTTONS
  
  levelButton.button(editLevelNumber, 30);
  levelButtonLeft.button("<", 30); 
  levelButtonRight.button(">", 30); 
  editedMapButtonLeft.button("<", 30);
  editedMapButtonRight.button(">", 30);
  eraserButton.button("ERASER", 30);
  backToMenuButton.button("< MENU", 30);
  saveButton.button("SAVE", 30);
  
  if (eraserButton.isMouseTouching() == true) {
    eraserButton.mouseTouchingButton("ERASER", 30);
  }
  
  if (erasingMode == true) {
    eraserButton.mouseTouchingButton("ERASER", 30);
  }
  else {
    image(imageDrag, mouseX, mouseY);
  }
  
  if (saveButton.isMouseTouching() == true) {
    saveButton.mouseTouchingButton("SAVE", 30);
  }
  
  // Go back to menu from the editor
  if (backToMenuButton.isMouseTouching() == true) {
    backToMenuButton.mouseTouchingButton("< MENU", 30);
  }
  
  if (editedMapButtonRight.isMouseTouching() == true) {
      if (endEditedMapColumn < worldLevel1.tileIdTableColumns) {
        editedMapButtonRight.mouseTouchingButton(">", 30);
      }
   }
   
  if (editedMapButtonLeft.isMouseTouching() == true) {
    if (beginEditedMapColumn > 0) {
      editedMapButtonLeft.mouseTouchingButton("<", 30);
    }
  }
   
  
  if (levelButtonRight.isMouseTouching() == true) {
    if (editLevelNumber == "LEVEL 1") {
        levelButtonRight.mouseTouchingButton(">", 30);
     }
     else if (editLevelNumber == "LEVEL 2") {
        levelButtonRight.mouseTouchingButton(">", 30);
     }
  }
  
  if (levelButtonLeft.isMouseTouching() == true) {
     if (editLevelNumber == "LEVEL 2") {
       levelButtonLeft.mouseTouchingButton("<", 30);
     }
     else if (editLevelNumber == "LEVEL 3") {
       levelButtonLeft.mouseTouchingButton("<", 30);
     }
  }
  
}

void mouseClicked() {

  if (editLevelNumber == "LEVEL 2") {
    if (saveButton.isMouseTouching() == true) {
      saveTable(worldLevel2.tileIdTable, "data/map/world_level2.csv");
    }
    
    if (editedMapButtonRight.isMouseTouching() == true) {
      if (endEditedMapColumn < worldLevel2.tileIdTableColumns) {
        beginEditedMapColumn += 1;
        endEditedMapColumn += 1;
      }
    }
  }
  else if (editLevelNumber == "LEVEL 3") {
    if (saveButton.isMouseTouching() == true) {
      saveTable(worldLevel3.tileIdTable, "data/map/world_level3.csv");
    }
    
    if (editedMapButtonRight.isMouseTouching() == true) {
      if (endEditedMapColumn < worldLevel3.tileIdTableColumns) {
        beginEditedMapColumn += 1;
        endEditedMapColumn += 1;
      }
    }
  }
  else {
    if (saveButton.isMouseTouching() == true) {
      saveTable(worldLevel1.tileIdTable, "data/map/world_level1.csv");
    }
    
    if (editedMapButtonRight.isMouseTouching() == true) {
      if (endEditedMapColumn < worldLevel1.tileIdTableColumns) {
        beginEditedMapColumn += 1;
        endEditedMapColumn += 1;
      }
    }
  }
  
  if (editedMapButtonLeft.isMouseTouching() == true) {
    if (beginEditedMapColumn > 0) {
      beginEditedMapColumn -= 1;
      endEditedMapColumn -= 1;
    }
  }
  
  if (eraserButton.isMouseTouching() == true) {
    if (erasingMode == true) {
      erasingMode = false;
    }
    else {
      erasingMode = true;
    }
  }
  
  if (backToMenuButton.isMouseTouching() == true) {
     gameState = "MENU";
  }
  
  if (levelButtonRight.isMouseTouching() == true) {
    if (editLevelNumber == "LEVEL 1") {
       editLevelNumber = "LEVEL 2";
     }
     else if (editLevelNumber == "LEVEL 2") {
       editLevelNumber = "LEVEL 3";
     }
  }
  
  if (levelButtonLeft.isMouseTouching() == true) {
     if (editLevelNumber == "LEVEL 2") {
       editLevelNumber = "LEVEL 1";
     }
     else if (editLevelNumber == "LEVEL 3") {
       editLevelNumber = "LEVEL 2";
     }
  }
    
}
