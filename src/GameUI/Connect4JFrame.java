package Game;

import java.awt.BorderLayout;
import java.awt.Button;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Label;
import static java.awt.Label.CENTER;
import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Timer;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;
import java.applet.*;
import java.net.*;

public final class Connect4JFrame extends JFrame implements ActionListener {

    private final Button btn1, btn2, btn3, btn4, btn5, btn6, btn7;
    private Label lblSpacer;
    Panel panel;
    int[][] Board;
    boolean end = false;
    int player = 1;
    int  winnerofgame=10;
    boolean Start;
    public static final int BLANK = 0;
    public static final int RED = 1;
    public static final int YELLOW = 2;
    public static final int NumRow = 6; 
    public static final int NumCol = 7;    
    Timer timer = new Timer();
    public static final String SPACE = "  ";
    int activeColour = RED;
    int wins = 0;
    PrintWriter filePredicates;
    PrintWriter fileMoves;

    public Connect4JFrame() throws IOException, InterruptedException {
        this.filePredicates = null;
        this.fileMoves = null;

        panel = new Panel();

        btn1 = new Button();
        MakeButton(btn1);

        btn2 = new Button();
        MakeButton(btn2);

        btn3 = new Button();
        MakeButton(btn3);

        btn4 = new Button();
        MakeButton(btn4);

        btn5 = new Button();
        MakeButton(btn5);

        btn6 = new Button();
        MakeButton(btn6);

        btn7 = new Button();
        MakeButton(btn7);

        add(panel, BorderLayout.NORTH);
        
        this.filePredicates = new PrintWriter(new FileWriter(System.getProperty("user.dir") + "/Input.lp"));
        this.fileMoves = new PrintWriter(new FileWriter(System.getProperty("user.dir") + "/BoardState.lp"));

        initialize();

        setSize(1024, 768); //size of window
    }

    public void initialize() throws IOException, InterruptedException {
        Board = new int[NumRow][NumCol];
        for (int row = 0; row < NumRow; row++) {
            for (int col = 0; col < NumCol; col++) {
                Board[row][col] = BLANK;
            }
        }
        Start = false;
    }

    @Override
    public void paint(Graphics g) {
        g.setColor(Color.BLUE);
        g.fillRect(110, 50, 100 + 100 * NumCol, 100 + 100 * NumRow);
        
        for (int row = 0; row < NumRow; row++) {
            for (int col = 0; col < NumCol; col++) {
                if (Board[row][col] == BLANK) {
                    g.setColor(Color.BLACK);
                }
                if (Board[row][col] == RED) {
                    g.setColor(Color.RED);
                }
                if (Board[row][col] == YELLOW) {
                    g.setColor(Color.YELLOW);
                }
                g.fillOval(160 + 100 * col, 100 + 100 * row, 100, 100);
            }
        }
        
        if (end) {
                System.out.println("end001");
                return;
        }
    }
    private void PlaySoundClick(){
        try {
            AudioClip clip = Applet.newAudioClip(
            new URL("file:/Users/Prodromos/NetBeansProjects/Score4/sound.wav"));
            clip.play();
        } catch (MalformedURLException murle) {
            System.out.println(murle);
        }
    }
    
    private void PlaySoundWinner(){
        try {
            AudioClip clip = Applet.newAudioClip(
            new URL("file:/Users/Prodromos/NetBeansProjects/Score4/winner.wav"));
            clip.play();
        } catch (MalformedURLException murle) {
            System.out.println(murle);
        }
    }
    
    private void PlaySoundOver(){
        try {
            AudioClip clip = Applet.newAudioClip(
            new URL("file:/Users/Prodromos/NetBeansProjects/Score4/over.wav"));
            clip.play();
        } catch (MalformedURLException murle) {
            System.out.println(murle);
        }
    }
    
    public void putDisk(int row, int col) throws IOException, InterruptedException {
        Start = true;
        //User -- RED -- player 1
        WritePredicates("inputLine("+col+").\n"+"player("+player+").\n"+ "enemy(2).");

        ExecuteCommandUser();
        row = ReadSelectedCellUser();

        PlaySoundClick();
        if (end) {
            System.out.println("end01");
            return;
        }
        Board[row][col] = activeColour;
        repaint();
        if (activeColour == RED) {
            activeColour = YELLOW;
            player = 2;
        } else {
            activeColour = RED;
            player = 1;
        }
        CheckForDisable();
        WriteAllLastMoves("taken("+player+","+row+","+col+").");

        if (end) {
            System.out.println("end123");
            return;
        }
        CallPcToPlay(row,col);
    }
    
    private void CallPcToPlay(int row, int col) throws InterruptedException, IOException {
        ExecuteCommandPC();
       
        int res[] = ReadSelectedCellPC();
        
        if (end) {
            System.out.println("end1");
            return;
        }
        row = res[0];
        col = res[1];

        Board[row][col] = activeColour;
        
        repaint();
        if (activeColour == RED) {
            activeColour = YELLOW;
            player = 2;
        } else {
            activeColour = RED;
            player = 1;
        }
        WriteAllLastMoves("taken("+player+","+row+","+col+").");
        PlaySoundClick();
        CheckForDisable();
        if (end) {
            System.out.println("end12");
        }  
    }


