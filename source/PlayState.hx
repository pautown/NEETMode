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
	public var view_activity_selector:Int = 0;

	var view_activity_selector_highlight_rectangle = new FlxSprite();
	var touch_start_flx_object:flixel.FlxObject = new flixel.FlxObject(0,0,0,0);
	var touch_start_flx_sprite:FlxSprite = new FlxSprite(0,0);
	var activity_save:FlxSave = new FlxSave();
	var new_activity_next_button:FlxButton;
	var new_activity_previous_button:FlxButton;
	var new_activity_create_button:FlxButton;
	var total_activities_array:Array<Array<String>>;
	var new_activity_array:Array<String>;
	var view_activities_up_button:FlxButton;
	var menu_view_activities_button:FlxButton;
	var menu_new_activity_button:FlxButton;
	var view_activities_down_button:FlxButton;
	var activity_texts = new FlxTypedGroup<flixel.text.FlxText>(0);

	var menu_button_y = 10;
	var menu_button_x_spacer = 10;
	override public function create():Void
	{
		super.create();
		trace("hello world");
		FlxG.mouse.useSystemCursor = true;
		activity_save.bind("NEETMode");
		total_activities_array = [];
		if (activity_save.data.total_activities_array == null){
			activity_save.data.total_activities_array = []; 
			activity_save.flush();
		}
		total_activities_array = activity_save.data.total_activities_array;
		menu_view_activities_button = new FlxButton(50, 50, "View Activities", click_menu_view_activities_btn);
		menu_new_activity_button = new FlxButton(50, 50, "New Activity", click_menu_new_activity_btn);
		new_activity_next_button = new FlxButton(50, 50, "Next", click_new_activity_next_btn);
		new_activity_previous_button = new FlxButton(50, 50, "Previous", click_new_activity_previous_btn);
		new_activity_create_button = new FlxButton(50, 50, "Create", click_new_activity_create_btn);
		add_create_new_activity_screen();
		//add_view_activities_screen();
		add_menu_buttons();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		var input_up = false;
		var input_down = false;
		var input_right = false;
		var input_left = false;
		var input_any = false;
	
		if (FlxG.keys.justPressed.LEFT)input_left = true;
		if (FlxG.keys.justPressed.RIGHT)input_right = true;
		if (FlxG.keys.justPressed.UP)input_up = true;
		if (FlxG.keys.justPressed.DOWN)input_down = true;
		if (input_left || input_right || input_up || input_down) input_any = true;
		

		if(program_state == "new_activity"){
			if(FlxG.keys.justPressed.ENTER) click_new_activity_next_btn();
		}
		if(program_state == "view_activities"){
			var updated_selector:Bool = true;
			if(input_up) view_activity_selector --;
			else if(input_down) view_activity_selector ++;
			else updated_selector = false;
			if (updated_selector) {
				if(view_activity_selector > total_activities_array.length - 1) view_activity_selector = 0;	
				else if(view_activity_selector < 0) view_activity_selector = total_activities_array.length - 1;
				update_view_activity_selector_highlight_rectangle();
			}
		}
	}

	public function add_menu_buttons():Void
	{
		add(menu_view_activities_button);
		add(menu_new_activity_button);
		menu_new_activity_button.y = menu_view_activities_button.y = menu_button_y;
		menu_view_activities_button.x = menu_button_x_spacer;
		menu_new_activity_button.x = menu_view_activities_button.x + menu_view_activities_button.width + menu_button_x_spacer;
	}
	public function click_menu_view_activities_btn():Void
	{
		if(program_state == "new_activity"){
			remove_create_new_activity_screen();
			add_view_activities_screen();
			program_state = "view_activities";
		}
	}
	public function click_menu_new_activity_btn():Void
	{
		if(program_state == "view_activities"){
			remove_view_activities_screen();
			add_create_new_activity_screen();
			program_state = "new_activity";
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
		input_text_label.text = new_activity_step_array[new_activity_selector] + " ("+ Std.string(new_activity_selector + 1) + "/" + Std.string(new_activity_step_array.length) + ")";
	}
	public function click_new_activity_previous_btn():Void
	{
		trace("previous");
		new_activity_array[new_activity_selector] = input_text.text;
		new_activity_selector --;
		update_new_activity_label();
		if(new_activity_selector < 0) new_activity_selector = new_activity_step_array.length - 1;
		input_text.text = new_activity_array[new_activity_selector];
		input_text_label.text = new_activity_step_array[new_activity_selector] + " ("+ Std.string(new_activity_selector + 1) + "/" + Std.string(new_activity_step_array.length) + ")";
	}
	public function click_new_activity_create_btn():Void
	{
		trace("create");
		total_activities_array.push(new_activity_array.copy());
		new_activity_array = ["???","???","???","???","???","???","???"];
		update_new_activity_label();
		activity_save.data.total_activities_array = total_activities_array; 
		activity_save.flush();
	}
	public function update_view_activity_selector_highlight_rectangle():Void
	{
		view_activity_selector_highlight_rectangle.y = activity_texts.members[view_activity_selector].y;// - (activity_texts.members[view_activity_selector].height - update_view_activity_selector_highlight_rectangle.height)/2;
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
	public function add_view_activities_screen():Void
	{
		add(view_activity_selector_highlight_rectangle);
		view_activity_selector_highlight_rectangle.makeGraphic(FlxG.width, 20, FlxColor.BLUE, true);
		var i = 1;
		for (activity in total_activities_array)
		{
				var text = new flixel.text.FlxText(10, menu_button_y + menu_view_activities_button.height + 15 * i, 0, Std.string(activity), 10);
				add(text);
				text.x += text.width/4;
				text.y += text.height/4;
				activity_texts.add(text);
				i ++;
		}
		update_view_activity_selector_highlight_rectangle();
	}
	public function remove_view_activities_screen():Void
	{
		remove(view_activity_selector_highlight_rectangle);
		for (text in activity_texts)
		{
			remove(text);
			activity_texts.remove(text);
		}
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
		input_text_label.y = menu_button_y + menu_view_activities_button.height + 15;
		input_text.y = input_text_label.y + input_text_label.height;
		new_activity_next_button.y = new_activity_previous_button.y = input_text.y + input_text.height + 10;
		new_activity_label.y = new_activity_next_button.y + new_activity_next_button.height + 10;
		new_activity_next_button.x = input_text.x + input_text.width - new_activity_next_button.width - 10;
		new_activity_previous_button.x = input_text.x + 10;
		new_activity_create_button.y = FlxG.height - new_activity_create_button.height - 10;
	}
	public function remove_create_new_activity_screen():Void
	{
		remove(input_text_label);
		remove(input_text);
		remove(new_activity_next_button);
		remove(new_activity_previous_button);
		remove(new_activity_create_button);
		remove(new_activity_label);
	}
}
