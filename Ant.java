package Project1;

/**
Ant.java 

A simple Ant object that can move in a GridWorld (a Repast Object2DGrid).
Note it implements the Repast Drawable interface, so that
it can be displayed via the Repast Object2DDisplay gui object,
and a ObjectInGrid, so it can be placed and move in that world.

*/

import java.awt.Color;
import java.awt.Point;
import java.util.Vector;
import java.awt.BasicStroke;

import uchicago.src.sim.gui.Drawable;
import uchicago.src.sim.gui.SimGraphics;
import uchicago.src.sim.space.Diffuse2D;
import uchicago.src.sim.gui.ColorMap;


public class Ant implements ObjectInGrid, Drawable {
	// "class" variables -- one value for all instances 
    public  static int          	nextId = 0; // to give each an id
	public  static TorusWorld    	world;  	// where the agents live
	public  static Model		   	model;      // the model "in charge"
	public  static Diffuse2D		pSpace;	    // where the pheromone is stored
	public  static GUIModel		    guiModel = null;   // the gui model "in charge"
    // we'll use this to draw a border around the bugs' cells (the f means float)
    public  static BasicStroke      bugEdgeStroke = new BasicStroke( 1.0f );
	
	// we use this to have Ant shades indicated their probRandMove
	public static ColorMap		 probRandMoveColorMap;
	public static final int      colorMapSize = 64;
	public static final double   colorMapMax =  colorMapSize - 1.0;
	
	// instance variables  
	public int 	   		id;			// unique id number for each ant instance
	public int 			x, y;		// cache the ant's x,y location
	public  double		probRandMove; // probability i'll  move randomly
	public Color		myColor;    // color of this agent
	public boolean carryFood;
	public int homeX, homeY; //the location of nest
public int direction;
	public int pheromoneSize = 100;
	
	// an Ant constructor
	// note it assigns ID values in sequence as ant's are created.
	public Ant ( ) {
		direction = (int)(Math.random()*8);
		id = nextId++;
		x = 0;		y = 0;
		probRandMove = 0.0;
		setInitialColor();
		carryFood = false;
	}
	public Ant (int tmpX, int tmpY ) {
		homeX = tmpX;
		homeY = tmpY;
		direction = (int)(Math.random()*8);
		id = nextId++;
		x = tmpX;		y = tmpY;
		probRandMove = 0.0;
		setInitialColor();
		carryFood = false;
	}
	public Point directionToVector(int tmpDirection){
		Point pt = new Point(1,0);
		if(tmpDirection == 0){
			pt = new Point(1,0);
		}
		if(tmpDirection == 1){
			pt = new Point(1,1);
		}
		if(tmpDirection == 2){
			pt = new Point(0,1);
		}
		if(tmpDirection == 3){
			pt = new Point(-1,1);
		}
		if(tmpDirection == 4){
			pt = new Point(-1,0);
		}
		if(tmpDirection == 5){
			pt = new Point(-1,-1);
		}
		if(tmpDirection == 6){
			pt = new Point(0,-1);
		}
		if(tmpDirection == 7){
			pt = new Point(1,-1);
		}
		return pt;
	}

	public void setInitialColor () {  // set agents initial color
		myColor = Color.blue;
	}
	public void setColor (Color color) {  // set agents initial color
		myColor = color;
	}

	////////////////////////////////////////////////////////////////////////////
	// setters and getters
	//
	public int getId() {  return id; }
	public int getX() { return x; }
	public void setX( int i ) { x = i; }
	public int getY() { return y; }
	public void setY( int i ) { y = i; }

	public double getProbRandMove() { return probRandMove; }
	// Note: setProbRandMove also sets the color!
	public void setProbRandMove( double d ) { 
		if ( d < 0.0 || d > 1.0 ) 
			System.err.printf("\nsetProbRandMove(%.3f): out of [0,1]!\n", d );
		else {
			probRandMove = d; 
			if ( guiModel != null ) {
				setBugColorFromPRM();
			}
		}
	}
	/**
	// setBugColorFromPRM - set color from from probRandMove
	// Note we map from [0,0.5] to full range of colors
	// anything over 0.5 is the same color - black!
	 */
	public void setBugColorFromPRM () {
	   	int i =  (int) Math.round( 2.0 * probRandMove * colorMapMax );
		i = (int) Math.min( i, colorMapMax );
	   	myColor = probRandMoveColorMap.getColor( i );
		if ( model.getRDebug() > 2 )
			System.out.printf( "setBugColorFromPRM: probRandMove %.3f -> i %d.\n",
							   probRandMove, i );
	}
	