    private void DisableButton(int c, Button b){
        if (Board[0][c] != BLANK) {
            b.setBackground(null);
            b.setLabel("");
            b.disable();
        }
    }
    private void CheckForDisable(){
        DisableButton(0, btn1);
        DisableButton(1, btn2);
        DisableButton(2, btn3);
        DisableButton(3, btn4);
        DisableButton(4, btn5);
        DisableButton(5, btn6);
        DisableButton(6, btn7);
    }
    
    //Listener
    @Override
    public void actionPerformed(ActionEvent e) {
        try {            
            if (e.getSource() == btn1) {
               putDisk(-1, 0);
            } else if (e.getSource() == btn2) {
               putDisk(-1,1);
            } else if (e.getSource() == btn3) {
               putDisk(-1,2);
            } else if (e.getSource() == btn4) {
                putDisk(-1,3);
            } else if (e.getSource() == btn5) {
                putDisk(-1,4);
            } else if (e.getSource() == btn6) {
                putDisk(-1,5);
            } else if (e.getSource() == btn7) {
                putDisk(-1,6);
            }
        } // end ActionPerformed
        catch (IOException | InterruptedException ex) {
            Logger.getLogger(Connect4JFrame.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private void MakeButton(final Button b) {
        b.addActionListener(this);
        b.addMouseListener(new java.awt.event.MouseAdapter() {
            @Override
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                b.setBackground(Color.GREEN);
                b.setLabel("Here");
            }

            @Override
            public void mouseExited(java.awt.event.MouseEvent evt) {
                b.setBackground(null);
                b.setLabel("");
            }
        });
        panel.add(b);
        lblSpacer = new Label(SPACE);
        panel.add(lblSpacer);
    }

    private boolean WriteAllLastMoves(String s) throws IOException {
        try (PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("BoardState.lp", true)))) {
            out.println(s);
        } catch (IOException e) {
        }
        this.fileMoves.close();
        return true;
    }
    
    private boolean WritePredicates(String s) throws IOException {
        try (PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("Input.lp", false)))) {
            out.println(s);
        } catch (IOException e) {
        }
        this.filePredicates.close();

        return true;
    }

    private boolean ExecuteCommandPC() throws InterruptedException, IOException {
        try (PrintWriter runbat = new PrintWriter(new FileWriter(System.getProperty("user.dir") + "/run.sh"))) {
            runbat.write("./clingo Computer.lp DefenseComputer.lp ChooseMove.lp checkWinner.lp BoardState.lp 1 > selectedCellsPC.txt\n");
            runbat.write("exit \n");
        }
        try {
            Process p = Runtime.getRuntime().exec(new String(System.getProperty("user.dir") + "/run.sh"));
            p.waitFor();
        } catch (IOException e) {
        }
        return false;
    }
    
    private boolean ExecuteCommandUser() throws InterruptedException, IOException {
        try (PrintWriter runbat = new PrintWriter(new FileWriter(System.getProperty("user.dir") + "/run.sh"))) {
            runbat.write("./clingo Player.lp checkWinner.lp BoardState.lp Input.lp 1 > selectedCellsUser.txt\n");
            runbat.write("exit \n");
        }
        try {
            Process p = Runtime.getRuntime().exec(new String(System.getProperty("user.dir") + "/run.sh"));
            p.waitFor();
        } catch (IOException e) {
        }
        return false;
    }

    private int ReadSelectedCellUser() throws FileNotFoundException, IOException {
        BufferedReader bf = new BufferedReader(new FileReader("selectedCellsUser.txt"));
        String line;
        while ((line = bf.readLine()) != null) {
            if (line.startsWith("showLine")) {
                return Integer.parseInt(line.charAt(9)+"");
            } else if (line.startsWith("winner(")) {
                end = true;
                System.out.println("winner pc");
                DisplayWinner("Game Over you lost!!!", Color.YELLOW); 
                PlaySoundOver();
            }
        }
        bf.close();
        return 0;
    }
    
    //Pc YELLOW
    private int[] ReadSelectedCellPC() throws FileNotFoundException, IOException {
        BufferedReader bf = new BufferedReader(new FileReader("selectedCellsPC.txt"));
        String line;
        int vals[] = new int[2];

        while ((line = bf.readLine()) != null) {
            if (line.startsWith("play")) {
                int row = Integer.parseInt(line.charAt(5)+"");
                int col = Integer.parseInt(line.charAt(7)+"");
                vals[0] = row;
                vals[1] = col;
                return vals;
            } else if (line.startsWith("winner(")) {
                end = true;
                System.out.println("winner user");
                DisplayWinner("Congratulations you won!!!",Color.RED);  
                PlaySoundWinner();
            }
        }
        bf.close();
        return vals;
    }
    
    
    private void DisplayWinner(String mes, Color c){
        JFrame frame = new JFrame("Display Winner");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        
        final Label label = new Label(mes);
        label.setAlignment(CENTER);
        label.setBackground(Color.darkGray);
        label.setForeground(c);
        label.setFont(new java.awt.Font("Times New Roman", 1, 48));
        frame.add(label, BorderLayout.CENTER);
        frame.setSize(700, 200);
        frame.setBackground(Color.blue);
        frame.setVisible(true);
        end = true;
      }    

    
}


