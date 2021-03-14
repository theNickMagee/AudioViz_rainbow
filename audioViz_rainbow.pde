import com.hamoid.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;

VideoExport videoExport;

SongDetails songPreview;

float centerX, centerY;

float[] hues = {0, 30, 60, 120, 180, 240, 270, 300};  //red, orange, yellow, green, cyan, blue, violet, magenta


//SONG STUFF
String audioFilePath = "best_friend.mp3";

BufferedReader reader;

int lineCount = 0;

FloatList allValues, timeValues;
float[] allVals, timeVals;

String SEP = "|";

float movieFPS = 30;

int bufferSize = 180;

void setup() {
  size(500, 888, P3D);  //final dimensions - 600, 1067
  frameRate(1000);
  
  songPreview = new SongDetails(0, height - height/5, width, height/5, "Best Friend - Clean", "Saweetie (feat. Doja Cat)", "albumCov.png");
  
  centerX = width/2;
  centerY = 4*(height/5) / 2 + height/20;  //this comes from taking the half of the portion that is not in songPreview^^
  
  //smooth(16);
  
  
  //SONG STUFF PT 2
   println("wave file");
  //audioToWaveFile(audioFilePath);
  
  println("wave file made");
  reader = createReader(audioFilePath + "Wave.txt");
  
  String line;
  
  allValues = new FloatList();
  timeValues = new FloatList();
  
  try{
  line = reader.readLine();
  while (line != null) {
      String[] p = split(line, SEP);
      allValues.append(float(p[1]));
      timeValues.append(float(p[0]));
      line = reader.readLine();
    }
  }catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  
  timeVals = timeValues.array();
  
  allVals = allValues.array();

  // Set up the video exporting
  videoExport = new VideoExport(this);
  videoExport.setFrameRate(movieFPS);
  videoExport.setAudioFileName(audioFilePath);
  videoExport.setQuality(60, 192);
  videoExport.startMovie();
  
}

void draw(){
  
  

  
  
  if (lineCount >= timeVals.length) {
    // Done reading the file.
    // Close the video file.
    videoExport.endMovie();
    exit();
  } else {
    
    float soundTime = timeVals[lineCount];
    
    while (videoExport.getCurrentTime() < soundTime && lineCount < timeVals.length - bufferSize) {
      
      background(0);
      
      songPreview.display();
      
      noFill();
      
      
      
      for (int i = 0; i < 8; i++){
        
        //increment radius
        float radius = 30 + i*20;
        
        //draw each semi-circle
        for (int j = 0; j < 180; j++){
          
        //  stroke(250);
          
          float bufferVal = allVals[lineCount + j];
          float bufferVal2 = allVals[lineCount + j+1];
          
        //  float y1 = map(j, 0, bufferSize, width/2 - 150 , width/2 + 150 ) + 20;
        //float y2 = map(j+1, 0, bufferSize, width/2 - 150 , width/2 + 150 ) + 20;
        
        //  line( 100 + bufferVal*20,y1 , 100 + bufferVal2*20,  y2);
          
          //calculate coords
          float rad = (2*PI / 360) * j;
          
          float x = centerX + (radius + bufferVal*20) * cos(rad);
          float y = centerY + (radius + bufferVal*20) * -sin(rad);
          
          float rad2 = (2*PI / 360) * (j+1);
          
          float x2 = centerX + (radius + bufferVal2*20) * cos(rad2);
          float y2 = centerY + (radius + bufferVal2*20) * -sin(rad2);
          
          //draw line connecting x1 to x2
          //strokeWeight(3);
          
          //get color
          //colorMode(HSB, 360);
          //stroke(hues[i], 360, 360);
          blurLine(x, y, x2, y2, i, 360, 360, 0, 20, 1);
        }
      }
      videoExport.saveFrame();
      
     
      
    }
    
     lineCount += 1000;
  }
}


void blurLine(float x1, float y1, float x2, float y2, int hueI, float sat, float initialB, float finalB, int numThick, int initialSW){
  //get color
  colorMode(HSB, 360);
  stroke(hues[hueI], 360, 360);
  strokeCap(ROUND);
  
  
  //draw thickerLines
  for (int i = numThick-1; i >= 0; i--){
    float SW = initialSW + (pow(i,1.2))*((0.25));
    strokeWeight(SW);
    
    stroke(hues[hueI], 360, 360 - i*(360/numThick));
    
    line(x1, y1, x2, y2);
  }
  
  //draw main line
  strokeWeight(initialSW);
  line(x1, y1, x2, y2);
}

void keyPressed(){
  if (key == 'e' || key == 'p'){
    videoExport.endMovie();
    exit();
  }
  if (key == CODED){
    if (keyCode == RIGHT){
      println("right pressed: increase glow");
    }
    if (keyCode == LEFT){
      println("left pressed: decrease glow");
    }
  }
}



void audioToWaveFile(String fileName) {
  
  PrintWriter output; //print writer

  Minim minim = new Minim(this); //new minim
  
  output = createWriter(dataPath(fileName + "Wave.txt")); //text file for fft

  AudioSample track = minim.loadSample(fileName, 2048); //minim audioSample from song file loaded

  float sampleRate = track.sampleRate(); 


  float[] leftChannel = track.getChannel(AudioSample.LEFT);  //get channel left as samples L
  float[] rightChannel = track.getChannel(AudioSample.RIGHT);  



    
    for (int i=0; i<leftChannel.length; ++i) {
      output.println(nf(i / sampleRate, 0, 5 )+ "|" + leftChannel[i]);
    }
    
  
  track.close();
  output.flush();
  output.close();
  println("Sound Waveform analysis done");
}
