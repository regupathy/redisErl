%%%-------------------------------------------------------------------
%%% @author regupathy.b
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Apr 2016 11:52 AM
%%%-------------------------------------------------------------------
-module(redis_data).
-author("regupathy.b").
-include("redis.hrl").

%% API
-export([basic_key/1,set_key/1,list_key/1,hash_key/1,arg/2,args/2,extract_key/1]).

%%%===================================================================
%%% API functions
%%%===================================================================

-spec basic_key(KeyItems::list(binary())|binary()) -> #redis_data{}.
basic_key(<<1,_/binary>> = Key) -> #redis_data{key1 = Key,type = #type.basic};
basic_key(KeyItems)when is_list(KeyItems) -> #redis_data{key1 = binary_util:merge(<<1>>,binary_util:append(<<"@">>,KeyItems)),type = #type.basic}.

-spec list_key(KeyItems::list(binary())|binary()) -> #redis_data{}.
list_key(<<2,_/binary>> = Key) -> #redis_data{key1 = Key,type = #type.list};
list_key(KeyItems)when is_list(KeyItems) -> #redis_data{key1= binary_util:merge(<<2>>,binary_util:append(<<"@">>,KeyItems)),type = #type.list}.

-spec set_key(KeyItems::list(binary())|binary()) -> #redis_data{}.
set_key(<<3,_/binary>> = Key) -> #redis_data{key1 = Key,type = #type.set};
set_key(KeyItems)when is_list(KeyItems) -> #redis_data{key1= binary_util:merge(<<3>>,binary_util:append(<<"@">>,KeyItems)),type = #type.set}.

-spec hash_key(KeyItems::list(binary())|binary()) -> #redis_data{}.
hash_key(<<4,_/binary>> = Key) -> #redis_data{key1 = Key,type = #type.hash};
hash_key(KeyItems)when is_list(KeyItems) -> #redis_data{key1= binary_util:merge(<<4>>,binary_util:append(<<"@">>,KeyItems)),type = #type.hash}.

-spec arg(Val::binary()|number()|float(),RedisData::#redis_data{}) -> #redis_data{}.
arg(Val,#redis_data{} = RedisData) -> RedisData#redis_data{value = {s,Val}}.

-spec args(KeyItems::list(binary()|number()|float()),RedisData::#redis_data{}) -> #redis_data{}.
args(Vals,#redis_data{} = RedisData)when is_list(Vals) -> RedisData#redis_data{value = {m,Vals}}.

extract_key(<<1,Key/binary>>) -> {ok,basic,binary_util:split(Key,<<"@">>)};
extract_key(<<2,Key/binary>>) -> {ok,list,binary_util:split(Key,<<"@">>)};
extract_key(<<3,Key/binary>>) -> {ok,set,binary_util:split(Key,<<"@">>)};
extract_key(<<4,Key/binary>>) -> {ok,hash,binary_util:split(Key,<<"@">>)};
extract_key(_) -> not_redis_key.