	/**
	// setupBugDrawing
	// set the guiModel address, which we can test to see if in GUI mode
	// also set up a color map to map bug's probRandMove values to greenness
	// NOTE: more color at low end of map!
	 * 
	 * @param m
	 */
	public static void setupBugDrawing ( GUIModel m ) {
		guiModel = m;
		probRandMoveColorMap = new ColorMap ();
		for ( int i = 0; i < colorMapSize; i++ ) {
			// this one makes degress of blueness
			probRandMoveColorMap.mapColor ( (int) colorMapMax - i, 
			 0.0, 0.0, i / colorMapMax );

			// this one makes degrees of greenness
		//	probRandMoveColorMap.mapColor ( (int) colorMapMax - i, 
		//									0.0, i / colorMapMax, 0.0 );
		}
	}
	
	
	// note these are class (static) methods, to set class (static) variables
	public static void setWorld( TorusWorld w ) {	world = w; }
	public static void setModel( Model m ) { model = m; }
	public static void resetNextId() { nextId = 0; }  // call when we reset the model
	public static void setPSpace( Diffuse2D space ) {
		pSpace = space;
	}
	public static void setGUIModel( GUIModel m ) { guiModel = m; }

	// getDistanceToSource
	// just ask the model how far i am from the source.
	/*public double getDistanceToSource ( ) {
		return model.calcDistanceToSource( this );
	}*/

	// return the number of neighbors the bug has, at distance d
	@SuppressWarnings("unchecked")
	public int getNumberOfNeighbors( int d ) {
		Vector<Object> nbors = (Vector<Object>) world.getMooreNeighbors( x, y, d, d, false );
		return nbors.size();
	}
	public void searchFood(){
		if(model.removeFoodByCoordinate(x, y)){
			//if there is food
			direction = direction+4;
			direction = normalizeDirection(direction);
			randomDirection();
			carryFood = true;
			setColor(Color.RED);
		//	System.out.println("find food");
			
			Point vector = directionToVector(direction);
			setX((int)(x+vector.getX()));
			setY((int)(y+ vector.getY()));
		
		}
		else{
			//see if there is pheromone around
			//if there is pheromone, follow pheromone
			if(getDirectionByPheromone() != -1){
				direction = getDirectionByPheromone();
			}
/
			
			//if not random move
			if(reachBorder()){

				direction = direction+4;
				direction = normalizeDirection(direction);	
				randomDirection();
				Point vector = directionToVector(direction);
				
//				world.moveObjectTo( this, (int)(x+vector.getX()), (int)(y+ vector.getY()) );	
				setX((int)(x+vector.getX()));
				setY((int)(y+ vector.getY()));
			}
			else{
				randomDirection();
				Point vector = directionToVector(direction);
//			
				setX((int)(x+vector.getX()));
				setY((int)(y+ vector.getY()));
			}
		}

	}
	public void moveTowardHome(){
		if(x >= homeX -3 && x <= homeX +3 && y >=homeY-3 && y <= homeY+3){
		//	System.out.println("arrive home");
			//arrive home
			direction = direction+4;
			direction = normalizeDirection(direction);
			//move();
			carryFood = false;
			setColor(Color.BLUE);
			Point vector = directionToVector(direction);
	
			setX((int)(x+vector.getX()));
			setY((int)(y+ vector.getY()));
		}
		else{
		//	spreadPheronome(); // i do not think this was doing anything
			onWayHome();
		}
		
	}
	public void onWayHome(){
		direction = correctDirectionToHome();
		if(reachBorder()){
			direction = direction+4;
			direction = normalizeDirection(direction);			
			Point vector = directionToVector(direction);
			setX((int)(x+vector.getX()));
			setY((int)(y+ vector.getY()));
		}
		else{
			if(Math.random() < 0.5){
				randomDirection();
			}
			Point vector = directionToVector(direction);
			//check if it reaches the border of the world
			// if so 
			//if not
			setX((int)(x+vector.getX()));
			setY((int)(y+ vector.getY()));
		}
	}
	public boolean reachBorder(){
		Point vector = directionToVector(direction);
		if(x+vector.x >= world.getSizeX() || y+vector.y >= world.getSizeY() || x+vector.x <= 0 || y+vector.y <= 0){
			return true;
		}
		return false;
	}
	public int getDirection(){
		return direction;
	}
	public void setDirection(int tmpDirection){
		direction = tmpDirection;
	}
	public int normalizeDirection(int tmpDirection){
		if(tmpDirection < 0){
			tmpDirection = tmpDirection + 8;
		}
		if(tmpDirection > 7){
			tmpDirection = tmpDirection - 8;
		}
		return tmpDirection;
	}
	public void randomDirection(){
		direction = direction + (int)( Math.round(Math.random()*3))-1;
		direction = normalizeDirection(direction);
	}
		/* check if the ant is following the currect direction to home*/
	public int correctDirectionToHome(){
		int newDirection = direction;
		int tmpDistance = 1000;
		for(int directionModifier = -1; directionModifier <=1; directionModifier++){
			//check right, original, and left
			int tmpDirection = direction+directionModifier;
			tmpDirection = normalizeDirection(tmpDirection);
			Point vector = directionToVector(tmpDirection);
			if(tmpDistance >  Math.abs(x+(int)(vector.getX())-homeX)+Math.abs(y+(int)(vector.getY())-homeY)){
				tmpDistance = Math.abs(x+(int)(vector.getX())-homeX)+Math.abs(y+(int)(vector.getY())-homeY);
				newDirection = tmpDirection;
			}
		}		
		return newDirection;
	}
	/* check if the ant is following the currect direction to home*/
	public boolean correctDirectionToHome(int newDirection){
		int oldDistance = Math.abs(x-homeX)+Math.abs(y-homeY);
		Point vector = directionToVector(newDirection);
		int newDistance = Math.abs(x+(int)(vector.getX())-homeX)+Math.abs(y+(int)(vector.getY())-homeY);
		if(oldDistance > newDistance){
			return true;
		}
		else{
			return false;
		}
	}
	public int getDirectionByPheromone(){
		int newDirection = direction;
		double curPheromone = 0;
		//current location
		int tmpDirection;
		for(int directionModifier = -1; directionModifier <=1; directionModifier++){
			//check right, original, and left
			tmpDirection = direction+directionModifier;
			tmpDirection = normalizeDirection(tmpDirection);
			Point vector = directionToVector(tmpDirection);
			double nextPheromone = pSpace.getValueAt(x+vector.x,y+vector.y );
			if(nextPheromone > curPheromone){
				curPheromone = nextPheromone;
				newDirection = tmpDirection;
			}
		}
		if(curPheromone == 0){
			return -1;
		}
		else{
			return newDirection;
		}
	}	
	
