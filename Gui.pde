

public class Gui  {
	
	public ControlP5 c5;
	public int x;
	public int y;
	public ControlFont font;
	public Slider s1;
	public Textfield name;

	
	public Gui (ControlP5 c5, int x, int y, PFont font) {

		this.x = x;
		this.y = y;
		this.font = new ControlFont(font);
		this.c5 = c5;
		
		c5.setColorBackground(d2).setColorForeground(m2).setColorActive(h2); // add .setFont(font); whith a 10 pix font
		c5.addButton("startStop")
		.setPosition(this.x, this.y).setSize(90,10);
		c5.addButton("export")
		.setPosition(this.x + 100, this.y).setSize(90,10);
		c5.addButton("screenshot")
		.setPosition(this.x + 200, this.y).setSize(90,10);


		s1 = c5.addSlider("diagScale", 20, 200, diagScale,this.x, this.y+18,263,10).setLabel("scale").setColorCaptionLabel(color(0));

		name = c5.addTextfield("textinput")
		.setPosition((width-x-300)/2, (height-y-30)/2)
		.setSize(300, 30)
		.setFont(font)
		.setColorCaptionLabel(color(bg))
		//.setLabel("Type your name");
        .setFocus(true);

        c5.setAutoDraw(false);



    }

    public void draw(){

    	c5.draw();

    }

}

void controlEvent(ControlEvent theEvent) {
		// println("Got a ControlEvent for "+theEvent.name()+" = "+theEvent.value()); // checks if there is an event
		if (theEvent.isAssignableFrom(Textfield.class)) {
			Textfield t = (Textfield)theEvent.getController();
			user = t.stringValue();
			user.toUpperCase();
			nameInput = false;
			gui.name.hide();
		}
	}

	public void startStop(int theValue) {
 	 //println("a button event from start: "+theValue);
 	 stopDrawing = !stopDrawing;
 	}

 	public void screenshot(int theValue) {
 	 // println("a button event from stop: "+theValue);
 	 saveImg();
 	}

 	public void export(int theValue) {
 	 //println("a button event from export: "+theValue);
 	 exportData(experiment);
 	}




