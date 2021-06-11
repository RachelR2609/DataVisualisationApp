//Global Variables
int stage; // variable to switch between pages (menu, map)
Table table;
PImage map;
float scale = 6; // initializing the scale variable to 6
float r = 45;
float rotx = PI/4; // rotation of 45 degree
float roty = PI/4;
float speed = 0.005;
float angle;

//variables used for paning up, down, left and right 
float panX;
float panY;
float panZ;

//Variables to filter out data 
boolean year1 = false;
boolean year2 = false;
boolean year3 = false;
boolean low = false;
boolean median = false;
boolean high = false;


void setup(){
  stage = 1;
  size(1700, 1500, P3D);
  table = loadTable("Data1.csv", "header"); // loading the Data1.csv file and noting the header
  map = loadImage("map.jpg");
}


void draw(){
  background(0);
  //display menu first
  //display map when 's' or 'r' is pressed
  if(stage ==1){
    menu();
   if(key == 's' || key == 'r'){
    stage = 2;
   }
  }
  
  if(stage == 2){
    setMap();
    pan(); 
    zoom();
 
  // return to menu when spacebar is pressed
  if(key ==' '){   
    stage =1;
  }
  
  //switching between data for each year 
  if (key == '1'){
    year1 = true;
    year2 = false;
    year3 = false;
    
  }
   if (year1){
    showData1991();
  }
  
  if (key == '2'){
    year1 = false;
    year2 = true;
    year3 = false;
  }
  
  if(year2){
    showData2001();
  }
  
  if (key == '3'){
    year1 = false;
    year2 = false;
    year3 =true;
  }
  
  if(year3){
     showData2011();
  }
  
  }
}



//creating menu
void menu(){
  fill(255);
  rect(300, 100, 1100, 1200);
  
  //Columns and rows of table
  strokeCap(SQUARE); 
  strokeWeight(6);   
  stroke(0);
  line(300, 300, 1400, 300); 
  line(700, 100, 700, 1300);
  strokeWeight(3); 
  line(300, 450, 1400, 450);
  line(300, 600, 1400, 600);
  line(300, 750, 1400, 750);
  line(300, 900, 1400, 900);
  line(300, 1050, 1400, 1050);
  line(300, 1200, 1400, 1200);
  
  //Title
  fill(0, 245, 205); 
  textSize (70);
  text("UK Population Map - Main Menu ",300,90);
  
  //Column headings 
   fill(0); 
   textSize (70);
   text("  Functions ",300,290);
   text("  Controls ",700,290);
  
  //functions
  textSize (64);
  text("  Pan ",300,440);
  text("  Zoom ",300,590);
  text("  Rotate ",300,740);
  text("  Switch  ",300,890);
  text("  Filter  ",300,1040);
  text("  Menu  ",300,1190);
  
  //Controls 
  textSize (32);
  text("  UP, DOWN, LEFT and RIGHT arrow keys ",700, 440);
  text("  PRESS down 'i' keys to zoom IN ",700, 550);
  text("  PRESS down 'o' keys to zoom OUT ",700, 590);
  text("  PRESS mouse DOWN and MOVE around ",700, 740);
  text("  PRESS '1' for 1991 ",700, 800);
  text("  PRESS '2' for 2001 ",700, 845);
  text("  PRESS '2' for 2001 ",700, 890);
  text("  PRESS 'h' for HIGH population ",700, 955);
  text("  PRESS 'm' for MEDIUM population ",700, 995);
  text("  PRESS 'l' for LOW population ",700, 1040);
  
  text("  PRESS spacebar ",700, 1190);  
  
  //menu 'Start' button
  menuButton(); 
}


//function to create menu buttons
void menuButton(){
  //start
  fill(234, 47, 141);
  rect(500, 1350, 300, 100, 7);
  fill(255);
  textSize (60);
  text("  Start(s) ",500, 1420);   
  
  //resume 
  fill(182,108,232);
  rect(900, 1350, 300, 100, 7);
  fill(255);
  textSize (60);
  text(" Resume(r) ",890, 1420); 
}

void setMap(){
  mapButtons();
  noStroke();
  camera(width/2.0 , height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0); // this is the default camera position 
  translate(width/2, height/2); // placing the map in the centre of the screen 
  translate(panX, panY, panZ);
  rotateX(rotx);
  rotateY(roty);
  scale(scale);     // increasing size of map depending on value of variable 'scale'
  drawBox();
}


// drawing a box around the map of UK
void drawBox(){
  beginShape(); 
  texture(map);
  vertex(-100, -100, 0, 0, 0);
  vertex(100, -100, 0, map.width, 0);
  vertex(100, 100, 0, map.width, map.height);
  vertex(-100, 100, 0, 0, map.height);
  endShape();
}

