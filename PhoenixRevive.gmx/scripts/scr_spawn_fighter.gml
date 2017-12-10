///scr_spawn_fighter(formationOffsetX,formationOffsetY);
formationOffsetX  = argument0;
formationOffsetY = argument1;
tmp = instance_create(0,0,obj_enemy_fighter);
tmp.formation_offsetX = formationOffsetX;
tmp.formation_offsetY = formationOffsetY;
enemys_spawned++;
