class SongDetails{
  
  float x, y, w, h;
  String songTitle, artistName;
  PImage albumCover, streamingLogos;
  PFont textFont;
  
  SongDetails(float x, float y, float w, float h, String songTitle, String artistName, String albumCoverTitle){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    this.songTitle = songTitle;
    this.artistName = artistName;
    
    this.albumCover = loadImage(albumCoverTitle);
    
    this.streamingLogos = loadImage("logos.png");
    
    this.textFont = createFont("CormorantUnicase-Medium.ttf", 32);
  }
  
  void display(){
    //white line above everything
    stroke(255);
    strokeWeight(1);
    //display line
   // line(this.x, this.y, this.x+this.w, this.y);
    
    //album cover dimensions
    float albumCovX = this.x + this.w / 8;
    float albumCovY = this.y + this.h / 6;
    float albumCovW = this.w / 4;
    float albumCovH = this.h /1.5;
    
    //display white square around album cover
    float borderThickness = 20;
    fill(255);
    noStroke();
    rect(albumCovX - borderThickness, albumCovY - borderThickness, albumCovW + borderThickness*2, albumCovH + borderThickness*2);
    
    //display album cover
    image(this.albumCover, albumCovX, albumCovY, albumCovW, albumCovH);
    
    //display streaming logos
    image(this.streamingLogos, this.x + this.w/2.5, this.y + this.h - this.h / 3, this.streamingLogos.width/2, this.streamingLogos.height/2);
    
    //display song title
    textFont(this.textFont);
    textSize(32);
    text(this.songTitle, this.x + this.w - this.w/1.8, this.y + this.h/4);
    
    //display artist name
    textSize(20);
    text(this.artistName, this.x + this.w - this.w/2, this.y + this.h/2);
  }
}