void mapButtons(){
  //1991
  stroke(100);
  strokeWeight(8);
  fill(27, 139, 119);
  rect(10, 10, 300, 100, 7);
  fill(255);
  textSize (64);
  text("   1991 ",10, 90); 
  
  //2001
  fill(209, 25, 25);
  rect(315, 10, 300, 100, 7);
  fill(255);
  textSize (64);
  text("   2001 ",315, 90); 
  
  //2011
  fill(25, 158, 209);
  rect(620, 10, 300, 100, 7);
  fill(255);
  textSize (64);
  text("   2011 ",620, 90); 
  
  //noStroke();
  stroke(245, 236, 168);
  //high
  fill(70);
  rect(965, 10, 240, 100, 7);
  fill(255);
  textSize (64);
  text("  HIGH ",965, 90);
  
  //medium
  fill(100);
  rect(1210, 10, 240, 100, 7);
  fill(255);
  textSize (64);
  text("   MED ",1210, 90);
  
  //low
  fill(150);
  rect(1455, 10, 240, 100, 7);
  fill(255);
  textSize (64);
  text("   LOW ",1455, 90);
}


//paning up, down, left and right using the arrow keys UP, DOWN, LEFT AND RIGHT respectively 
void pan(){
if(keyPressed && keyCode == UP){
  panY += 3;
  panZ += 3;
}

if(keyPressed && keyCode == DOWN){
  panY -= 3;
  panZ -= 3;
}

if(keyPressed && keyCode == LEFT){
  panX += 3;
}

if(keyPressed && keyCode == RIGHT){
  panX -= 3;
}
}


//zooming in and out using the 'i' and 'o' keys respectively 
void zoom(){
  if(keyPressed && key == 'i'){
    scale += 0.1;
  }
  
  if(keyPressed && key == 'o'){
    scale -= 0.1;
  }
}



//Controlling the rotating of the map using the mouse 
void mouseDragged(){
  rotx += (pmouseY-mouseY) * speed;
  roty += (mouseX-pmouseX) * speed;
}



void showData1991(){
  for(TableRow row : table.rows() ){
    
    //getting needed data from table 
    float lat = row.getFloat("lat");
    float lon = row.getFloat("lng");
    
    // Population in 1991
    String year1 = row.getString("1991");
    String [] year1Slpit = split(year1, ','); // splitting the population for 1991 using delimitter ','
    String year1Join = join(year1Slpit, "");  // joing the the values back up again but without the comma in between them 
    int year1991 = int(year1Join);            // converting the population values from string into int 
    
    
    
    //Sacling the logitude and latitude values to correct location on map
    double latx = lat * 10000 ;
    float lat2 = (float) latx;
    double lonx = lon * 10000  ;
    float lon2 = (float) lonx;
    
    //Converting degree to radians inside the loop
    float theta = radians(lat2);
    float phi = radians(lon2) + PI;

    
    //convert lat and lon into 3D x, y and z coordinates 
    
    float x = r * cos(theta) * cos(phi);     
    float y = -r * sin(theta);
    float z = -r * cos(theta) * sin(phi);
    
   
    //creation and display of bars to show population in 1991
    int a = year1991/(year1991-1);
    float h = pow(10, a);    
    float maxh = pow(10, 8);
    h = map(h, 0, maxh, 10, 100);
    
    
    //final creation of bars 
    pushMatrix();
    translate(x, y, z);
    fill(27, 139, 119);
    box(1, 1, h+50);
    popMatrix();
   
    // filtering out the lowest, medium and highest values for the year 1991
    int min = 81228;
    int mid = 146262;
    int max = 6715769;
    
    //low
    if (key == 'l'){
      low = true;
      median =false;
      high = false;
    }
    if (low && (year1991 == min) ){
    pushMatrix();
    translate(x, y, z);
    fill(150);
    box(1, 1, h+50);
    popMatrix();
      
    }
   
    //median
    if (key == 'm'){
      low = false;
      median =true;
      high = false;
    }
    if (median && (year1991 == mid)){
    pushMatrix();
    translate(x, y, z);
    fill(100);
    box(1, 1, h+50);
    popMatrix();
      
    }
    
     //high
    if (key == 'h'){
      low = false;
      median = false;
      high = true;
    }
    if (high && (year1991 == max)){
    pushMatrix();
    translate(x, y, z);
    fill(70);
    box(1, 1, h+50);
    popMatrix();
      
    }
    
  }
}

