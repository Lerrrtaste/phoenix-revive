///scr_fighter_colliding(colliding_id);
colliding_inst = argument0;

instance_create(x,y,obj_enemy_explosion);
with(colliding_inst) {
instance_destroy();
}
instance_destroy();