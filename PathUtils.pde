import java.awt.Rectangle;

static class PathUtils {
    private final static float EPSILON = 0.001f;
    
    /**
     * This will compare the two paths, and return a float describing how similar they are (0 - 1, probably) (For now, I'm just going to return 1 or 0, similar or not similar)
     * Actually, a better approach is outlined vaguely here: https://stackoverflow.com/questions/63418337/comparing-2d-paths-for-similarity
     * Approach:
     * First, find bounding rectangles for both paths. It would probably be beneficial to simplify both paths beforehand
     * Then, find the scaling factor between the two rectangles - it may be different between height and width. Keep aspect ratio by expanding - like here: https://doc.qt.io/qt-5.9/qimage.html#scaled
     * Then, instead of positioning both paths so that they overlay as well as possible:
     * Find a series of equidistant points on both paths, and find the standard deviation of the horizontal and vertical differences between them - that way, if the path is identical but further away, then the standard deviation will be 0, otherwise > 0
     */
    static float comparePaths(ArrayList<PVector> path1, ArrayList<PVector> path2) {
        ArrayList<PVector> vecPath1 = toVectors(path1);
        ArrayList<PVector> vecPath2 = toVectors(path2);
        
        // This is the only time, ever, do...while has been useful to me
        // We want to do it at least once to check if the path has been simplified, and therefore may be able to undergo further simplification, so we loop until no further changes have been made
        vecPath1 = simplifyVectorPath(vecPath1);
        vecPath2 = simplifyVectorPath(vecPath2);
                
        // The bounding rectangles of the paths
        Rectangle pRect1 = boundingRect(path1);
        Rectangle pRect2 = boundingRect(path2);
        
        return 0; // TODO: Complete implementation of algorithm
    }
    
    // Turns an array of points to an array of vectors pointing through the points
    private static ArrayList<PVector> toVectors(ArrayList<PVector> points) {
        ArrayList<PVector> path = new ArrayList<PVector>();
        
        for(int i = 0; i < points.size() - 1; i++) {
            PVector vec = toPoint(points.get(i), points.get(i + 1));
            path.add(vec);
        }
        
        return path;
    }
    
    // Just a method to help readability
    private static PVector toPoint(PVector a, PVector b) {
        return b.sub(a);
    }
    
    // Merges consecutive vectors with similar angles
    private static ArrayList<PVector> simplifyVectorPath(ArrayList<PVector> path) {
        boolean madeChanges = false;
        do {
            madeChanges = false;
            ArrayList<PVector> sp = new ArrayList<PVector>();
            for(int i = 0; i < path.size() - 1; i++) {
                PVector curr = path.get(i);
                PVector next = path.get(i + 1);
                
                // If the two angles for these consecutive vectors are roughly equal, then combine them into one
                if(floatEquals(curr.heading(), next.heading(), EPSILON)) {
                    float mag = curr.mag() + next.mag();
                    float ang = lerp(curr.heading(), next.heading(), 0.5f); // Get halfway between the 2 angles, just to mitigate that error margin, epsilon
                    PVector vec = fromPolar(ang, mag);
                    sp.add(vec);
                    madeChanges = true; // Can't return multiple values easily, this is quicker to implement
                } else { // Otherwise don't change anything
                    sp.add(curr);
                }
            }
            path = sp;
        } while(madeChanges);
        
        return path;
    }
    
    private static boolean floatEquals(float num1, float num2, float epsilon) { // Epsilon is basically the error margin - that is, the difference that is allowed
        return Math.abs(num1 - num2) < epsilon;
    }
    
    private static PVector fromPolar(float ang, float mag) {
        return new PVector((float)Math.cos(ang) * mag, (float)Math.sin(ang) * mag);
    }
    
    /**
     * This method requires ArrayLists of POINTS, not VECTORS
     */
    private static Rectangle boundingRect(ArrayList<PVector> path) {
        // The upper left corner of the rectangle
        int x1 = int(path.get(0).x);
        int y1 = int(path.get(0).y);
        
        // The lower right corner of the rectangle
        int x2 = x1;
        int y2 = y1;
        
        for(int i = 0; i < path.size(); i++) {
            PVector v = path.get(i);
            if(v.x < x1) {
                x1 = int(v.x);
            }
            if(v.y < y1 ) {
                y1 = int(v.y);
            }
            if(v.x > x2) {
                x2 = int(v.x);
            }
            if(v.y > y2) {
                y2 = int(v.y);
            }
        }
        
        // A -> B = B - A
        int w = x2 - x1;
        int h = y2 - y1;
        
        return new Rectangle(x1, y1, w, h);
    }
}
