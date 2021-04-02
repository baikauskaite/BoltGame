class Object {
  
  // Properties
  int beginX;
  int beginY;
  int endX;
  int endY;
  
  int idColumn;
  int idRow;
  
  int id;
  
  int dx;
  int dy;
  
  int changeDestination;
  float destinationX;
  float destinationY;
  float x, y;
  
  // Constructor
  Object () {
    
  }
  
  boolean isMouseTouching () {
    if ( (mouseX >= beginX) && (mouseX <= endX) && (mouseY >= beginY) && (mouseY <= endY) )
      return true;
    
    return false;
  }
  
  void button (String message, int textSize) {
    
    strokeWeight(10);
    stroke(textColor);
    fill(menuBackgroundColor);
    rectMode(CORNERS);
    rect(beginX, beginY, endX, endY);
    displayText(message, textSize);

  }
  
  void mouseTouchingButton (String message, int textSize) {
    
   fill(buttonsPressedColor);
   rect(beginX, beginY, endX, endY);
   displayText(message, textSize);
   
  }
  
  void displayText (String message, int textSize) {
    textSize(textSize);
    fill(textColor);
    textAlign(CENTER, CENTER);
    text (message, (beginX+endX)/2, (beginY+endY)/2);
  }
  
  int getLeft () {
    return (int)beginX;
  }
  int getRight () {
    return endX;
  }
  int getTop () {
    return (int)beginY;
  }
  int getBottom () {
    return endY;
  }
  
  // Enemy display
  
  void display(PImage img) {
    imageMode(CORNER);
    image(img, x, y);
  }
  
  // Enemy update
  
  void update() {
    
    if (changeDestination%100 == 0 || x == destinationX || y == destinationY) {
      destinationX = random(0, 1000);
      destinationY = random(0, 700);
    }
    
    if (x < destinationX) {
      x += random(1, 2) - corgi.changeX/2;
    }
    else if (x > destinationX){
      x -= random(1, 2) + corgi.changeX/2;
    }
    if (y < destinationY) {
      y += random(1, 2) - corgi.changeY/4;
    }
    else if (y > destinationY) {
      y -= random(1, 2) + corgi.changeY/4;
    }
    
    beginX = (int)x;
    beginY = (int)y;
    endX = (int)x + 40;
    endY = (int)y + 40;
    
    ++changeDestination;
  }
  
  // Checking whether enemy is touching the player
  
  boolean isTouching(Player player) {
    
     boolean noXOverlap = player.getRight() < beginX || player.getLeft() > endX;
     boolean noYOverlap = player.getBottom() < beginY || player.getTop() > endY;
     
     if (noXOverlap || noYOverlap) {
       return false;
     }
     else {
       return true;
     }
    
  }
}
