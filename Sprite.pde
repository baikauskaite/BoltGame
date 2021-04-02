class Player {
  
  // Properties
  int x, y; // current position of sprite
  int w, h; // width and height of sprite
  int maxSpeed;
  int posLeft, posRight, posBottom, posTop;
  int currentFrameWalking, currentFrameJumping, delay;
  boolean lastDirection; // false - left, true - right
  boolean isJump;
  boolean isOnPlatform;
  int jumpSpeed;
  int gravity;
  int changeX, changeY;
  boolean isGravity;
  
  // Constructor
  Player() {
    currentFrameWalking = currentFrameJumping = 0;
    delay = 1;
    isJump = false;
    isOnPlatform = false;
    lastDirection = true;
    gravity = 6;
    jumpSpeed = 40;
    isGravity = true;
    
    // Ccale of the player
    w = 80;
    h = 64;
    
    // Ctarting position
    x = width/2;
    y = height/2;
    posLeft = x - w/4;
    posRight = x + w/4;
    posTop = y - h/2;
    posBottom = y + h/2;
    
    maxSpeed = 8;
    changeX = 0;
    changeY = gravity;
  }
  
  // METHODS
  
  // Get the boundary positions of the sprite
  int getLeft () {
    return posLeft;
  }
  int getRight () {
    return posRight;
  }
  int getTop () {
    return posTop;
  }
  int getBottom () {
    return posBottom;
  }
  
  void setChangeX (int x) {
    changeX = x;
  }
  
  void setChangeY (int y) {
    changeY = y;
  }
  
  void changePositionX () {
    cameraOffsetX -= changeX;
  }
  
  void changePositionY () {
    cameraOffsetY -= changeY;
  }
  
  void display() {
    
    --delay;
    if (delay == 0) {
      currentFrameWalking = ++currentFrameWalking % numberWalkingImages;
      currentFrameJumping = ++currentFrameJumping % numberJumpingImages;
      delay = 5;
    }
    
    if (isHurt) {
      isHurt = (hurt > 0)? true : false;
      --hurt;
    }
    
    if ( (hurt%20 > 10) && (hurt%20 < 20 )) {
      rectMode(CENTER);
      color(41, 44, 71);
      rect(-x, y, w, h);
    }
    else {
    if (isJump && !lastDirection) {
      pushMatrix();
      scale(-1, 1);
      imageMode(CENTER);
      image(jumpingImages[currentFrameJumping], -x, y, w, h);
      popMatrix();
    }
    else if (isJump && lastDirection) {
      imageMode(CENTER);
      image(jumpingImages[currentFrameJumping], x, y, w, h);
    }
    else if (left) {
      pushMatrix();
      scale(-1, 1);
      imageMode(CENTER);
      image(walkingImages[currentFrameWalking], -x, y, w, h);
      popMatrix();
    }
    else if (right) {
      imageMode(CENTER);
      image(walkingImages[currentFrameWalking], x, y, w, h);
    }
    else if (!lastDirection) {
      pushMatrix();
      scale(-1, 1);
      imageMode(CENTER);
      image(walkingImages[standingImage], -x, y, w, h);
      popMatrix();
    }
    else {
      imageMode(CENTER);
      image(walkingImages[standingImage], x, y, w, h);
    }
    
  }
    
  }
  
  
  boolean checkCollision (Object tile, String side) {
      
    int rightDx = tile.getLeft() - getRight();
    int leftDx = getLeft() - tile.getRight();
    int topDy = getTop() - tile.getBottom();
    int bottomDy = tile.getTop() - getBottom();
    
     boolean noXOverlap = getRight() <= tile.getLeft() || getLeft() >= tile.getRight();
     boolean noYOverlap = getBottom() <= tile.getTop() || getTop() >= tile.getBottom();
     
     if (noXOverlap || noYOverlap) {
       return false;
     }
     else {
        if (side == "BOTTOM") {
            tile.dy = bottomDy-2;
            return true;
        }
        else if (side == "TOP") {
            tile.dy = -topDy+2;
            return true;
        }
        else if (side == "LEFT") {
            tile.dx = -leftDx;
            return true;
        }
        else if (side == "RIGHT") {
            tile.dx = rightDx;
            return true;
        }
       return true;
     }
  }
  
  boolean checkifOnPlatform (Object tile) {
    
     boolean noXOverlap = getRight() <= tile.getLeft() || getLeft() >= tile.getRight();
     boolean noYOverlap = getBottom()+4 <= tile.getTop() || getTop() >= tile.getBottom();
     
     if (noXOverlap || noYOverlap) {
       return false;
     }
     else {
       if (!(noXOverlap || noYOverlap))
         return true;
     }
     return false;

  }
  
  ArrayList<Object> checkCollisionList (Object objects[], int objectsNumber, String side) {
    
    Object tile;
    ArrayList<Object> collisionList = new ArrayList<Object>();
    
    if (side == "PLATFORM") {
      for (int i = 0; i < objectsNumber; ++i) {
        tile = objects[i];
        if (tile.id == -1) {
          continue;
        }
        if (checkifOnPlatform(tile) == true) {
          collisionList.add(tile);
        }
      }
    }
    else {
      for (int i = 0; i < objectsNumber; ++i) {
        tile = objects[i];
        if (tile.id == -1) {
          continue;
        }
        if (checkCollision(tile, side) == true) {
          if (tile.id == 22) {
            ++points;
            if (levelState == "LEVEL 1") {
              worldLevel1.deleteTile(tile);
            }
            else if (levelState == "LEVEL 2") {
              worldLevel2.deleteTile(tile);
            }
            else if (levelState == "LEVEL 3") {
              worldLevel2.deleteTile(tile);
            }
          }
          else if ((tile.id == 25) || (tile.id == 26)) {
            if (!doNotChangeLevel) {
              if (levelState == "LEVEL 1") {
                levelState = "LEVEL 2";
                doNotChangeLevel = true;
                break;
              }
              else if (levelState == "LEVEL 2") {
                levelState = "LEVEL 3";
                doNotChangeLevel = true;
                break;
              }
              else if (levelState == "LEVEL 3") {
                levelState = "WON";
                doNotChangeLevel = true;
                break;
              }
            }
          }
          else if (tile.id == 27) {
            if (livesLeft == 0) {
              levelState = "LOST";
            }
            else {
              isHurt = true;
              hurt = 100;
              if (isHurt)
                --livesLeft;
            }
          }
          else
            collisionList.add(tile);
        }
      }
    }
    
    return collisionList;
 
  }

  void resolvePlatformCollisions (Object objects[], int objectsNumber) {
    
    ArrayList<Object> collisionList;
    
    // Moving to the left side
    if (left) {
      collisionList = checkCollisionList(objects, objectsNumber, "LEFT");
      // resolving collisions
      if (collisionList.size() > 0 && !lastDirection) {
        Object collided = collisionList.get(0);
        if (collided.dx > 0) {
          setChangeX(collided.dx);
          changePositionX();
          setChangeX(0);
        }
        else {
        setChangeX(-maxSpeed);
        changePositionX();
        }
      }
      else {
        setChangeX(-maxSpeed);
        changePositionX();
      }
      lastDirection = false;
    }
    // Moving to the right side
    else if (right) {
      collisionList = checkCollisionList(objects, objectsNumber, "RIGHT");
      // resolving collisions
      if (collisionList.size() > 0 && lastDirection) {
        Object collided = collisionList.get(0);
        if (collided.dx < 0) {
          setChangeX(collided.dx);
          changePositionX();
        }
        else {
        setChangeX(maxSpeed);
        changePositionX();
        }
      }
      else {
        setChangeX(maxSpeed);
        changePositionX();
      }
      lastDirection = true;
    }
    // If moving neither to Left or Right
    if (!left && !right) {
      setChangeX(0);
    }
    
    if (changeY > 0) {
      collisionList = checkCollisionList(objects, objectsNumber, "BOTTOM");
      // resolving collisions
        if (collisionList.size() > 0) {
          Object collided = collisionList.get(0);
          if (collided.dy < 0) {
            setChangeY(collided.dy);
            changePositionY();
            setChangeY(0);
          }
        }
        else if (!isJump && !isOnPlatform) {
          setChangeY(gravity);
          changePositionY();
          isOnPlatform = false;
        }
    }
    
    if (changeY == 0) {       
      collisionList = checkCollisionList(objects, objectsNumber, "PLATFORM");
      // resolving collisions
        if (collisionList.size() > 0) {
          isOnPlatform = true;
        }
        else {
          isOnPlatform = false;
          setChangeY(gravity);
        }
    }
    
    // JUMPING
    if (up && !isJump && isOnPlatform) {
      isJump = true;
      isOnPlatform = false;
    }
    
    if (isJump == true) {
      if (jumpSpeed >= -30) {
        setChangeY(-jumpSpeed);
        changePositionY();
        jumpSpeed -= gravity;
      }
      else {
        isJump = false;
        jumpSpeed = 30;
      }
    }
    
    if (!isHurt) {
    for (int i = 0; i < woltBoxesNumber; ++i) {
      if (woltBoxes[i].isTouching(corgi) == true) {
        isHurt = true;
        hurt = 100;
        if (isHurt)
        --livesLeft;
       }
      }
    }
    if (livesLeft <= 0) {
      levelState = "LOST";
    }
    

    }
  
}
