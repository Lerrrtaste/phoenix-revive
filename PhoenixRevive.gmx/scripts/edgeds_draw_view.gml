///edgeds_draw_view(view, x, y, rot, color, alpha, scale mode);

/*
Draws the *entire contents* of the given view, optionally scaling the drawn view to
maximize the window space without compromising aspect ratio. Also repositions the
drawn view when scaled so as to always be centered.

Note that this script is ONLY for scaling SMALL views UP. Scaling LARGE views DOWN 
will exceed the boundaries of the main display and result in missing visual data!

argument0 = sets the view to be drawn (view) (0-7)
argument1 = sets the x offset to draw the view (real)
argument2 = sets the y offset to draw the view (real)
argument3 = sets the view rotation value (real)
argument4 = sets the view blending color (color) (c_white for none)
argument5 = sets the view transparency (real) (0-1)
argument6 = sets whether to use aspect ratio full scale (0) or absolute scaling (1+) (real)

Example usage: edgeds_draw_view(1, 0, 0, 0, c_white, 1, 1);
*/

/*
INITIALIZE
*/

var display_width = view_wview[global.display_view];
var display_height = view_hview[global.display_view];

//Hide the target view
view_visible[argument0] = false;

//Ensure the target surface exists
if !surface_exists(global.view_surf[argument0]) {
   global.view_surf[argument0] = surface_create(16,16);
}

//Resize the target surface to match the target view
if surface_get_width(global.view_surf[argument0]) != view_wview[argument0] and surface_get_height(global.view_surf[argument0]) != view_hview[argument0] {
   surface_resize(global.view_surf[argument0],view_wview[argument0],view_hview[argument0]);
}

/*
DRAW AND SCALE VIEW AS SURFACE
*/

//Perform full scale, if enabled
if argument6 >= 0 and argument6 < 1 {   
   //Scale the view
   if global.display_scale_time > 0 {
      //Scale width
      if surface_get_width(global.view_surf[argument0]) < display_width {
         global.view_xscale[argument0] = display_width/view_wview[argument0];
         global.view_yscale[argument0] = global.view_xscale[argument0];
      
         if surface_get_height(global.view_surf[argument0])*global.view_yscale[argument0] > display_height {
            global.view_yscale[argument0] = display_height/view_hview[argument0];
            global.view_xscale[argument0] = global.view_yscale[argument0];
         }
      }
   
      //Scale height
      if surface_get_height(global.view_surf[argument0]) < display_height {
         global.view_yscale[argument0] = display_height/view_hview[argument0];
         global.view_xscale[argument0] = global.view_yscale[argument0];
      
         if surface_get_width(global.view_surf[argument0])*global.view_xscale[argument0] > display_width {
            global.view_xscale[argument0] = display_width/view_wview[argument0];
            global.view_yscale[argument0] = global.view_xscale[argument0];
         }      
      }
   }
   
   //Reposition to center
   global.view_xoffset[argument0] = (display_width*0.5) - ((view_wview[argument0]*global.view_xscale[argument0])*0.5);
   global.view_yoffset[argument0] = (display_height*0.5) - ((view_hview[argument0]*global.view_yscale[argument0])*0.5);
} else {
   //Otherwise scale to the absolute argument value
   global.view_xscale[argument0] = argument6;
   global.view_yscale[argument0] = argument6;
}

//Clear the target surface for each frame
surface_set_target(global.view_surf[argument0]);
draw_clear_alpha(c_white,0);
surface_reset_target();

//Copy the target view to the target surface
surface_copy_part(global.view_surf[argument0],0,0,application_surface,view_xview[argument0],view_yview[argument0],view_wview[argument0],view_hview[argument0]);

//Draw the target surface
draw_surface_ext(global.view_surf[argument0], global.view_xoffset[argument0] + argument1, global.view_yoffset[argument0] + argument2, max(global.view_xscale[argument0],1), max(global.view_yscale[argument0],1), argument3, argument4, argument5);

