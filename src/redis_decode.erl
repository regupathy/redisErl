%%%-------------------------------------------------------------------
%%% @author regupathy.b
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Apr 2016 11:19 AM
%%%-------------------------------------------------------------------
-module(redis_decode).
-author("regupathy.b").

%% API
-export([scan/2]).

scan(Source,State)-> decode_stream(Source,State).

decode_stream(Bin,[]) -> redis(Bin,[]);
decode_stream(Bin,{redis,State}) -> redis(Bin,State);
decode_stream(Bin,{string,Acc,State}) -> string(Bin,Acc,State);
decode_stream(Bin,{number,Acc,State}) -> number(Bin,Acc,State);
decode_stream(Bin,{chars,N,Acc,State}) -> chars(Bin,N,Acc,State);
decode_stream(_,Any) -> io:format("State :~p~n",[Any]),{wrong_data,<<"invalid state in redis parser">>}.

redis(<<$+,Rest/binary>>,State) -> string(Rest,[status|State]);
redis(<<$-,Rest/binary>>,State) -> string(Rest,[error|State]);
redis(<<$:,Rest/binary>>,State) -> number(Rest,State);
redis(<<$$,Rest/binary>>,State) -> number(Rest,[bs|State]);
redis(<<$*,Rest/binary>>,State) -> number(Rest,[list|State]);
redis(<<>>,State) -> verify(State);
redis(_,_State) -> {wrong_data,<<"redis begin chars is miss match">>}.

number(Bin,State) -> number(Bin,<<>>,[number|State]).
number(<<$-,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$->>/binary>>,State);
number(<<$0,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$0>>/binary>>,State);
number(<<$1,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$1>>/binary>>,State);
number(<<$2,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$2>>/binary>>,State);
number(<<$3,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$3>>/binary>>,State);
number(<<$4,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$4>>/binary>>,State);
number(<<$5,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$5>>/binary>>,State);
number(<<$6,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$6>>/binary>>,State);
number(<<$7,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$7>>/binary>>,State);
number(<<$8,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$8>>/binary>>,State);
number(<<$9,Rest/binary>>,Acc,State) -> number(Rest,<<Acc/binary,<<$9>>/binary>>,State);
number(<<$\r,Rest/binary>>,Acc,State) -> number(Rest,Acc,State);
number(<<$\n,_Rest/binary>>,<<>>,_State) -> {wrong_data,<<"Expect Integer is Not Found">>};
number(<<$\n,Rest/binary>>,Acc,[number,bs|State]) -> chars(Rest,binary_to_integer(Acc),State);
number(<<$\n,Rest/binary>>,Acc,State) -> redis(Rest,save(State,binary_to_integer(Acc)));
number(<<>>,Acc,State) -> {incomplete,{number,Acc,State}};
number(_Rest,_Acc,_State) -> {wrong_data,<<" Invalid Number">>}.

chars(Bin,-1,State) -> redis(Bin,save([chars|State],nil));
chars(Bin,Count,State) -> chars(Bin,Count,<<>>,[chars|State]).


chars(<<$\n,Rest/binary>>,0,Acc,State) -> redis(Rest,save(State,Acc));
chars(<<$\n,_Rest/binary>>,_,_Acc,_State) -> {wrong_data,<<"Incomplete Bulk String">>};
chars(<<$\r,Rest/binary>>,N,Acc,State) -> chars(Rest,N,Acc,State);
chars(<<>>,N,Acc,State) -> {incomplete,{chars,N,Acc,State}};
chars(_,0,_Acc,_State) -> {wrong_data,<<"Extra Chars in Bulk String">>};
chars(<<H,Rest/binary>>,N,Acc,State) -> chars(Rest,N-1,<<Acc/binary,<<H>>/binary>>,State).


string(Bin,State) -> string(Bin,<<>>,State).
string(<<$\r,Rest/binary>>,Acc,State) -> string(Rest,Acc,State);
string(<<$\n,Rest/binary>>,Acc,State) -> redis(Rest,save(State,Acc));
string(<<>>,Acc,State) -> {incomplete,{string,Acc,State}};
string(<<H,Rest/binary>>,Acc,State) -> string(Rest,<<Acc/binary,<<H>>/binary>>,State).

verify([{list,Count,List}|_]= State) when length(List) =/= Count -> {incomplete,{redis,State}};
verify(State) -> {complete,lists:reverse(State)}.

save([number,list|Rest],0) -> save([list|Rest],[]);
save([number,list|Rest],Number) -> [{list,Number,[]}|Rest];
save([Term,{list,Count,List},{list,InnerCount,InnerList}|Rest],Val)when length(List) =:= Count-1 ->
  case InnerCount-1 =:= length(InnerList)of

    true -> [{list,lists:reverse([{list,lists:reverse([value(Term,Val)|List])}|InnerList])}|Rest];

    false -> [{list,InnerCount,[{list,lists:reverse([value(Term,Val)|List])}|InnerList]}|Rest]

  end;
save([Term,{list,Count,List}|Rest],Val)when length(List) =:= Count-1 ->   [{list,lists:reverse([value(Term,Val)|List])}|Rest];
save([Term,{list,Count,List}|Rest],Val) -> [{list,Count,[value(Term,Val)|List]}|Rest];
save([list|Rest],[]) -> [{list,[]}|Rest];
save([status|Rest],Status) -> [value(status,Status)|Rest];
save([error|Rest], Error) -> [value(error, Error)|Rest];
save([chars|Rest],String) -> [value(chars,String)|Rest];
save([number|Rest],Number) -> [value(number,Number)|Rest].

value(_,nil) -> nil;
value(Term,Val) -> {Term,Val}.




