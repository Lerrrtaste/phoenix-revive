///scr_fighter_colliding(colliding_id);
colliding_inst = argument0;

instance_create(x,y,obj_enemy_explosion);
instance_destroy(colliding_inst);
instance_destroy();
