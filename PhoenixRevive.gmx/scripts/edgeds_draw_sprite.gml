///edgeds_draw_sprite(sprite, index, x, y, rot, color, alpha, scale mode, notme, xscale, yscale);

/*
Draws a sprite with one of five scale modes, plus a number of additional drawing options.
X-Y Full Scale will fill the window space with the given sprite on both axes, ensuring
blank areas are never seen. X full scale and Y full scale fill the window space on only
one axis or the other, allowing for blank spaces in the other axis. Fit scale maintains
100% size except when the display is too small to display the entire sprite, in which case
it will scale down. Somewhat oppositely, Proportion scale will maintain the sprite's relative
size to the base resolution, scaling up or down by the same factor as the entire display.

argument0  = sets the sprite to draw (sprite)
argument1  = sets the image index of the sprite (integer) (-1 or image_index for current frame)
argument2  = sets the x position to draw the sprite (real)
argument3  = sets the y position to draw the sprite (real)
argument4  = sets the sprite rotation value (real)
argument5  = sets the sprite blending color (color) (c_white for none)
argument6  = sets the sprite alpha transparency value (real) (0-1)
argument7  = sets whether to use x-y full scale (0), x-only full scale (1), y-only full scale (2), fit scale (3), or proportion scale (4) (integer)
argument8  = sets whether to exclude the running object's assigned sprite from scaling (boolean) (true/false)
argument9  = horizontal scale multiplier offset (real)
argument10 = vertical scale multiplier offset (real)

Example usage: edgeds_draw_sprite(spr_mysprite, image_index, 128, 256, 0, c_white, 1, 4, false, 1, 1);
*/

/*
INITIALIZE
*/

var display_width = view_wview[global.display_view];
var display_height = view_hview[global.display_view];

//Initialize the sprite scale factor
var sprite_xscale = 1;
var sprite_yscale = 1;

/*
SCALE AND DRAW SPRITE
*/

//Scale the sprite
if global.display_xscale != 0 and global.display_yscale != 0 {
   //X-Y and X-only scaling
   if argument7 <= 1 {
      //Scale width
      sprite_xscale = sprite_yscale*(display_width/(sprite_get_width(argument0)*sprite_xscale));
      sprite_yscale = sprite_xscale;
   }
         
   //X-Y scaling
   if argument7 <= 0 {
      //Scale height
      if sprite_get_height(argument0)*sprite_yscale < display_height {
         sprite_yscale = sprite_xscale*(display_height/(sprite_get_height(argument0)*sprite_yscale));
         sprite_xscale = sprite_yscale;
      }   
   }
         
   //Y-only scaling
   if argument7 == 2 {
      //Scale height
      sprite_yscale = sprite_xscale*(display_height/(sprite_get_height(argument0)*sprite_yscale));
      sprite_xscale = sprite_yscale;
   }
   
   //Fit scaling
   if argument7 == 3 {
      //Width
      sprite_xscale = clamp(display_width/(((argument2 - view_xview[global.display_view])*0.5) + sprite_get_width(argument0)), 0, 1);
      sprite_yscale = sprite_xscale;

      //Height
      if (argument3 + sprite_get_height(argument0)) > display_height {
         sprite_yscale = sprite_xscale*clamp(display_height/(((argument3 - view_yview[global.display_view])*0.5) + sprite_get_height(argument0)), 0, 1);
         sprite_xscale = sprite_yscale;
      }
   }
   
   //Proportion scaling
   if argument7 >= 4 {
      sprite_xscale = (global.display_xscale + global.display_yscale)*0.5;
      sprite_yscale = sprite_xscale;
   }

   //Set and scale running object's sprite, if enabled
   if argument8 == false {
      sprite_index = argument0;
      image_xscale = sprite_xscale*argument9;
      image_yscale = sprite_yscale*argument10;
   }
}

//Draw the sprite with the given scaling mode
draw_sprite_ext(argument0,argument1,argument2,argument3,sprite_xscale*argument9,sprite_yscale*argument10,argument4,argument5,argument6);
