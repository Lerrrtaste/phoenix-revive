///edgeds_set_scale(dpi mode, dpi override, minwidth, minheight, zoom);

/*
Scales the display to an arbitrary resolution in both directions based on display
or window size, optionally adjusting for DPI. Optionally can also limit resolution to 
a certain minimum and/or zoom the view in and out. Also can auto-zoom the view to attempt
to compensate for changes in display resolution, minimizing viewport differences between
resolutions.

Intended to be run in a dedicated display scaler object's Step event.

argument0 = enables or disables adjusting scale for the display's DPI settings (boolean) (true/false)
argument1 = forces a particular DPI setting to override the built-in settings (real) (optional, use 0 or -1 for none)
argument2 = minimum allowable display width, in pixels  (integer)
argument3 = minimum allowable display height, in pixels (integer)
argument4 = zoom multiplier for the scaling view, where 1 is 100% (real) (0 or -1 for auto);

Example usage: edgeds_set_scale(false, 0, 640, 640, 1);

NOTE: DO NOT use more than one edgeds_set_* script at once!
*/

/*
DPI MODE
*/

//DPI mode enabled
if argument0 == true {
   //Set DPI Override, if any
   if argument1 > 0 {
      global.display_dpi_current = argument1;
   } else {
      //Otherwise use OS-specific DPI
      global.display_dpi_current = global.display_dpi_os;
   }
} else {
   //DPI mode disabled
   global.display_dpi_current = global.display_dpi;
}

//Get final DPI
var dpi = global.display_dpi_current/global.display_dpi;


/*
DISPLAY SCALING
*/

//Detect scaling type
if os_browser == browser_not_a_browser {
   //Standard
   var window_width = window_get_width();
   var window_height = window_get_height();
} else {
   //HTML5
   var window_width = max(argument2, browser_width);
   var window_height = max(argument3, browser_height);
}

//All platforms
var display_width = max(1, argument2, window_width, window_width*(argument3/max(1,window_height)));
var display_height = max(1, argument3, window_height, window_height*(argument2/max(1,window_width)));

//Calculate display scale multiplier
global.display_xscale = display_width/global.display_wres;
global.display_yscale = display_height/global.display_hres;

//Detect orientation based on display size
if display_width >= display_height {
   global.display_orientation = 0; //0 = landscape
}
if display_width < display_height {
   global.display_orientation = 1; //1 = portrait
}

//Count down display scale grace period
if global.display_scale_time > 0 {
   global.display_scale_time -= 1;
}

//Scale the application
if global.display_xscale != global.display_xprevscale or global.display_yscale != global.display_yprevscale or global.display_zoom != argument4 {
   //Set grace period to propogate changes in display scale across all objects
   global.display_scale_time = 2;
   
   //Scale the view
   view_wview[global.display_view] = (display_width*dpi)/global.display_zoom;
   view_hview[global.display_view] = (display_height*dpi)/global.display_zoom;
   view_wport[global.display_view] = view_wview[global.display_view];
   view_hport[global.display_view] = view_hview[global.display_view];    
   
   //Resize window (HTML5 and windowed mode only)
   if os_browser == browser_not_a_browser {
      //Windowed mode
      if window_get_fullscreen() == false {
         window_set_size(min(display_width, display_width*(window_height/argument3)), min(display_height, display_height*(window_width/argument2)));     
      }
   } else {
      //HTML5
      window_set_size(min(display_width, display_width*(window_height/argument3)), min(display_height, display_height*(window_width/argument2)));     
   }   
   
   //Set zoom
   if argument4 > 0 {
      global.display_zoom = max(0.05,argument4);
   } else {
      //Auto zoom, if enabled
      global.display_zoom = ((display_width/global.display_wres) + (display_height/global.display_hres))*0.5;
   }
   
   //All platforms
   surface_resize(application_surface, min(window_width, display_width), min(window_height, display_height));
   display_set_gui_size(view_wport[global.display_view], view_hport[global.display_view]);   
}

//Record this step's scale as the next step's previous scale
global.display_xprevscale = global.display_xscale;
global.display_yprevscale = global.display_yscale;
