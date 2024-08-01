/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package journalapplication;
import java.awt.*;
import javax.swing.border.Border;
/**
 *
 * @author pranav
 */
public class StraightBorder implements Border{
    private int thickness;
    private Color color;

    public StraightBorder(int thickness, Color color) {
        this.thickness = thickness;
        this.color = color;
    }

    @Override
    public Insets getBorderInsets(Component c) {
        return new Insets(thickness, thickness, thickness, thickness);
    }

    @Override
    public boolean isBorderOpaque() {
        return true;
    }

    @Override
    public void paintBorder(Component c, Graphics g, int x, int y, int width, int height) {
        Graphics2D g2d = (Graphics2D) g;
        g2d.setColor(color);
        g2d.setStroke(new BasicStroke(thickness));
        g2d.drawRect(x + thickness / 2, y + thickness / 2, width - thickness, height - thickness);
    }
    
}
