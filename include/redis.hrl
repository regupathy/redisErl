-record(redis_data,{type,key1,key2,operation,value}).
-record(type,{set,list,hash,basic}).
-record(opeation,{basic,set,list,hash}).
-record(list,{front_load,back_load,front_drop,back_drop,length}).
-record(set,{add,count,sets_difference,save_sets_difference,sets_union,save_sets_union,
  sets_common,save_sets_common,member,move,random_pick,remove,get_all}).
-record(hash,{save_new,save,save_all,collect,collect_some,collect_all,present, delete,auto_int,auto_float,keys,keys_count}).
-record(basic,{save_new,save,delete,get,auto_increment,add_more,expire,exists}).

