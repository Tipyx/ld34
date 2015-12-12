package;

/**
 * ...
 * @author Tipyx
 */

typedef Behaviour = {
	var priority		: Int;
	var idGroup			: String;
	var cond			: Void->Bool;
	var speed			: Float;
}
 
class ASprite extends h2d.Anim {
	
	var ts				: h2d.TileSheet;
	
	var arBehaviour		: Array<Behaviour>;
	
	var actualBehav		: Behaviour;
	
	var isPaused		: Bool;
	
	var baseSpeed		: Float;
	
	public var wid(get, null)	: Int;
	public var hei(get, null)	: Int;

	public function new(ts:h2d.TileSheet, defaultGroup:String) {
		arBehaviour = [];
		actualBehav = null;
		isPaused = false;
		
		this.ts = ts;
		
		super(ts.getGroup(defaultGroup));
		
		baseSpeed = speed;
	}
	
	/**
	 * TODO
	 * @param	priority (1 has a higher priority than 0)
	 * @param	idGroup
	 * @param	cond
	 * @param	newSpeed
	 */
	public function addBehaviour(priority:Int, idGroup:String, cond:Void->Bool, ?newSpeed:Null<Float>) {
		for (b in arBehaviour)
			if (b.idGroup == idGroup)
				return;
				
		arBehaviour.push( { priority:priority, idGroup:idGroup, cond:cond, speed:newSpeed == null ? baseSpeed : newSpeed } );
		
		arBehaviour.sort(function(b1, b2) {
			return b2.priority - b1.priority;
		});
	}
	
	function changeAnim(b:Behaviour) {
		actualBehav = b;
		
		if (!isPaused)
			speed = b.speed;
		
		play(ts.getGroup(b.idGroup));
	}
	
	public function resumeAnim() {
		if (actualBehav != null)
			speed = actualBehav.speed;
		else
			speed = baseSpeed;
	}
	
	public function pauseAnim() {
		speed = 0;
	}
	
	public function togglePauseAnim() {
		isPaused = !isPaused;
		
		if (isPaused)
			speed = 0;
		else {
			if (actualBehav != null)
				speed = actualBehav.speed;
			else
				speed = baseSpeed;
		}
	}
	
	public function setGeneralSpeed(newSpeed:Float) {
		baseSpeed = newSpeed;
		
		if (!isPaused)
			speed = baseSpeed;
	}
	
	public function setCurrentBehavSpeed(newSpeed:Float) {
		if (actualBehav == null)
			throw "There is no behaviour running actually";
		
		actualBehav.speed = newSpeed;
		
		if (!isPaused)
			speed = actualBehav.speed;
	}
	
	public function update() {
		for (b in arBehaviour) {
			if (b.cond()) {
				if (b != actualBehav) {
					changeAnim(b);
				}
				break;
			}
		}
	}
	
	function get_wid():Int {
		var currentTile = getFrame();
		return currentTile.width + currentTile.dx;
	}
	
	function get_hei():Int {
		var currentTile = getFrame();
		return currentTile.height + currentTile.dy;
	}
}