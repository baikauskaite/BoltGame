class Map {
  
  // Properties
  Table tileIdTable;
  PImage tilesetImage;
  JSONObject tilesetProperties;
  int tileIdTableColumns;
  int tileIdTableRows;
  
  int tileId;
  int previousTileId;
  
  int tileX, tileY;
  PImage img;
  
  int tileHeight;
  int tileWidth;
  int imageRows;
  int imageColumns;
  int imageHeight;
  int imageWidth;
  
  Object playMapTiles[];
  int playMapTilesNumber;
  
  // Constructor
  Map () {
    tileId = 1;
    previousTileId = 1000;
    
    tileHeight = json.getInt("tileheight");
    tileWidth = json.getInt("tilewidth");
    imageHeight = json.getInt("imageheight");
    imageRows = imageHeight / tileHeight;
    imageWidth = json.getInt("imagewidth");
    imageColumns = imageWidth / tileWidth;
    
    tileIdTableRows = table.getRowCount();
    tileIdTableColumns = table.getColumnCount();
    
    playMapTilesNumber = tileIdTableColumns * tileIdTableRows;
    playMapTiles = new Object[playMapTilesNumber];
    for (int i = 0; i < playMapTilesNumber; ++i) {
      playMapTiles[i] = new Object();
    }
  }
  
  void update() {
      
    for (int row = 0; row < tileIdTableRows; ++row) {
      for (int column = 0; column < tileIdTableColumns; ++column) {
        tileId = tileIdTable.getInt(row, column);
         if (tileId == -1)
          continue;
        tileX = tileId % imageColumns;
        tileY = tileId / imageColumns;
        
        img = tilesetImage.get(tileX*tileWidth, tileY*tileHeight, tileWidth, tileHeight);
        imageMode(CORNER);
        image(img, cameraOffsetX + column*tileWidth, cameraOffsetY + row*tileHeight, tileWidth, tileHeight);
      }
    }
  
  }
  
  void updateWithObjects () {
    
    Object mapTile;
    for (int row = 0; row < tileIdTableRows; ++row) {
      for (int column = 0; column < tileIdTableColumns; ++column) {
        tileId = tileIdTable.getInt(row, column);
        mapTile = playMapTiles[row*tileIdTableColumns+column];
        mapTile.id = tileId;
        
        if (tileId == -1)
          continue;
          
        mapTile.beginX = cameraOffsetX + column*tileWidth;
        mapTile.beginY = cameraOffsetY + row*tileHeight;
        mapTile.endX = cameraOffsetX + column*tileWidth + tileWidth;
        mapTile.endY = cameraOffsetY + row*tileHeight + tileHeight;
        mapTile.idColumn = column;
        mapTile.idRow = row;
        
        tileX = tileId % imageColumns;
        tileY = tileId / imageColumns;
        
        img = tilesetImage.get(tileX*tileWidth, tileY*tileHeight, tileWidth, tileHeight);
        imageMode(CORNER);
        image(img, cameraOffsetX + column*tileWidth, cameraOffsetY + row*tileHeight, tileWidth, tileHeight);
      }
    }
  
  }
  
  void displayInEditMap () {
    
    noFill();
    strokeWeight(0.5);
    stroke(191, 191, 191);
    
    int x, y;
    int tWidth = tileWidth/2;
    int tHeight = tileHeight/2;
    
    // Display of the level map
    for (int row = 0; row < editedMapRows; ++row) {
      for (int i = beginEditedMapColumn, column = 0; i < endEditedMapColumn; ++i, ++column) {
        x = editedMapX + column*tWidth;
        y = editedMapY + row*tHeight;
        tileId = tileIdTable.getInt(row, i);
        
        if (tileId == -1) {
          rectMode(CORNER);
          rect(x, y, tWidth, tHeight);
          editedMapTiles[row*editedMapColumns+column].idColumn = i;
          editedMapTiles[row*editedMapColumns+column].idRow = row;
          continue;
        }
        
        editedMapTiles[row*editedMapColumns+column].idColumn = i;
        editedMapTiles[row*editedMapColumns+column].idRow = row;
        
        tileX = tileId % imageColumns;
        tileY = tileId / imageColumns;
        img = tilesetImage.get(tileX*tileWidth, tileY*tileHeight, tileWidth, tileHeight);
        imageMode(CORNER);
        image(img, x, y, tWidth, tHeight);
        rectMode(CORNER);
        rect(x, y, tWidth, tHeight);
      }
    }
  
}

  void displayTileMap () {
    noFill();
    strokeWeight(1);
    stroke(191, 191, 191);
  
    // display of the tilemap
    for (int row = 0; row < imageRows; ++row) {
      for (int column = 0; column < imageColumns; ++column) {
        img = tilesetImage.get(column*tileWidth, row*tileHeight, tileWidth, tileHeight);
        imageMode(CORNER);
        image(img, tilemapX + column*tileWidth, tilemapY + row*tileHeight, tileWidth, tileHeight);        
        // lines between tiles
        rectMode(CORNER);
        rect(tilemapX + column*tileWidth, tilemapY + row*tileHeight, tileWidth, tileHeight);
       }
    }
    
  
  }
  
  void createTiles () {
    int index;
    
    for (int row = 0; row < imageRows; ++row) {
      for (int column = 0; column < imageColumns; ++column) {
        index = row*imageColumns+column;
        tilemapTiles[index].beginX = tilemapX + column*tileWidth;
        tilemapTiles[index].beginY = tilemapY + row*tileHeight;
        tilemapTiles[index].endX = tilemapX + column*tileWidth + tileWidth;
        tilemapTiles[index].endY = tilemapY + row*tileHeight + tileHeight;
        tilemapTiles[index].idColumn = column;
        tilemapTiles[index].idRow = row;
       }
    }
  
  }
  
  void createEditedMapTiles () {
    int index;
    int tWidth = tileWidth/2;
    int tHeight = tileHeight/2;
    
    for (int row = 0; row < editedMapRows; ++row) {
      for (int column = 0; column < editedMapColumns; ++column) {
        index = row*editedMapColumns+column;
        editedMapTiles[index].beginX = editedMapX + column*tWidth;
        editedMapTiles[index].beginY = editedMapY + row*tHeight;
        editedMapTiles[index].endX = editedMapX + column*tWidth + tWidth;
        editedMapTiles[index].endY = editedMapY + row*tHeight + tHeight;
       }
    }
  }
  
  void addTile (int index) {
    tileIdTable.setInt(editedMapTiles[index].idRow, editedMapTiles[index].idColumn, currentTileId);
  }
  
  void deleteTile (int index) {
    tileIdTable.setInt(editedMapTiles[index].idRow, editedMapTiles[index].idColumn, -1);
  }
    
  void deleteTile (Object tile) {
    tileIdTable.setInt(tile.idRow, tile.idColumn, -1);
  }

}
