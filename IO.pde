import java.io.File;
import java.io.FileWriter;
import java.io.FileNotFoundException;
import java.util.Scanner;

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
    
    static ArrayList<PVector> loadPath(String dir) {
        ArrayList<PVector> path = new ArrayList<PVector>();
        
        try {
            Scanner reader = new Scanner(new File(dir + "/path.csv"));
            
            while(reader.hasNextLine()) {
                String line = reader.nextLine();
                String[] vals = line.split(",");
                if(vals.length == 2) { // If the length is 2 - it won't be for the last line
                    int a = Integer.parseInt(vals[0]);
                    int b = Integer.parseInt(vals[1]);
                    path.add(new PVector(a, b));
                }
            }
            reader.close();
        } catch(FileNotFoundException e) {
            //e.printStackTrace(); // Don't bother reporting the error. We'll just return an empty ArrayList
        }
        
        return path;
    }
}
