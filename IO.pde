import java.io.*;

static class IO {
    // Return the exit status - false if errors occured, true if not
    static boolean savePath(ArrayList<PVector> path, String dir) { // dir specifies the directory to save the file in - I'm just going to use this to get the sketch path
        StringBuilder sb = new StringBuilder();
        for(PVector point : path) {
            sb.append((int)point.x + "," + (int)point.y + '\n');
        }
        String str = sb.toString();
        try {
            FileWriter file = new FileWriter(dir + "/path.csv"); // Save it as a CSV (Comma Separated Values) file
            file.write(str);
            file.close();
        } catch(IOException e) {
            e.printStackTrace();
            return false;
        }
        
        return true;
    }
}
