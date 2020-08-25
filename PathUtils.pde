static class PathUtils {
    private final static float EPSILON = 0.001f;
    private static boolean SIMPLIFY_MADE_CHANGES = false;
    
    /**
     * This will compare the two paths, and return a float describing how similar they are (0 - 1, probably) (For now, I'm just going to return 1 or 0, similar or not similar)
     * First, I'm going to try the accepted answer here: https://stackoverflow.com/questions/36106581/compare-two-paths-for-similarity
     * Actually, a better approach is outlined vaguely here: https://stackoverflow.com/questions/63418337/comparing-2d-paths-for-similarity
     * Approach:
     * First, find bounding rectangles for both paths. It would probably be beneficial to simplify both paths beforehand
     * Then, find the scaling factor between the two rectangles - it may be different between height and width. Keep aspect ratio by expanding - like here: https://doc.qt.io/qt-5.9/qimage.html#scaled
     * Then, instead of positioning both paths so that they overlay as well as possible:
     * Find a series of equidistant points on both paths, and find the standard deviation of the distances between them - that way, if the path is identical but further away, then the standard deviation will be 0, otherwise > 0
     */
    static float comparePaths(ArrayList<PVector> path1, ArrayList<PVector> path2) {
        path1 = toVectors(path1);
        path2 = toVectors(path2);
        
        // This is the only time, ever, do...while has been useful to me
        // We want to do it at least once to check if the path has been simplified, and therefore may be able to undergo further simplification, so we loop until no further changes have been made
        do {
            path1 = simplifyVectorPath(path1);
        } while(SIMPLIFY_MADE_CHANGES);
        do {
            path2 = simplifyVectorPath(path2);
        } while(SIMPLIFY_MADE_CHANGES);
        
        float similarity = 1; // Start off assuming that the paths are equal
        
        if(abs(path1.size() - path2.size()) > 5) {
            // Take off some similarity if the paths don't now contain around about the same number of points
            similarity /= 2;
        }
        println("path1 size: " + path1.size() + ", path2 size: " + path2.size());
        
        // Calculate the scaling factor and pair up the vectors in the path and see if the vectors are similar
        
        return similarity; // TODO: Complete implementation of algorithm
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
        ArrayList<PVector> sp = new ArrayList<PVector>();
        boolean madeChanges = false;
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
        
        if(madeChanges) {
            SIMPLIFY_MADE_CHANGES = true;
        } else {
            SIMPLIFY_MADE_CHANGES = false;
        }
        
        return sp;
    }
    
    private static boolean floatEquals(float num1, float num2, float epsilon) { // Epsilon is basically the error margin - that is, the difference that is allowed
        return Math.abs(num1 - num2) < epsilon;
    }
    
    private static PVector fromPolar(float ang, float mag) {
        return new PVector((float)Math.cos(ang) * mag, (float)Math.sin(ang) * mag);
    }
    
    private static float scalingFactor(ArrayList<PVector> path1, ArrayList<PVector> path2) { // How to calculate the scaling factor? Taking the average magnitude of all the vectors and dividing one by the other might work
        return 0; // TODO: Actually do stuff here
    }
}
