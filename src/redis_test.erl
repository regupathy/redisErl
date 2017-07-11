%%%-------------------------------------------------------------------
%%% @author regupathy.b
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Apr 2016 10:39 AM
%%%-------------------------------------------------------------------
-module(redis_test).
-author("regupathy.b").

%% API
-export([]).


redis_set(KeySet,Val) -> rediserl:single_cmd(redis_operation:set(redis_data:arg(Val,redis_data:set_key(KeySet)))).





