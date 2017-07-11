%%%-------------------------------------------------------------------
%%% @author regupathy.b
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Jul 2015 5:22 PM
%%%-------------------------------------------------------------------
-module(rediserl).
-author("regupathy.b").
-include("redis.hrl").
%% API

-export([single_cmd/1,multi_cmds/1]).

%%%===================================================================
%%% API functions
%%%===================================================================

single_cmd(#redis_data{type = Type,operation = Operation} = Data) -> create_cmd(command(Type,Operation,Data)).

multi_cmds(ListCommand)when is_list(ListCommand) -> create_multi_cmd([single_cmd(X)|| X <- ListCommand]).

%%%===================================================================
%%% Internal Operation functions
%%%===================================================================

command(_,_,#redis_data{key1 =  undefined}) -> throw({error,<<"Key is missing">>});
command(#type.basic,#basic.save,#redis_data{key1 =  <<1,Key/binary>>,value = {s,Val}}) -> [<<"SET">>,Key,Val];
command(#type.basic,#basic.save_new,#redis_data{key1 =  <<1,Key/binary>>,value = {s,Val}}) -> [<<"SETNX">>,Key,Val];
command(#type.basic,#basic.delete,#redis_data{key1 =  <<1,Key/binary>>}) -> [<<"DEL">>,Key];
command(#type.basic,#basic.get,#redis_data{key1 =  <<1,Key/binary>>}) -> [<<"GET">>,Key];
command(#type.basic,#basic.auto_increment,#redis_data{key1 =  <<1,Key/binary>>}) -> [<<"INCR">>,Key];
command(#type.basic,#basic.add_more,#redis_data{key1 =  <<1,Key/binary>>,value = {s,Val}}) -> [<<"APPEND">>,Key,Val];
command(#type.basic,#basic.expire,#redis_data{key1 =  <<1,Key/binary>>,value = {s,Val}}) -> [<<"EXPIRE">>,Key,Val];
command(#type.basic,#basic.exists,#redis_data{key1 =  <<1,Key/binary>>,key2  = undefined}) -> [<<"EXISTS">>,Key];
command(#type.basic,#basic.exists,#redis_data{key1 =  <<1,Key/binary>>,key2  = {s,Key2}}) -> [<<"EXISTS">>,Key,Key2];
command(#type.basic,#basic.exists,#redis_data{key1 =  <<1,Key/binary>>,key2  = {m,Keys}}) -> [<<"EXISTS">>,Key|Keys];

command(#type.list,#list.front_load,#redis_data{key1 =  <<2,Key/binary>>,value = {s,Val}}) -> [<<"RPUSH">>,Key,Val];
command(#type.list,#list.front_load,#redis_data{key1 =  <<2,Key/binary>>,value = {m,Vals}}) -> [<<"RPUSH">>|[Key|Vals]];
command(#type.list,#list.back_load,#redis_data{key1 =  <<2,Key/binary>>,value = {s,Val}}) -> [<<"LPUSH">>,Key,Val];
command(#type.list,#list.back_load,#redis_data{key1 =  <<2,Key/binary>>,value = {m,Vals}}) -> [<<"LPUSH">>|[Key|Vals]];
command(#type.list,#list.front_drop,#redis_data{key1 =  <<2,Key/binary>>}) -> [<<"RPOP">>,Key];
command(#type.list,#list.back_drop,#redis_data{key1 =  <<2,Key/binary>>}) -> [<<"LPOP">>,Key];
command(#type.list,#list.length,#redis_data{key1 =  <<2,Key/binary>>}) -> [<<"LLEN">>,Key];

command(#type.set,#set.add,#redis_data{key1 =  <<3,Key/binary>>,value = {s,Val}}) -> [<<"SADD">>,Key,Val];
command(#type.set,#set.add,#redis_data{key1 =  <<3,Key/binary>>,value = {m,Val}}) -> [<<"SADD">>|[Key|Val]];
command(#type.set,#set.count,#redis_data{key1 =  <<3,Key/binary>>}) -> [<<"SCARD">>,Key];
command(#type.set,#set.sets_difference,#redis_data{key1 =  <<3,Key/binary>>,key2 = {s,Key2}}) -> [<<"SDIFF">>,Key,Key2];
command(#type.set,#set.sets_difference,#redis_data{key1 =  <<3,Key/binary>>,key2 = {m,Key2}}) -> [<<"SDIFF">>|[Key|Key2]];
command(#type.set,#set.save_sets_difference,#redis_data{key1 =  <<3,Key/binary>>,key2 = {s,Key2}}) -> [<<"SDIFFSTORE">>,Key,Key2];
command(#type.set,#set.save_sets_difference,#redis_data{key1 =  <<3,Key/binary>>,key2 = {m,Key2}}) -> [<<"SDIFFSTORE">>|[Key|Key2]];
command(#type.set,#set.sets_union,#redis_data{key1 =  <<3,Key/binary>>,key2 = {s,Key2}}) -> [<<"SUNION">>,Key,Key2];
command(#type.set,#set.sets_union,#redis_data{key1 =  <<3,Key/binary>>,key2 = {m,Key2}}) -> [<<"SUNION">>|[Key|Key2]];
command(#type.set,#set.save_sets_union,#redis_data{key1 =  <<3,Key/binary>>,key2 = {s,Key2}}) -> [<<"SUNIONSTORE">>,Key,Key2];
command(#type.set,#set.save_sets_union,#redis_data{key1 =  <<3,Key/binary>>,key2 = {m,Key2}}) -> [<<"SUNIONSTORE">>|[Key|Key2]];
command(#type.set,#set.sets_common,#redis_data{key1 =  <<3,Key/binary>>,key2 = {s,Key2}}) -> [<<"SINTER">>,Key,Key2];
command(#type.set,#set.sets_common,#redis_data{key1 =  <<3,Key/binary>>,key2 = {m,Key2}}) -> [<<"SINTER">>|[Key|Key2]];
command(#type.set,#set.save_sets_common,#redis_data{key1 =  <<3,Key/binary>>,key2 = {s,Key2}}) -> [<<"SINTERSTORE">>,Key,Key2];
command(#type.set,#set.save_sets_common,#redis_data{key1 =  <<3,Key/binary>>,key2 = {m,Key2}}) -> [<<"SINTERSTORE">>|[Key|Key2]];
command(#type.set,#set.member,#redis_data{key1 =  <<3,Key/binary>>,value = {s,Val}}) -> [<<"SISMEMBER">>,Key,Val];
command(#type.set,#set.move,#redis_data{key1 =  <<3,Key/binary>>,value = {s,Val},key2 = {s,Key2}}) -> [<<"SMOVE">>,Val,Key,Key2];
command(#type.set,#set.random_pick,#redis_data{key1 =  <<3,Key/binary>>,value = {s,Val}}) -> [<<"SRANDMEMBER">>,Key,Val];
command(#type.set,#set.remove,#redis_data{key1 =  <<3,Key/binary>>,value = {s,Val}}) -> [<<"SREM">>,Key,Val];
command(#type.set,#set.remove,#redis_data{key1 =  <<3,Key/binary>>,value = {m,Vals}}) -> [<<"SREM">>|[Key|Vals]];
command(#type.set,#set.get_all,#redis_data{key1 =  <<3,Key/binary>>}) -> [<<"SMEMBERS">>,Key];

command(#type.hash,#hash.save,#redis_data{key1 =  <<4,Key/binary>>,value = {s,Val},key2 = {s,Key2}}) -> [<<"HSET">>,Key,Key2,Val];
command(#type.hash,#hash.save_new,#redis_data{key1 =  <<4,Key/binary>>,value = {s,Val},key2 = {s,Key2}}) -> [<<"HSETNX">>,Key,Key2,Val];
command(#type.hash,#hash.save_all,#redis_data{key1 =  <<4,_/binary>>,value = {m,[]}}) -> throw({error,<<"Wrong input for save_all">>});
command(#type.hash,#hash.save_all,#redis_data{key1 =  <<4,_/binary>>,key2 = {m,[]}}) -> throw({error,<<"Wrong input for save_all">>});
command(#type.hash,#hash.save_all,#redis_data{key1 =  <<4,Key/binary>>,value = {m,Vals},key2 = {m,Keys}})
  when length(Vals) =:= length(Keys) -> [<<"HMSET">>,Key|list_util:swipe_merge(Keys,Vals)];
command(#type.hash,#hash.collect,#redis_data{key1 =  <<4,Key/binary>>,key2 = {s,Key2}}) -> [<<"HGET">>,Key,Key2];
command(#type.hash,#hash.collect_some,#redis_data{key1 =  <<4,Key/binary>>,key2 = {m,Keys}}) -> [<<"HMGET">>,Key|Keys];
command(#type.hash,#hash.collect_all,#redis_data{key1 =  <<4,Key/binary>>}) -> [<<"HGETALL">>,Key];
command(#type.hash,#hash.present,#redis_data{key1 =  <<4,Key/binary>>}) -> [<<"HEXISTS">>,Key];
command(#type.hash,#hash.delete,#redis_data{key1 =  <<4,Key/binary>>,key2 = {s,Key2}}) -> [<<"HDEL">>,Key,Key2];
command(#type.hash,#hash.delete,#redis_data{key1 =  <<4,Key/binary>>,key2 = {m,Key2}}) -> [<<"HDEL">>,Key|Key2];
command(#type.hash,#hash.auto_int,#redis_data{key1 =  <<4,Key/binary>>,key2 = {s,Key2},value = {s,Val}}) -> [<<"HINCRBY">>,Key,Key2,Val];
command(#type.hash,#hash.auto_float,#redis_data{key1 =  <<4,Key/binary>>,key2 = {s,Key2},value = {s,Val}}) -> [<<"HINCRBYFLOAT">>,Key,Key2,Val];
command(#type.hash,#hash.keys,#redis_data{key1 =  <<4,Key/binary>>}) -> [<<"HKEY">>,Key];
command(#type.hash,#hash.keys_count,#redis_data{key1 =  <<4,Key/binary>>}) -> [<<"HLEN">>,Key];

command(_,_,_) -> throw({error,<<"Wrong Argument in Redis command">>}).

%%%===================================================================
%%% Internal operation functions
%%%===================================================================
-define(NEWLINE,"\r\n").

create_cmd(CMDSET) -> [command_header(CMDSET),command_body(CMDSET,[])].

create_multi_cmd(Commands) -> [create_cmd(["MULTI"]) | Commands] ++ [create_cmd(["EXEC"])].

command_header(Cmd) ->  [<<$*>>, integer_to_list(length(Cmd)), <<?NEWLINE>>].

command_body([],CmdSet) -> lists:reverse(CmdSet);
command_body([Cmd|Rest],CmdSet) ->  command_body(Rest,[[<<$$>>, integer_to_list(iolist_size(Cmd)), <<?NEWLINE>>, Cmd, <<?NEWLINE>>]|CmdSet]).

%%%===================================================================
%%% helper functions
%%%===================================================================