void showData2001(){
  for(TableRow row : table.rows() ){
    
    //getting needed data from table 
    float lat = row.getFloat("lat");
    float lon = row.getFloat("lng");
  
    
    //Poulation in 2001
    String year2 = row.getString("2001");
    String [] year2Split = split(year2, ','); // splitting the population for 2001 using delimitter ','
    String year2Join = join(year2Split, "");  // joing the the values back up again but without the comma in between them 
    int year2001 = int(year2Join);            // converting the population values from string into int
    
    
    
    //Sacling the logitude and latitude values to correct location on map
    double latx = lat * 10000  ;
    float lat2 = (float) latx;
    double lonx = lon * 10000  ;
    float lon2 = (float) lonx;
    
    //Converting degree to radians inside the loop
    float theta = radians(lat2);
    float phi = radians(lon2) + PI;

    
    //convert lat and lon into 3D x, y and z coordinates 
    
    float x = r * cos(theta) * cos(phi);    
    float y = -r * sin(theta);
    float z = -r * cos(theta) * sin(phi);
    
   
    //creation and display of bars to show population in 2001
    int b = year2001/(year2001-1);
    float h = pow(10, b);    
    float maxh = pow(10, 8);
    h = map(h, 0, maxh, 10, 100);
    
    
    //final creation of bars 
    pushMatrix();
    translate(x, y, z);
    fill(209, 25, 25);
    box(1, 1, h+50);
    popMatrix();
    
    // filtering out the lowest, medium and highest values for the year 2001
    int min = 92415;
    int mid = 145309;
    int max = 7208384;
    
    //low
    if (key == 'l'){
      low = true;
      median =false;
      high = false;
    }
    if (low && (year2001 == min) ){
    pushMatrix();
    translate(x, y, z);
    fill(150);
    box(1, 1, h+50);
    popMatrix();
      
    }
   
    //median
    if (key == 'm'){
      low = false;
      median =true;
      high = false;
    }
    if (median && (year2001 == mid)){
    pushMatrix();
    translate(x, y, z);
    fill(100);
    box(1, 1, h+50);
    popMatrix();
      
    }
    
     //high
    if (key == 'h'){
      low = false;
      median = false;
      high = true;
    }
    if (high && (year2001 == max)){
    pushMatrix();
    translate(x, y, z);
    fill(70);
    box(1, 1, h+50);
    popMatrix();
      
    }
    
  }
}

void showData2011(){
  for(TableRow row : table.rows() ){
    
    //getting needed data from table 
    float lat = row.getFloat("lat");
    float lon = row.getFloat("lng");
    
    
    //Population in 2011
    String year3 = row.getString("2011");
    String [] year3Split = split(year3, ','); // splitting the population for 2011 using delimitter ','
    String year3Join = join(year3Split, "");  // joing the the values back up again but without the comma in between them 
    int year2011 = int(year3Join);            // converting the population values from string into int
    
    
    
    //Sacling the logitude and latitude values to correct location on map
    double latx = lat * 10000 ;
    float lat2 = (float) latx;
    double lonx = lon * 10000  ;
    float lon2 = (float) lonx;
    
    
    //Converting degree to radians inside the loop
    float theta = radians(lat2);
    float phi = radians(lon2) + PI;

    
    //convert lat and lon into 3D x, y and z coordinates 
    
    float x = r * cos(theta) * cos(phi);    
    float y = -r * sin(theta);
    float z = -r * cos(theta) * sin(phi);
    
   
    
   
    //creation and display of bars to show population in 2011
    int c = year2011/(year2011-1);
    float h = pow(10, c);    
    float maxh = pow(10, 9);
    h = map(h, 0, maxh, 10, 100);
    
    
    //final creation of bars 
    pushMatrix();
    translate(x, y, z);
    fill(25, 158, 209);
    box(1, 1, h+50);
    popMatrix();
    
   
    // filtering out the lowest, medium and highest values for the year 2011
    int min = 100153;
    int mid = 160851;
    int max = 8250205;
    
    //low
    if (key == 'l'){
      low = true;
      median =false;
      high = false;
    }
    if (low && (year2011 == min) ){
    pushMatrix();
    translate(x, y, z);
    fill(150);
    box(1, 1, h+50);
    popMatrix();
      
    }
   
    //median
    if (key == 'm'){
      low = false;
      median =true;
      high = false;
    }
    if (median && (year2011 == mid)){
    pushMatrix();
    translate(x, y, z);
    fill(100);
    box(1, 1, h+50);
    popMatrix();
      
    }
    
     //high
    if (key == 'h'){
      low = false;
      median = false;
      high = true;
    }
    if (high && (year2011 == max)){
    pushMatrix();
    translate(x, y, z);
    fill(70);
    box(1, 1, h+50);
    popMatrix();
      
    }
    
  }
}