	// have ants diffuse pheromone
	public void diffusePheromone() {
		if ( carryFood == true ) {
			double exogPheromone = 2.0 * (double) model.getMaxPher() *  model.getExogRate();
			double initPher = Math.min( exogPheromone, (double) model.getMaxPher() );
			pSpace.putValueAt( x, y, initPher );
		}
	}
	
	// add exogenous supply
	public void exogSupply() {
		if ( carryFood == true ) {
			double v = ((double) model.getMaxPher() * model.getExogRate()) + pSpace.getValueAt( x, y );
			v =  Math.min( v, (double) model.getMaxPher() );
			pSpace.putValueAt( x, y, v );
		}
	}

	/**
	// step
	// Top level definition of what the ant can do each time its activiated.
	// Currently it does is
	// - with probRandMove, move to random open adjacent cell
	// - check one randomly selected open neighbor cell, and
	//   if its got more pheromone than where the ant is now, move there
	// - otherwise call makeRandomMove() method.
	*/
	public void step () {

		if ( model.getRDebug() > 0 ) 
			System.err.printf( "   --Ant-step() for id=%d at x,y=%d,%d.\n",
						   id, x, y );
		if(carryFood){
			moveTowardHome();
		}
		else{
			searchFood();
		}
	}
	
	/**
	// printSelf
	// print ant fields to System.out.
	//
	*/
	public void printSelf ( ) {
		System.out.printf( " - Ant %2d (x,y=%d,%d; ) , prm %.2f\n",
				   id, x, y,  probRandMove );		
//		System.out.printf( " - Ant %2d (x,y=%d,%d; live=%b) age %2d, wt %5.2f, prm %.2f\n",
//						   id, x, y, live, age, weight, probRandMove );
	}

	/**
	// draw 
	// we implement Drawable interface, so we need this method
	// so that the ant can draw itself when requested  (by the GUI display).
	*/
    public void draw( SimGraphics g ) {
	   	g.drawFastRoundRect( myColor );
        g.drawRectBorder( bugEdgeStroke, Color.yellow );
    }


}
