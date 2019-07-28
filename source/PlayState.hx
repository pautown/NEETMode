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

	public var name_text:FlxInputText = new FlxInputText(10,10,Std.int(FlxG.width/1.3),"name", 20);
	public var description_text:FlxInputText = new FlxInputText(10,10,Std.int(FlxG.width/1.3),"description", 20);
	public var type_text:FlxInputText = new FlxInputText(10,10,Std.int(FlxG.width/1.3),"type", 20);
	public var measurement_text:FlxInputText = new FlxInputText(10,10, 80,"measurement", 20);
	public var min_text:FlxInputText = new FlxInputText(10,10,40,"min", 20);
	public var max_text:FlxInputText = new FlxInputText(10,10,40,"max", 20);
	public var frequency_text:FlxInputText = new FlxInputText(10,10, 40,"frequency", 20);
	public var name_label = new flixel.text.FlxText(0,0, 0, "name:", 20);
	public var description_label = new flixel.text.FlxText(0,0, 0, "description:", 20);
	public var type_label = new flixel.text.FlxText(0,0, 0, "type:", 20);
	public var measurement_label = new flixel.text.FlxText(0,0, 0, "measurement:", 20);
	public var min_label = new flixel.text.FlxText(0,0, 0, "min:", 20);
	public var max_label = new flixel.text.FlxText(0,0, 0, "max:", 20);
	public var frequency_label = new flixel.text.FlxText(0,0, 0, "frequency:", 20);

	public var view_selected_generated_activity_label = new flixel.text.FlxText(0,0, 0, "frequency:", 20);
	public var view_selected_generated_activity_text:FlxInputText = new FlxInputText(10,10, 80,"measurement", 20);
	public var view_selected_generated_activity_button:FlxButton;


	public var new_activity_step_array:Array<String> = ["Enter Activity Name: ", "Enter Activity Description:", "Enter Activity Type, (t)ime or (r)ange: ", "Enter Activity Unit of Measure, eg 'minutes' or 'pages': ", "Enter Activity Min Amount: ", "Enter Activity Max Amount: ", "Enter Average Frequency Per Week (1-7) Activity Occurs: "];
	public var program_state:String = "new_activity";
	public var new_activity_selector:Int = 0;
	public var view_activity_selector:Int = 0;
	public var edit_activity_selector:Int = 0;

	var view_activity_selector_highlight_rectangle = new FlxSprite();
	var touch_start_flx_object:flixel.FlxObject = new flixel.FlxObject(0,0,0,0);
	var touch_start_flx_sprite:FlxSprite = new FlxSprite(0,0);
	var activity_save:FlxSave = new FlxSave();
	var new_activity_create_button:FlxButton;
	var edit_activity_edit_button:FlxButton;
	var total_activities_array:Array<Array<String>>;
	var generated_activities_array:Array<Array<String>> = [];
	var new_activity_array:Array<String>;
	var edit_activity_array:Array<String>;
	var view_activities_up_button:FlxButton;
	var menu_view_activities_button:FlxButton;
	var menu_new_activity_button:FlxButton;
	var menu_generate_activities_button:FlxButton;
	var menu_view_generated_activities_button:FlxButton;
	var view_activities_down_button:FlxButton;
	var view_activities_edit_button:FlxButton;
	var view_activities_delete_button:FlxButton;
	var activity_texts = new FlxTypedGroup<flixel.text.FlxText>(0);
	var activity_progress_bars = new FlxTypedGroup<flixel.FlxSprite>(0);
	var activity_index_to_edit:Int;
	public var announcement_label = new flixel.text.FlxText(0,0, 0, "frequency:", 20);
	var progress_bar_width:Int = 50;
	var progress_bar_height:Int = 10;

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
		
		view_selected_generated_activity_button = new FlxButton(50, 50, "Update", click_view_selected_generated_activity_button);
		menu_view_activities_button = new FlxButton(50, 50, "View Activities", click_menu_view_activities_btn);
		menu_new_activity_button = new FlxButton(50, 50, "New Activity", click_menu_new_activity_btn);
		menu_generate_activities_button = new FlxButton(50, 50, "Generate Activities", click_menu_generate_activities_btn);
		menu_view_generated_activities_button = new FlxButton(50, 50, "View Generated", click_menu_view_generated_activities_btn);
		new_activity_create_button = new FlxButton(50, 50, "Create", click_new_activity_create_btn);
		view_activities_edit_button = new FlxButton(50, 50, "Edit", click_view_activities_edit_btn);
		view_activities_delete_button = new FlxButton(50, 50, "Delete", click_view_activities_delete_btn);
		edit_activity_edit_button = new FlxButton(50, 50, "Save", click_edit_activity_edit_btn);
		add_create_new_activity_screen();
		//add_view_activities_screen();
		add_menu_buttons();
		flash_announcement_label("NEETmode");
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

		if(program_state == "view_generated_activities"){
			var updated_selector:Bool = true;
			if(input_up) view_activity_selector --;
			else if(input_down) view_activity_selector ++;
			else updated_selector = false;
			if (updated_selector) {
				if(view_activity_selector > generated_activities_array.length - 1) view_activity_selector = 0;	
				else if(view_activity_selector < 0) view_activity_selector = generated_activities_array.length - 1;
				update_view_activity_selector_highlight_rectangle();
			}
		}
	}

	public function add_menu_buttons():Void
	{
		add(menu_view_activities_button);
		add(menu_new_activity_button);
		add(menu_generate_activities_button);
		//add(menu_view_generated_activities_button);
		menu_new_activity_button.y = menu_view_activities_button.y = menu_generate_activities_button.y = menu_view_generated_activities_button.y = menu_button_y;
		menu_view_activities_button.x = menu_button_x_spacer;
		menu_new_activity_button.x = menu_view_activities_button.x + menu_view_activities_button.width + menu_button_x_spacer;
		menu_generate_activities_button.x = menu_new_activity_button.x + menu_new_activity_button.width + menu_button_x_spacer;
		menu_view_generated_activities_button.x = menu_generate_activities_button.x + menu_generate_activities_button.width + menu_button_x_spacer;
	}
	public function generate_generated_activities_array():Void
	{
		generated_activities_array = [];
		for (activity in total_activities_array)
		{
			if(FlxG.random.int(1, 7) <= Std.parseInt(activity[6])){
				generated_activities_array.push([activity.copy()[0],activity.copy()[1],activity.copy()[2],activity.copy()[3], "0", Std.string(FlxG.random.int(Std.parseInt(activity[4]), Std.parseInt(activity[5])))]);	
			} 
		}
	}
	public function click_menu_view_activities_btn():Void
	{
		remove_current_screen();
		add_view_activities_screen();
		program_state = "view_activities";
		flash_announcement_label("View Activities");
	}
	public function click_menu_new_activity_btn():Void
	{
		remove_current_screen();
		add_create_new_activity_screen();
		program_state = "new_activity";
		flash_announcement_label("New Activity");
	}

	public function click_new_activity_create_btn():Void
	{
		trace("create");
		total_activities_array.push([name_text.text,description_text.text,type_text.text,
			measurement_text.text,min_text.text,max_text.text,frequency_text.text]);
		new_activity_array = ["???","???","???","???","???","???","???"];
		activity_save.data.total_activities_array = total_activities_array; 
		activity_save.flush();
		flash_announcement_label("Activity Created");
	}

	public function click_view_activities_edit_btn():Void
	{
		remove_view_activities_screen();
		activity_index_to_edit = view_activity_selector;
		edit_activity_selector = 0;
		add_edit_activity_screen();
		program_state = "edit_activity";
		flash_announcement_label("Edit Activity " + Std.string(activity_index_to_edit));
	}
	public function click_edit_activity_edit_btn():Void
	{
		trace("edit");
		total_activities_array[activity_index_to_edit] = [name_text.text,description_text.text,type_text.text,
			measurement_text.text,min_text.text,max_text.text,frequency_text.text].copy();
		activity_save.data.total_activities_array = total_activities_array; 
		activity_save.flush();
		flash_announcement_label("Activity Saved");
	}
	public function update_view_activity_selector_highlight_rectangle():Void
	{
		view_activity_selector_highlight_rectangle.y = activity_texts.members[view_activity_selector].y;// - (activity_texts.members[view_activity_selector].height - update_view_activity_selector_highlight_rectangle.height)/2;
		if(program_state == "view_activities") view_activities_edit_button.y = view_activities_delete_button.y = view_activity_selector_highlight_rectangle.y;
		if(program_state == "view_generated_activities"){
			var activity = generated_activities_array[view_activity_selector];
			var activity_label =  activity[0] + " "+ activity[4] + "/" + activity[5] + " " + activity[3];  
			view_selected_generated_activity_label.text = activity_label;
			view_selected_generated_activity_text.text = activity[4];

		}
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
				text.x += 100;
				text.y += text.height/4;
				activity_texts.add(text);
				i ++;
		}
		add(view_activities_edit_button);
		add(view_activities_delete_button);
		view_selected_generated_activity_button.y = FlxG.height - view_selected_generated_activity_button.height - menu_button_y;
		view_selected_generated_activity_text.y = view_selected_generated_activity_button.y;
		view_selected_generated_activity_label.y = view_selected_generated_activity_button.y - view_selected_generated_activity_label.height - 15;
		view_selected_generated_activity_text.x = view_selected_generated_activity_label.x = menu_button_x_spacer;
		view_selected_generated_activity_button.x = view_selected_generated_activity_text.x + view_selected_generated_activity_text.width + menu_button_x_spacer;
		update_view_activity_selector_highlight_rectangle();
		view_activities_edit_button.y = view_activity_selector_highlight_rectangle.y;
		view_activities_edit_button.x = menu_button_x_spacer;
		view_activities_delete_button.y = view_activity_selector_highlight_rectangle.y;
		view_activities_delete_button.x = FlxG.width - view_activities_delete_button.width - menu_button_x_spacer;
	}
	public function add_view_generated_activities_screen():Void
	{
		for (text in activity_texts)
		{
			remove(text);
			activity_texts.remove(text);
		}
		for (progress_bar in activity_progress_bars)
		{
			remove(progress_bar);
			activity_progress_bars.remove(progress_bar);
		}
		add(view_activity_selector_highlight_rectangle);
		add(view_selected_generated_activity_label);
		add(view_selected_generated_activity_text);
		add(view_selected_generated_activity_button);
		view_activity_selector_highlight_rectangle.makeGraphic(FlxG.width, 18, FlxColor.BLUE, true);
		var i = 1;
		for (activity in generated_activities_array)
		{
//			["Name: ", "Description:", "Type", "Unit of Measure", "Min", "Max"];
				var activity_percentage = Std.string(Std.int(100*(Std.parseFloat(activity[4])/Std.parseFloat(activity[5]))));
		 		var activity_label =  activity_percentage + "% " + Std.string(i) + " " + activity[0] + " - " + activity[1] + " - " + activity[4] + "/" + activity[5] + " " + activity[3];  
				var text = new flixel.text.FlxText(10, menu_button_y + menu_view_activities_button.height + 15 * i, 0, Std.string(activity_label), 10);
				add(text);
				text.x += 100;
				text.y += text.height/4;
				activity_texts.add(text);
				i ++;
				trace( Std.string(Std.parseInt(activity[4])) + "/" +  Std.string(Std.parseInt(activity[5])));
				var progress_bar_back = new FlxSprite();
				progress_bar_back.makeGraphic(progress_bar_width, progress_bar_height, FlxColor.GRAY, true);
				add(progress_bar_back);
				progress_bar_back.x = text.x - progress_bar_back.width - menu_button_x_spacer;
				progress_bar_back.y = text.y + (view_activity_selector_highlight_rectangle.height - progress_bar_back.height)/2;

				var progress_bar_front = new FlxSprite();
				progress_bar_front.makeGraphic(1 + Std.int(progress_bar_width*(Std.parseInt(activity[4])/Std.parseInt(activity[5]))), Std.int(progress_bar_back.height), FlxColor.GREEN, true); 
				add(progress_bar_front);
				progress_bar_front.x = progress_bar_back.x;
				progress_bar_front.y = progress_bar_back.y;
				

				activity_progress_bars.add(progress_bar_back);
				activity_progress_bars.add(progress_bar_front);

		}
		//add(view_activities_edit_button);
		//view_activities_edit_button.y = view_activity_selector_highlight_rectangle.y;
		//view_activities_edit_button.x = menu_button_x_spacer;
		update_view_activity_selector_highlight_rectangle();
	}
	public function remove_view_activities_screen():Void
	{
		remove(view_activities_edit_button);
		remove(view_activities_delete_button);
		remove(view_activity_selector_highlight_rectangle);
		for (text in activity_texts)
		{
			remove(text);
			activity_texts.remove(text);
		}
	}
	public function remove_view_generated_activities_screen():Void
	{
		remove(view_activity_selector_highlight_rectangle);
		remove(view_selected_generated_activity_label);
		remove(view_selected_generated_activity_text);
		remove(view_selected_generated_activity_button);
		for (text in activity_texts)
		{
			remove(text);
			activity_texts.remove(text);
		}
		for (progress_bar in activity_progress_bars)
		{
			remove(progress_bar);
			activity_progress_bars.remove(progress_bar);
		}
	}
	public function add_edit_activity_screen():Void
	{
		edit_activity_array = total_activities_array[activity_index_to_edit].copy();
		//			["Name: ", "Description:", "Type", "Unit of Measure", "Min", "Max"];
		add(name_label);
		add(name_text);
		add(description_label);
		add(description_text);
		add(type_label);
		add(type_text);
		add(measurement_label);
		add(measurement_text);
		add(min_label);
		add(min_text);
		add(max_label);
		add(max_text);
		add(frequency_label);
		add(frequency_text);

		
		add(edit_activity_edit_button);

		name_text.text = edit_activity_array[0];
		description_text.text = edit_activity_array[1];
		type_text.text = edit_activity_array[2];
		measurement_text.text = edit_activity_array[3];
		min_text.text = edit_activity_array[4];
		max_text.text = edit_activity_array[5];
		frequency_text.text = edit_activity_array[6];

		name_label.y = menu_button_y + menu_view_activities_button.height + 15;
		name_text.y = name_label.y + name_label.height;
		description_label.y = name_text.y + name_text.height + 10;
		description_text.y = description_label.y + description_label.height;
		type_label.y = description_text.y + description_text.height + 10;
		type_text.y = type_label.y + type_label.height;
		measurement_label.y = type_text.y + type_text.height + 10;
		measurement_text.y = measurement_label.y + measurement_label.height;
		min_label.y = max_label.y = frequency_label.y = measurement_label.y;
		min_text.y = max_text.y = frequency_text.y = measurement_text.y;

		name_label.x = name_text.x = 10;
		description_label.x = description_text.x = type_label.x = type_text.x = measurement_label.x = measurement_text.x = name_label.x;
		min_label.x = min_text.x = measurement_label.x + measurement_label.width + menu_button_x_spacer;
		max_label.x = max_text.x = min_label.x + min_label.width + menu_button_x_spacer;
		frequency_label.x = frequency_text.x = max_label.x + max_label.width + menu_button_x_spacer;
		edit_activity_edit_button.y = FlxG.height - edit_activity_edit_button.height - 10;
	}
	public function add_create_new_activity_screen():Void
	{
		new_activity_array = ["???","???","???","???","???","???","???"];
		//			["Name: ", "Description:", "Type", "Unit of Measure", "Min", "Max"];
		add(name_label);
		add(name_text);
		add(description_label);
		add(description_text);
		add(type_label);
		add(type_text);
		add(measurement_label);
		add(measurement_text);
		add(min_label);
		add(min_text);
		add(max_label);
		add(max_text);
		add(frequency_label);
		add(frequency_text);

		
		add(new_activity_create_button);
		name_text.text = description_text.text = type_text.text = measurement_text.text = min_text.text = max_text.text = frequency_text.text = "";
		name_label.y = menu_button_y + menu_view_activities_button.height + 15;
		name_text.y = name_label.y + name_label.height;
		description_label.y = name_text.y + name_text.height + 10;
		description_text.y = description_label.y + description_label.height;
		type_label.y = description_text.y + description_text.height + 10;
		type_text.y = type_label.y + type_label.height;
		measurement_label.y = type_text.y + type_text.height + 10;
		measurement_text.y = measurement_label.y + measurement_label.height;
		min_label.y = max_label.y = frequency_label.y = measurement_label.y;
		min_text.y = max_text.y = frequency_text.y = measurement_text.y;

		name_label.x = name_text.x = 10;
		description_label.x = description_text.x = type_label.x = type_text.x = measurement_label.x = measurement_text.x = name_label.x;
		min_label.x = min_text.x = measurement_label.x + measurement_label.width + menu_button_x_spacer;
		max_label.x = max_text.x = min_label.x + min_label.width + menu_button_x_spacer;
		frequency_label.x = frequency_text.x = max_label.x + max_label.width + menu_button_x_spacer;
		new_activity_create_button.y = FlxG.height - new_activity_create_button.height - 10;
	}

	public function click_menu_generate_activities_btn():Void
	{
		if(generated_activities_array.length == 0){
			add(menu_view_generated_activities_button);
		}
		generate_generated_activities_array();
		flash_announcement_label("Daily Activities Generated");
	}

	public function click_menu_view_generated_activities_btn():Void
	{
		view_activity_selector = 0;
		remove_current_screen();
		add_view_generated_activities_screen();
		program_state = "view_generated_activities";
		flash_announcement_label("Generated Activities");
	}

	public function click_view_activities_delete_btn():Void {
		total_activities_array.splice(view_activity_selector,1);
		activity_save.data.total_activities_array = total_activities_array; 
		if(view_activity_selector >= total_activities_array.length) view_activity_selector = total_activities_array.length - 1;
		activity_save.flush();
		remove_view_activities_screen();
		add_view_activities_screen();
		flash_announcement_label("Deleted Activity");
	}

	public function click_view_selected_generated_activity_button():Void {

		var activity = generated_activities_array[view_activity_selector];
		activity[4] = view_selected_generated_activity_text.text;
		remove_view_generated_activities_screen();
		add_view_generated_activities_screen();

	}
	
	public function flash_announcement_label(message:String):Void {
		remove(announcement_label);
		announcement_label.alpha = 1;
		announcement_label.size = 3;
		announcement_label.text = message;
		while(announcement_label.width < FlxG.width*0.35) announcement_label.size += 3;
		announcement_label.x = FlxG.width/2 - announcement_label.width/2;
		announcement_label.y = FlxG.height - announcement_label.height - 15;
		announcement_label.fadeOut(0.69);
		add(announcement_label);

	}
	
	public function remove_edit_activity_screen():Void
	{
		remove(name_label);
		remove(name_text);
		remove(description_label);
		remove(description_text);
		remove(type_label);
		remove(type_text);
		remove(measurement_label);
		remove(measurement_text);
		remove(min_label);
		remove(min_text);
		remove(max_label);
		remove(max_text);
		remove(frequency_label);
		remove(frequency_text);
		remove(edit_activity_edit_button);
	}
	public function remove_create_new_activity_screen():Void
	{
		remove(name_label);
		remove(name_text);
		remove(description_label);
		remove(description_text);
		remove(type_label);
		remove(type_text);
		remove(measurement_label);
		remove(measurement_text);
		remove(min_label);
		remove(min_text);
		remove(max_label);
		remove(max_text);
		remove(frequency_label);
		remove(frequency_text);
		remove(new_activity_create_button);

	}

	public function remove_current_screen():Void {
		if(program_state == "view_activities") remove_view_activities_screen();
		else if(program_state == "edit_activity") remove_edit_activity_screen();
		else if(program_state == "new_activity") remove_create_new_activity_screen();
		else if(program_state == "view_generated_activities") remove_view_generated_activities_screen();
	}
	
}
