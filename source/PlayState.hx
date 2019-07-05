package;

import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.util.FlxSave;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{

	public var input_text:FlxInputText = new FlxInputText(10,10,Std.int(FlxG.width/1.3),"hehehe", 20);
	public var input_text_label = new flixel.text.FlxText(0,0, 0, "Title of task", 20);
	public var new_activity_label = new flixel.text.FlxText(0,0, 0, "Title of task", 20);
	public var new_activity_step_array:Array<String> = ["Enter Activity Name: ", "Enter Activity Description:", "Enter Activity Type, (t)ime or (r)ange: ", "Enter Activity Unit of Measure, eg 'minutes' or 'pages': ", "Enter Activity Min Amount: ", "Enter Activity Max Amount: ", "Enter Average Frequency Per Week (1-7) Activity Occurs: "];
	public var program_state:String = "new_activity";
	public var new_activity_selector:Int = 0;
	var touch_start_flx_object:flixel.FlxObject = new flixel.FlxObject(0,0,0,0);
	var touch_start_flx_sprite:FlxSprite = new FlxSprite(0,0);
	var activity_save:FlxSave = new FlxSave();
	var new_activity_next_button:FlxButton;
	var new_activity_previous_button:FlxButton;
	var new_activity_create_button:FlxButton;
	var total_activities_array:Array<Array<String>>;
	var new_activity_array:Array<String>;

	override public function create():Void
	{
		super.create();
		FlxG.mouse.useSystemCursor = true;
		activity_save.bind("NEETMode");
		if (activity_save.data.total_activities_array == null){
			activity_save.data.total_activities_array = []; 
			activity_save.flush();
		}
		total_activities_array = activity_save.data.total_activities_array;
		new_activity_next_button = new FlxButton(50, 50, "Next", click_new_activity_next_btn);
		new_activity_previous_button = new FlxButton(50, 50, "Previous", click_new_activity_previous_btn);
		new_activity_create_button = new FlxButton(50, 50, "Create", click_new_activity_create_btn);
		add_create_new_activity_screen();

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		var input_up = false;
		var input_down = false;
		var input_right = false;
		var input_left = false;
		var input_any = true;
		var swipe_angle = 0.0; 
		var swiped = false;
		// Swipe/Press logic
		if (FlxG.mouse.justPressed)
	    {
	        touch_start_flx_object.x = touch_start_flx_sprite.x = FlxG.mouse.x;
	        touch_start_flx_object.y = touch_start_flx_sprite.y = FlxG.mouse.y;
	    }

	    if (FlxG.mouse.justReleased && FlxMath.distanceToMouse(touch_start_flx_sprite) >= FlxG.width/20)
	    {
	        swipe_angle = FlxAngle.angleBetweenMouse(touch_start_flx_object, true);
	        swiped = true;
	    }
		
	    if(swiped && swipe_angle > -135 && swipe_angle < -45) input_up = true;
	    else if(swiped && swipe_angle > 45 && swipe_angle < 135) input_down = true;
	    else if(swiped && swipe_angle > -45 && swipe_angle < 45) input_right = true;
	    else if(swiped && ((swipe_angle <= -135 && swipe_angle >= -180) || (swipe_angle >= 135 && swipe_angle < 180))) input_left = true;
		
		if (FlxG.keys.justPressed.LEFT)input_left = true;
		if (FlxG.keys.justPressed.RIGHT)input_right = true;
		if (FlxG.keys.justPressed.UP)input_up = true;
		if (FlxG.keys.justPressed.DOWN)input_down = true;
		if (input_left || input_right || input_up || input_down) input_any = true;
		

		if(program_state == "new_activity"){
			//if(input_left) new_activity_selector --;
			if(FlxG.keys.justPressed.ENTER) click_new_activity_next_btn();
			if(input_any) input_text_label.text = new_activity_step_array[new_activity_selector] + " ("+ Std.string(new_activity_selector + 1) + "/" + Std.string(new_activity_step_array.length) + ")";
			/*if(new_activity_step_array[new_activity_selector] == "Tiny") grid_magnitude = 3;
			else if(new_activity_step_array[new_activity_selector] == "2x2") grid_magnitude = 2;
			else if(new_activity_step_array[new_activity_selector] == "1x1") grid_magnitude = 1;
			else if(new_activity_step_array[new_activity_selector] == "Large") grid_magnitude = 5;
			else grid_magnitude = 4;*/
		
		}
	}
	public function click_new_activity_next_btn():Void
	{
		trace("next");
		new_activity_array[new_activity_selector] = input_text.text;
		new_activity_selector ++;
		update_new_activity_label();
		if(new_activity_selector > new_activity_step_array.length - 1) new_activity_selector = 0;	
		input_text.text = new_activity_array[new_activity_selector];
	}
	public function click_new_activity_previous_btn():Void
	{
		trace("previous");
		new_activity_array[new_activity_selector] = input_text.text;
		new_activity_selector --;
		update_new_activity_label();
		if(new_activity_selector < 0) new_activity_selector = new_activity_step_array.length - 1;
		input_text.text = new_activity_array[new_activity_selector];
	}
	public function click_new_activity_create_btn():Void
	{
		trace("create");
		total_activities_array.push(new_activity_array.copy());
		new_activity_array = ["???","???","???","???","???","???","???"];
		update_new_activity_label();
	}
	public function update_new_activity_label():Void
	{
		new_activity_label.text = "Activity Name: " + new_activity_array[0] + "\n"
								+ "Activity Description: " + new_activity_array[1] + "\n"
								+ "Activity Type: " + new_activity_array[2] + "\n"
								+ "Activity Unit of Measure: " + new_activity_array[3] + "\n"
								+ "Activity Min: " + new_activity_array[4] + "\n"
								+ "Activity Max: " + new_activity_array[5] + "\n"
								+ "Activity Frequency: " + new_activity_array[6]
								+ "Total Activities: " + Std.string(total_activities_array.length);
	}
	public function add_create_new_activity_screen():Void
	{
		new_activity_array = ["???","???","???","???","???","???","???"];
		add(input_text_label);
		add(input_text);
		add(new_activity_next_button);
		add(new_activity_previous_button);
		add(new_activity_create_button);
		add(new_activity_label);
		input_text.y = input_text_label.y + input_text_label.height;
		new_activity_next_button.y = new_activity_previous_button.y = input_text.y + input_text.height + 10;
		new_activity_label.y = new_activity_next_button.y + new_activity_next_button.height + 10;
		new_activity_next_button.x = input_text.x + input_text.width - new_activity_next_button.width - 10;
		new_activity_previous_button.x = input_text.x + 10;
		new_activity_create_button.y = FlxG.height - new_activity_create_button.height - 10;
	}
}
