///edgeds_init_scale(view);

/*
Initializes a dedicated display scaler object, setting the view which is to 
be scaled and used to retrieve dimensions from as the base resolution of the 
game. Note that base resolution is defined by the input view's **port**.

Intended to be run in a dedicated display scaler object's Create event.

argument0 = the view to base internal resolution on (integer, 0-7)

Example usage: edgeds_init_scale(0);
*/

//Set the scaling view
global.display_view = clamp(argument0,0,7);

//Set the internal base resolution
global.display_wres = max(1,view_wport[global.display_view]); //Base width
global.display_hres = max(1,view_hport[global.display_view]); //Base height

//Initialize display scale variables
global.display_xprevscale = -1;
global.display_yprevscale = -1;
global.display_xscale = 1;
global.display_yscale = 1;
global.display_orientation = 0; //0 = landscape, 1 = portrait
global.display_zoom = 1;

//Initialize grace period to propogate changes in display scale
global.display_scale_time = 2;

//Initialize view scaling arrays
var view_index;
for(view_index = 0; view_index < 8; view_index += 1) {
   global.view_surf[view_index] = surface_create(16,16);
   global.view_xscale[view_index] = 1;
   global.view_yscale[view_index] = 1;
   global.view_xoffset[view_index] = 0;
   global.view_yoffset[view_index] = 0;
}

//Get the native display DPI
global.display_dpi = display_get_dpi_x();

//Set the display DPI based on operating system
switch(os_type) {
   case os_ios: global.display_dpi_os = 200; break;
   case os_android: global.display_dpi_os = 240; break;   
   case os_winphone: global.display_dpi_os = 180; break; 
   default: global.display_dpi_os = global.display_dpi; break;
}

//Initialize DPI override function
global.display_dpi_current = global.display_dpi;
