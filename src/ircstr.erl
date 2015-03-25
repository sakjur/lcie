-module(ircstr).
-export([parse/1]).
-include("irc.hrl").

parse(Str) ->
    parse(Str, []).
parse([], Arr) ->
    [split(Arr)];
parse(?newline ++ Str, Arr) ->
    [split(Arr)] ++ parse(Str);
parse([H | T], Arr) ->
    parse(T, Arr ++ [H]).
    
split(Msg) ->
    {Prefix, R1} = prefix(Msg),
    {Command, R2} = command(R1),
    {Prefix, Command, R2}.

prefix([$: | Str]) ->
    untilspace(Str, []);
prefix(Msg) ->
    {[], Msg}.

command(Msg) ->
    untilspace(Msg, []).

untilspace([], Arr) -> {Arr, []};
untilspace([32 | Rest], Arr) -> {Arr, Rest};
untilspace([H | T], Arr) ->
    untilspace(T, Arr ++ [H]).
