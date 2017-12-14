///scr_player_colliding(colliding_id);
colliding_inst = argument0;
global.playerLives -= 1;
toDrawSelf = 0;
instance_create(x,y,obj_player_pieces);
instance_create(x,y,obj_player_pieces);
instance_create(x,y,obj_player_pieces);
instance_create(x,y,obj_player_pieces);
instance_create(x,y,obj_player_pieces);
with(colliding_inst) {
instance_destroy();
}

alarm[0] = room_speed * 3;