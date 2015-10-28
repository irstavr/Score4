package Game;

import java.io.IOException;
import javax.swing.*;
 
public class Connect4 {
 
        /**
        * Program:  Connect4
        * @param args
        */     
 
        public static void main(String[] args) throws IOException, InterruptedException {
                Connect4JFrame frame = new Connect4JFrame();
                frame.setDefaultCloseOperation( JFrame.EXIT_ON_CLOSE);
                frame.setVisible(true);
        }
}
 
