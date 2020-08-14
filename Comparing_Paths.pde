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
    if(frameCount == 1) {
        drawnPath = IO.loadPath(sketchPath());
        renderPath(drawnPath); // Render the path so I can see how visually close my path is
    }
    
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
        
        if(!IO.savePath(currPath, sketchPath())) {
            exit(); // Exit if errors occurred in the saving process
        }
    } else if(mode == MODE_COMPARE_PATH) {
        // Compare drawn path to path saved on disk here
    }
    
    exit(); // Exit, we've done what we needed
}

void renderPath(ArrayList<PVector> path) {
    stroke(255);
    if(path.size() == 1) {
        point(path.get(0).x, path.get(0).y);
    } else {
        for(int i = 1; i < path.size(); i++) {
            PVector prev = path.get(i - 1);
            PVector curr = path.get(i);
            
            line(prev.x, prev.y, curr.x, curr.y);
        }
    }
    stroke(0);
}
