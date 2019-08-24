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
	public var frequency_text:FlxInputText = new FlxInputText(10,10, 40,"Frequency", 20);
	public var name_label = new flixel.text.FlxText(0,0, 0, "Name:", 15);
	public var description_label = new flixel.text.FlxText(0,0, 0, "Description:", 15);
	public var type_label = new flixel.text.FlxText(0,0, 0, "Type: ('m' for minutes, 'r' for range)", 15);
	public var measurement_label = new flixel.text.FlxText(0,0, 0, "Measurement:", 15);
	public var min_label = new flixel.text.FlxText(0,0, 0, "Min:", 15);
	public var max_label = new flixel.text.FlxText(0,0, 0, "Max:", 15);
	public var frequency_label = new flixel.text.FlxText(0,0, 0, "Avg freq (1-7):", 15);

	public var view_generated_activities_overview_current_label = new flixel.text.FlxText(0,0, 0, "CURRENT Activities Overview:", 10);
	public var view_generated_activities_overview_activities_label = new flixel.text.FlxText(0,0, 0, "0", 10);
	public var view_generated_activities_overview_time_label = new flixel.text.FlxText(0,0, 0, "0", 10);
	public var view_generated_activities_overview_total_label = new flixel.text.FlxText(0,0, 0, "0", 10);

	public var view_selected_generated_activity_label = new flixel.text.FlxText(0,0, 0, "frequency:", 20);
	public var view_selected_generated_activity_text:FlxInputText = new FlxInputText(10,10, 80,"measurement", 10);
	public var view_selected_generated_activity_button:FlxButton;
	public var view_selected_generated_activities_end_day_button:FlxButton;



	public var new_activity_step_array:Array<String> = ["Enter Activity Name: ", "Enter Activity Description:", "Enter Activity Type, (t)ime or (r)ange: ", "Enter Activity Unit of Measure, eg 'minutes' or 'pages': ", "Enter Activity Min Amount: ", "Enter Activity Max Amount: ", "Enter Average Frequency Per Week (1-7) Activity Occurs: "];
	public var program_state:String = "new_activity";
	public var new_activity_selector:Int = 0;
	public var view_activity_selector:Int = 0;
	public var edit_activity_selector:Int = 0;

	public var perfect_day:Bool;

	var view_activity_selector_highlight_rectangle = new FlxSprite();
	var touch_start_flx_object:flixel.FlxObject = new flixel.FlxObject(0,0,0,0);
	var touch_start_flx_sprite:FlxSprite = new FlxSprite(0,0);
	var activity_save:FlxSave = new FlxSave();
	var new_activity_create_button:FlxButton;
	var edit_activity_edit_button:FlxButton;

	var activities_total_complete:Int;
	var activities_total_incomplete:Int;
	var activities_current_streak:Int;
	var activities_record_streak:Int;
	var activities_perfect_days:Int;
	var activities_imperfect_days:Int;

	var total_activities_array:Array<Array<String>>;
	var generated_activities_array:Array<Array<String>> = [];
	var new_activity_array:Array<String>;
	var edit_activity_array:Array<String>;
	var view_activities_up_button:FlxButton;
	var menu_view_activities_button:FlxButton;
	var menu_new_activity_button:FlxButton;
	var menu_generate_activities_button:FlxButton;
	var menu_view_generated_activities_button:FlxButton;
	var menu_load_generated_activities_button:FlxButton;
	var view_activities_down_button:FlxButton;
	var view_activities_edit_button:FlxButton;
	var view_activities_delete_button:FlxButton;
	var activity_texts = new FlxTypedGroup<flixel.text.FlxText>(0);
	var activity_progress_bars = new FlxTypedGroup<flixel.FlxSprite>(0);
	var rectangle_outlines = new FlxTypedGroup<flixel.FlxSprite>(0);
	var activity_index_to_edit:Int;
	public var announcement_label = new flixel.text.FlxText(0,0, 0, "frequency:", 20);
	var progress_bar_width:Int = 50;
	var progress_bar_height:Int = 10;

	var menu_button_y = 10;
	var menu_button_x_spacer = 10;

	public var total_stats_complete_incomplete_label = new flixel.text.FlxText(0,0, 0, "frequency:", 10);
	public var total_stats_completion_rate_label = new flixel.text.FlxText(0,0, 0, "frequency:", 10);
	public var total_stats_streak_label = new flixel.text.FlxText(0,0, 0, "frequency:", 10);
	public var total_stats_perfect_imperfect_label = new flixel.text.FlxText(0,0, 0, "frequency:", 10);

	override public function create():Void
	{
		super.create();
		trace("hello world");
		FlxG.mouse.useSystemCursor = true;
		activity_save.bind("NEETMode");
		total_activities_array = [];
		if (activity_save.data.total_activities_array == null) activity_save.data.total_activities_array = []; 
		if (activity_save.data.generated_activities_array == null) activity_save.data.generated_activities_array = []; 
		if (activity_save.data.activities_total_complete == null) activity_save.data.activities_total_complete = 0;
		if (activity_save.data.activities_total_incomplete == null) activity_save.data.activities_total_incomplete = 0;
		if (activity_save.data.activities_current_streak == null) activity_save.data.activities_current_streak = 0;
		if (activity_save.data.activities_record_streak == null) activity_save.data.activities_record_streak = 0;
		if (activity_save.data.activities_perfect_days == null) activity_save.data.activities_perfect_days = 0;
		if (activity_save.data.activities_imperfect_days == null) activity_save.data.activities_imperfect_days = 0;
		activity_save.flush(); 

		load_persistant_stats();

		total_activities_array = activity_save.data.total_activities_array;
		
		view_selected_generated_activity_button = new FlxButton(50, 50, "Update", click_view_selected_generated_activity_button);
		view_selected_generated_activities_end_day_button = new FlxButton(50, 50, "Finish Day", click_view_selected_generated_activities_end_day_button);
		
		menu_view_activities_button = new FlxButton(50, 50, "View Activities", click_menu_view_activities_btn);
		menu_new_activity_button = new FlxButton(50, 50, "New Activity", click_menu_new_activity_btn);
		menu_generate_activities_button = new FlxButton(50, 50, "Generate Activities", click_menu_generate_activities_btn);
		menu_view_generated_activities_button = new FlxButton(50, 50, "View Generated", click_menu_view_generated_activities_btn);
		menu_load_generated_activities_button = new FlxButton(50, 50, "Load Generated", click_menu_load_generated_activities_btn);
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
		trace(activity_save.data.generated_activities_array);
		if(activity_save.data.generated_activities_array.length > 0) add(menu_load_generated_activities_button);
		menu_new_activity_button.y = menu_load_generated_activities_button.y = menu_view_activities_button.y = menu_generate_activities_button.y = menu_view_generated_activities_button.y = menu_button_y;
		menu_view_activities_button.x = menu_button_x_spacer;
		menu_new_activity_button.x = menu_view_activities_button.x + menu_view_activities_button.width + menu_button_x_spacer;
		menu_generate_activities_button.x = menu_new_activity_button.x + menu_new_activity_button.width + menu_button_x_spacer;
		menu_view_generated_activities_button.x = menu_generate_activities_button.x + menu_generate_activities_button.width + menu_button_x_spacer;
		menu_load_generated_activities_button.x = menu_generate_activities_button.x + menu_generate_activities_button.width + menu_button_x_spacer;
	}
	public function generate_generated_activities_array():Void
	{
		generated_activities_array = [];

		for (activity in total_activities_array)
		{
			if(FlxG.random.int(1, 7) <= Std.parseInt(activity[6])){
				generated_activities_array.push([activity.copy()[0],activity.copy()[1],activity.copy()[2],activity.copy()[3], "0", Std.string(FlxG.random.int(Std.parseInt(activity[4]), Std.parseInt(activity[5]))),"false"]);	
				activities_total_incomplete ++;
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
			var activity_label =  activity[0] + " " + activity[4] + "/" + activity[5] + " " + activity[3];  
			view_selected_generated_activity_label.text = activity_label;
			view_selected_generated_activity_text.text = activity[4];

		}
	}

	public function add_view_activities_screen():Void
	{
		add(view_activity_selector_highlight_rectangle);
		view_activity_selector_highlight_rectangle.makeGraphic(FlxG.width - menu_button_x_spacer*2, 20, FlxColor.BLUE, true);
		view_activity_selector_highlight_rectangle.x =menu_button_x_spacer;
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

		add(view_selected_generated_activities_end_day_button);

		view_selected_generated_activity_button.y = view_selected_generated_activities_end_day_button.y = FlxG.height - view_selected_generated_activity_button.height - menu_button_y;
		view_selected_generated_activity_text.y = view_selected_generated_activity_button.y;
		view_selected_generated_activity_label.y = view_selected_generated_activity_button.y - view_selected_generated_activity_label.height;
		view_selected_generated_activity_text.x = view_selected_generated_activity_label.x = 100 - progress_bar_width;
		view_selected_generated_activity_button.x = view_selected_generated_activity_text.x + view_selected_generated_activity_text.width + menu_button_x_spacer;
		
		view_selected_generated_activities_end_day_button.x = FlxG.width - view_selected_generated_activities_end_day_button.width - menu_button_x_spacer;

		var activities_total = generated_activities_array.length;
		var activities_completed = 0.00;
		var activities_percentage = 0.00;

		var activities_time_total = 0.00;
		var activities_time_max = 0.00;
		var activities_time_completed = 0.00;
		var activities_time_percentage = 0.00;

		var activities_range_total = 0.00;
		var activities_range_completed = 0.00;
		var activities_range_percentage = 0.00;


		view_activity_selector_highlight_rectangle.makeGraphic(FlxG.width - menu_button_x_spacer*2, 20, FlxColor.BLUE, true);
		view_activity_selector_highlight_rectangle.x =menu_button_x_spacer;
		var i = 1;
		for (activity in generated_activities_array)
		{
			if(Std.parseFloat(activity[4])/Std.parseFloat(activity[5]) == 1) activities_completed ++;
			activities_percentage += Std.parseFloat(activity[4])/Std.parseFloat(activity[5]);
			
			if(activity[2] == "t"){
				//activities_time_max ++;
				activities_time_total += Std.parseFloat(activity[5]);
				activities_time_completed +=  Std.parseFloat(activity[4]);
				activities_time_percentage += Std.parseFloat(activity[4])/Std.parseFloat(activity[5]);
			}
			if(activity[2] == "r"){
				activities_range_total ++;
				if(Std.parseFloat(activity[4])/Std.parseFloat(activity[5]) == 1) activities_range_completed ++;
				activities_range_percentage += Std.parseFloat(activity[4])/Std.parseFloat(activity[5]);
			}
//			["Name: ", "Description:", "Type", "Unit of Measure", "Min", "Max"];
			var activity_percentage = Std.string(Std.int(100*(Std.parseFloat(activity[4])/Std.parseFloat(activity[5]))));
	 		var activity_label =  activity_percentage + "% " + Std.string(i) + " " + activity[0] + " - " + activity[1] + " - " + activity[4] + "/" + activity[5] + " " + activity[3];  
			var text = new flixel.text.FlxText(menu_button_x_spacer, menu_button_y + menu_view_activities_button.height + 15 * i, 0, Std.string(activity_label), 10);
			add(text);
			text.x += 100;
			text.y += text.height/4;
			activity_texts.add(text);
			i ++;
			trace( Std.string(Std.parseInt(activity[4])) + "/" +  Std.string(Std.parseInt(activity[5])));

			create_progress_bar(text.x - progress_bar_width - menu_button_x_spacer, text.y + (view_activity_selector_highlight_rectangle.height - progress_bar_height)/2, Std.int(progress_bar_width*(Std.parseInt(activity[4])/Std.parseInt(activity[5]))));

		}
		activities_time_percentage = activities_time_completed/activities_time_total;
		activities_range_percentage = activities_range_completed/activities_range_total;
		activities_percentage = activities_percentage/activities_total;

		add_total_stats_overview(menu_button_x_spacer, view_selected_generated_activity_label.y);

 		add(view_generated_activities_overview_activities_label);
 		add(view_generated_activities_overview_current_label);
		add(view_generated_activities_overview_time_label);
		add(view_generated_activities_overview_total_label);

		view_generated_activities_overview_activities_label.x = view_generated_activities_overview_current_label.x = view_generated_activities_overview_time_label.x = view_generated_activities_overview_total_label.x  = view_selected_generated_activity_label.x + progress_bar_width + menu_button_x_spacer;
		view_generated_activities_overview_current_label.x -= progress_bar_width + menu_button_x_spacer;

		view_generated_activities_overview_total_label.y = view_selected_generated_activity_label.y - view_generated_activities_overview_total_label.height;
		view_generated_activities_overview_time_label.y = view_generated_activities_overview_total_label.y - view_generated_activities_overview_time_label.height;
		view_generated_activities_overview_activities_label.y = view_generated_activities_overview_time_label.y - view_generated_activities_overview_activities_label.height;
		view_generated_activities_overview_current_label.y = view_generated_activities_overview_activities_label.y - view_generated_activities_overview_current_label.height;

		view_generated_activities_overview_activities_label.text = Std.string(Std.int(activities_completed/activities_total*100)) + "% " + Std.string(activities_completed) + "/" + Std.string(activities_total) + " Activities";
		view_generated_activities_overview_time_label.text = Std.string(Std.int(activities_time_percentage*100)) + "% " + Std.string(Std.int(activities_time_percentage*activities_time_total)) + "/" + Std.string(activities_time_total) + " Minutes";
		view_generated_activities_overview_total_label.text = Std.string(Std.int(activities_percentage*100)) + "%";

		create_rectangle_outline(menu_button_x_spacer, menu_button_y + menu_view_generated_activities_button.height + menu_button_x_spacer, Std.int(FlxG.width - menu_button_x_spacer*2), Std.int(FlxG.height/1.7));

		create_rectangle_outline(view_generated_activities_overview_current_label.x - 2, view_generated_activities_overview_current_label.y - 2, Std.int(FlxG.width/2.5), Std.int(Std.int(total_stats_perfect_imperfect_label.y) + total_stats_perfect_imperfect_label.height - Std.int(total_stats_complete_incomplete_label.y) + 5));

		update_view_activity_selector_highlight_rectangle();

		create_progress_bar(view_generated_activities_overview_activities_label.x - progress_bar_width - menu_button_x_spacer, view_generated_activities_overview_activities_label.y, Std.int(activities_completed/activities_total*progress_bar_width));
		create_progress_bar(view_generated_activities_overview_time_label.x - progress_bar_width - menu_button_x_spacer, view_generated_activities_overview_time_label.y, Std.int(activities_time_percentage*progress_bar_width));
		create_progress_bar(view_generated_activities_overview_total_label.x - progress_bar_width - menu_button_x_spacer, view_generated_activities_overview_total_label.y, Std.int(activities_percentage*progress_bar_width));

		
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
		remove_total_stats_overview();
		remove(view_generated_activities_overview_activities_label);
		remove(view_generated_activities_overview_time_label);
		remove(view_generated_activities_overview_current_label);
		remove(view_generated_activities_overview_total_label);
		remove(view_activity_selector_highlight_rectangle);
		remove(view_selected_generated_activity_label);
		remove(view_selected_generated_activity_text);
		remove(view_selected_generated_activity_button);
		remove(view_selected_generated_activities_end_day_button);
		for (text in activity_texts)
		{
			remove(text);
			activity_texts.remove(text);
		}
		for (rect in rectangle_outlines)
		{
			remove(rect);
			rectangle_outlines.remove(rect);
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

	public function remove_total_stats_overview():Void {
		remove(total_stats_complete_incomplete_label);
		remove(total_stats_completion_rate_label);
		remove(total_stats_streak_label);
		remove(total_stats_perfect_imperfect_label);
	}

	public function add_total_stats_overview(bottom_x:Float, bottom_y:Float):Void {

		add(total_stats_complete_incomplete_label);
		add(total_stats_completion_rate_label);
		add(total_stats_streak_label);
		add(total_stats_perfect_imperfect_label);

		total_stats_complete_incomplete_label.x = total_stats_completion_rate_label.x = total_stats_streak_label.x = total_stats_perfect_imperfect_label.x = FlxG.width/2 + menu_button_x_spacer;

		total_stats_perfect_imperfect_label.y = bottom_y - total_stats_perfect_imperfect_label.height;
		total_stats_streak_label.y = total_stats_perfect_imperfect_label.y - total_stats_streak_label.height;
		total_stats_completion_rate_label.y = total_stats_streak_label.y - total_stats_completion_rate_label.height;
		total_stats_complete_incomplete_label.y = total_stats_completion_rate_label.y - total_stats_complete_incomplete_label.height;

		total_stats_complete_incomplete_label.text = "TOTAL Complete: " + Std.string(activities_total_complete) + ", Incomplete: "  + Std.string(activities_total_incomplete);
		total_stats_completion_rate_label.text = Std.string(Std.int(activities_total_complete/(activities_total_complete+activities_total_incomplete)*100)) +"% Completion Rate";
		total_stats_streak_label.text = "Streak: " + Std.string(activities_current_streak) + ", Record Streak " + Std.string(activities_record_streak);
		total_stats_perfect_imperfect_label.text = "TOTAL Perfect: " + Std.string(activities_perfect_days) + ", Imperfect: " + Std.string(activities_imperfect_days); 

		create_progress_bar(total_stats_completion_rate_label.x, total_stats_completion_rate_label.y, Std.int((activities_total_complete/(activities_total_complete+activities_total_incomplete))*progress_bar_width));
		total_stats_completion_rate_label.x += progress_bar_width + menu_button_x_spacer;

		create_rectangle_outline(total_stats_complete_incomplete_label.x - 2, total_stats_complete_incomplete_label.y - 2, Std.int(FlxG.width/2.5), Std.int(Std.int(total_stats_perfect_imperfect_label.y) + total_stats_perfect_imperfect_label.height - Std.int(total_stats_complete_incomplete_label.y) + 5));
	}
	
	public function click_menu_generate_activities_btn():Void
	{

		if(generated_activities_array.length == 0){
			remove(menu_load_generated_activities_button);
			add(menu_view_generated_activities_button);
		}
		generate_generated_activities_array();
		perfect_day = false;
		activities_imperfect_days ++;
		save_persistant_stats();
		flash_announcement_label("Daily Activities Generated");
	}

	public function click_menu_load_generated_activities_btn():Void
	{
		generated_activities_array = activity_save.data.generated_activities_array;
		remove(menu_load_generated_activities_button);
		add(menu_view_generated_activities_button);
		perfect_day = true;
		for(activity in generated_activities_array) if (activity[4] != activity[5]) perfect_day = false;
		save_persistant_stats();
		flash_announcement_label("Daily Activities Loaded");
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
	}

	public function click_view_selected_generated_activities_end_day_button():Void
	{
		remove(menu_view_generated_activities_button);
		remove_current_screen();
		add_view_activities_screen();
		program_state = "view_activities";
		flash_announcement_label("View Activities");
		if(!perfect_day) activities_current_streak = 0;
		if(activities_record_streak < activities_current_streak) activities_record_streak++;
		generated_activities_array = [];
		save_persistant_stats();
	
	}
	
	public function click_view_selected_generated_activity_button():Void {

		var activity = generated_activities_array[view_activity_selector];
		var old_activity_value = activity.copy()[4];
		activity[4] = view_selected_generated_activity_text.text;
		if (activity[4] != old_activity_value && activity[4] == activity[5]) {
			activities_total_incomplete --;
			activities_total_complete++;
			activity[7] = "true";
			if(!perfect_day)
			{
				perfect_day = true;
				for(activity in generated_activities_array) if (activity[4] != activity[5]) perfect_day = false;
			}
			if(perfect_day){
				activities_perfect_days ++;
				activities_current_streak ++;
				activities_imperfect_days --;
			} 
		}
		else if (activity[7] == "true" && activity[4] != activity[5])
		{
			activity[7] = "false";
			activities_total_incomplete ++;
			activities_total_complete --;
			if(perfect_day){
				perfect_day == false;
				activities_perfect_days --;
				activities_current_streak --;
				activities_imperfect_days ++;
			} 
		}
		save_persistant_stats();
		remove_view_generated_activities_screen();
		add_view_generated_activities_screen();

	}

	public function create_progress_bar(bar_x:Float, bar_y:Float, bar_value:Int):Void {
		var progress_bar_back = new FlxSprite();
		progress_bar_back.makeGraphic(progress_bar_width, progress_bar_height, FlxColor.GRAY, true);
		add(progress_bar_back);

		var progress_bar_front = new FlxSprite();
		progress_bar_front.makeGraphic(1 + bar_value, progress_bar_height, FlxColor.GREEN, true); 
		add(progress_bar_front);
		progress_bar_back.x = progress_bar_front.x = bar_x;
		progress_bar_back.y = progress_bar_front.y = bar_y;
		activity_progress_bars.add(progress_bar_back);
		activity_progress_bars.add(progress_bar_front);
	}

	public function create_rectangle_outline(rect_x, rect_y, rect_width, rect_height):Void {
		var lineStyle:LineStyle = { color: FlxColor.WHITE, thickness: 3 };
		var rectangle_outline:FlxSprite = new FlxSprite();
		var drawStyle:DrawStyle = { smoothing: false };
		add(rectangle_outline);
		rectangle_outline.makeGraphic(rect_width, rect_height, FlxColor.TRANSPARENT, true);
		rectangle_outline.drawRect(0, 0, rect_width, rect_height, FlxColor.TRANSPARENT, lineStyle, drawStyle);
		rectangle_outline.x = rect_x;
		rectangle_outline.y = rect_y;
		rectangle_outlines.add(rectangle_outline);
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

	public function load_persistant_stats():Void {
		total_activities_array = activity_save.data.total_activities_array;
		activities_total_complete = activity_save.data.activities_total_complete;
		activities_total_incomplete = activity_save.data.activities_total_incomplete;
		activities_current_streak = activity_save.data.activities_current_streak;
		activities_record_streak = activity_save.data.activities_record_streak;
		activities_perfect_days = activity_save.data.activities_perfect_days;
		activities_imperfect_days = activity_save.data.activities_imperfect_days;
	}

	public function save_persistant_stats():Void {
		activity_save.data.generated_activities_array = generated_activities_array;
		activity_save.data.total_activities_array = total_activities_array;
		activity_save.data.activities_total_complete = activities_total_complete;
		activity_save.data.activities_total_incomplete = activities_total_incomplete;
		activity_save.data.activities_current_streak = activities_current_streak;
		activity_save.data.activities_record_streak = activities_record_streak;
		activity_save.data.activities_perfect_days = activities_perfect_days;
		activity_save.data.activities_imperfect_days = activities_imperfect_days;
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
