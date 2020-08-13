// Comparing Paths

// Potentially useful link: https://stackoverflow.com/questions/36106581/compare-two-paths-for-similarity

boolean drawing = false; // Whether we have our mouse down and we're drawing a path

ArrayList<PVector> currPath = new ArrayList<PVector>();
ArrayList<PVector> drawnPath = null;

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
        
        line(mouseX, mouseY, pmouseX, pmouseY);
    }
}
