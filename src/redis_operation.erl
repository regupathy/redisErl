%%%-------------------------------------------------------------------
%%% @author regupathy.b
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Apr 2016 4:21 PM
%%%-------------------------------------------------------------------
-module(redis_operation).
-author("regupathy.b").
-include("redis.hrl").

%% API
-compile(export_all).

%%%===================================================================
%%% basic data Storage schema
%%%===================================================================

set_new(#redis_data{type = #type.basic} = R) -> R#redis_data{operation = #basic.save_new}.

set(#redis_data{type = #type.basic} = R) -> R#redis_data{operation = #basic.save}.

get(#redis_data{type = #type.basic} = R) -> R#redis_data{operation = #basic.get}.

delete(#redis_data{type = #type.basic} = R) -> R#redis_data{operation = #basic.delete}.

append(#redis_data{type = #type.basic} = R) -> R#redis_data{operation = #basic.add_more}.

auto_increment(#redis_data{type = #type.basic} = R) -> R#redis_data{operation = #basic.auto_increment}.

expire(#redis_data{type = #type.basic} = R) -> R#redis_data{operation = #basic.expire}.

exists(#redis_data{type = #type.basic} = R,Key2)when is_list(Key2) -> R#redis_data{operation = #basic.exists,key2 = {m,Key2}};

exists(#redis_data{type = #type.basic} = R,Key2) -> R#redis_data{operation = #basic.exists,key2 = {s,Key2}}.

exists(#redis_data{type = #type.basic} = R) -> R#redis_data{operation = #basic.exists}.

%%%===================================================================
%%% List/Queue data Storage schema
%%%===================================================================

attach_front(#redis_data{type = #type.list} = R) -> R#redis_data{operation = #list.front_load}.

attach_back(#redis_data{type = #type.list} = R) -> R#redis_data{operation = #list.back_load}.

detach_front(#redis_data{type = #type.list} = R) -> R#redis_data{operation = #list.front_drop}.

detach_back(#redis_data{type = #type.list} = R) -> R#redis_data{operation = #list.back_drop}.

length(#redis_data{type = #type.list} = R) -> R#redis_data{operation = #list.length}.

%%%===================================================================
%%% Set data Storage schema
%%%===================================================================

add(#redis_data{type = #type.set} = R) -> R#redis_data{operation = #set.add}.

count(#redis_data{type = #type.set} = R) -> R#redis_data{operation = #set.count}.

differ(#redis_data{type = #type.set} = R,Key2)when is_binary(Key2) -> R#redis_data{operation = #set.sets_difference,key2 = {s,Key2}};

differ(#redis_data{type = #type.set} = R,Key2)when is_list(Key2) -> R#redis_data{operation = #set.sets_difference,key2 = {m,Key2}}.

save_differ(#redis_data{type = #type.set} = R,Key2)when is_binary(Key2) -> R#redis_data{operation = #set.save_sets_difference,key2 = {s,Key2}};

save_differ(#redis_data{type = #type.set} = R,Key2)when is_list(Key2) -> R#redis_data{operation = #set.save_sets_difference,key2 = {m,Key2}}.

intersection(#redis_data{type = #type.set} = R,Key2)when is_binary(Key2) -> R#redis_data{operation = #set.sets_common,key2 = {s,Key2}};

intersection(#redis_data{type = #type.set} = R,Key2)when is_list(Key2) -> R#redis_data{operation = #set.sets_common,key2 = {m,Key2}}.

save_intersection(#redis_data{type = #type.set} = R,Key2)when is_binary(Key2) -> R#redis_data{operation = #set.save_sets_common,key2 = {s,Key2}};

save_intersection(#redis_data{type = #type.set} = R,Key2)when is_list(Key2) -> R#redis_data{operation = #set.save_sets_common,key2 = {m,Key2}}.

union(#redis_data{type = #type.set} = R,Key2)when is_binary(Key2) -> R#redis_data{operation = #set.sets_union,key2 = {s,Key2}};

union(#redis_data{type = #type.set} = R,Key2)when is_list(Key2) -> R#redis_data{operation = #set.sets_union,key2 = {m,Key2}}.

save_union(#redis_data{type = #type.set} = R,Key2)when is_binary(Key2) -> R#redis_data{operation = #set.save_sets_union,key2 = {s,Key2}};

save_union(#redis_data{type = #type.set} = R,Key2)when is_list(Key2) -> R#redis_data{operation = #set.save_sets_union,key2 = {m,Key2}}.

member(#redis_data{type = #type.set} = R) -> R#redis_data{operation = #set.member}.

move(#redis_data{type = #type.set} = R,ToKey)when is_binary(ToKey) -> R#redis_data{operation = #set.member,key2 = {s,ToKey}}.

random(#redis_data{type = #type.set} = R) -> R#redis_data{operation = #set.random_pick}.

remove(#redis_data{type = #type.set} = R) -> R#redis_data{operation = #set.remove}.

get_all_set(#redis_data{type = #type.set} = R) -> R#redis_data{operation = #set.get_all}.

%%%===================================================================
%%% Hash Storage schema
%%%===================================================================

save(#redis_data{type = #type.hash} = R,Key2) -> R#redis_data{operation = #hash.save,key2 = {s,Key2}}.

save_new(#redis_data{type = #type.hash} = R) -> R#redis_data{operation = #hash.save_new}.

save_all(#redis_data{type = #type.hash} = R,Keys) -> R#redis_data{operation = #hash.save_all,key2 = {m,Keys}}.

get(#redis_data{type = #type.hash} = R,Key)when is_binary(Key) -> R#redis_data{operation = #hash.collect,key2 = {s,Key}}.

get_some(#redis_data{type = #type.hash} = R,Keys) when is_list(Keys) -> R#redis_data{operation = #hash.collect_some,key2 = {m,Keys}}.

get_all(#redis_data{type = #type.hash} = R) -> R#redis_data{operation = #hash.collect_all}.

present(#redis_data{type = #type.hash} = R) -> R#redis_data{operation = #hash.present}.

delete(#redis_data{type = #type.hash} = R,Key) when is_binary(Key) -> R#redis_data{operation = #hash.delete,key2={s,Key}};

delete(#redis_data{type = #type.hash} = R,Keys) when is_list(Keys) -> R#redis_data{operation = #hash.delete,key2={m,Keys}}.

auto_increment_int(#redis_data{type = #type.hash} = R,Key) when is_binary(Key) -> R#redis_data{operation = #hash.auto_int,key2={s,Key}}.

auto_increment_float(#redis_data{type = #type.hash} = R,Key) when is_binary(Key) -> R#redis_data{operation = #hash.auto_float,key2={s,Key}}.

members(#redis_data{type = #type.hash} = R,Key) when is_binary(Key) -> R#redis_data{operation = #hash.keys,key2={s,Key}}.

members_count(#redis_data{type = #type.hash} = R,Key) when is_binary(Key) -> R#redis_data{operation = #hash.keys_count,key2={s,Key}}.
