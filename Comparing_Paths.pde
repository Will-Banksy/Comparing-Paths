// Comparing Paths

// Potentially useful link: https://stackoverflow.com/questions/36106581/compare-two-paths-for-similarity

boolean drawing = false; // Whether we have our mouse down and we're drawing a path

ArrayList<PVector> currPath = new ArrayList<PVector>();
ArrayList<PVector> drawnPath = null; // The path that we're going to be comparing against (if the mode is MODE_COMPARE_PATH)

boolean mode = true; // Which mode we're on
final boolean MODE_NEW_PATH = true;
final boolean MODE_COMPARE_PATH = false;

void setup() {
    size(600, 600);
    background(128);
    stroke(0);
}

void draw() {
    if(drawing) {
        currPath.add(new PVector(mouseX, mouseY));
        
        line(mouseX, mouseY, pmouseX, pmouseY); // Provide visual feedback
    }
}

void mousePressed() {
    if(drawing) { // If we've pressed a mouse button again, before releasing one, print error message and exit. I don't want to try handle that
        println("Please don't press two buttons at once - this is a strictly one-button-at-a-time sort of program");
        exit();
    }
    
    if(mouseButton == LEFT) { // Choose mode based on mouse button
        mode = MODE_NEW_PATH;
        drawing = true;
    } else if(mouseButton == RIGHT) {
        mode = MODE_COMPARE_PATH;
        drawing = true;
    }
}

void mouseReleased() {
    if(mode == MODE_NEW_PATH) {
        // Save path to file here
        IO.savePath(currPath, sketchPath());
    } else if(mode == MODE_COMPARE_PATH) {
        // Compare drawn path to path saved on disk here
    }
    
    exit(); // Exit, we've done what we needed
}
