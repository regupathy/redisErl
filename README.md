# redisErl

Redis is a NoSql database stores data as a collection of key-value pairs. there are three kind of structure.

      Root Key with single Value -- basic
      Root Key with multiple Value -- list and set
      Root Key with multiple Key-Values -- hash

Start 

      1> rr(redis).
      2> #redis_data{}.
      3> 
      3> rediserl:single_cmd(#redis_data{type = #type.basic,operation = #basic.save,
         key1=message, value ="Hello World!"}).
