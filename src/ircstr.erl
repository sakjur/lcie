-module(ircstr).
-export([parse/1]).
-include("irc.hrl").
-ifdef(TEST).
-compile(export_all).
-endif.

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
    {Prefix, Rest} = untilspace(Str, []),
    case usersplit(Prefix, []) of
        {Nickname, _Username, _Hostname} ->
            {Nickname, Rest};
        Server ->
            {Server, Rest}
    end;
prefix(Msg) ->
    {[], Msg}.

usersplit([], Arr) ->
    Arr;
usersplit([$! | Username], Arr) ->
    {User, Hostname} = usersplit(Username, []),
    {Arr, User, Hostname};
usersplit([$@ | Hostname], Arr) ->
    {Arr, Hostname};
usersplit([H | T], Arr) ->
    usersplit(T, Arr ++ [H]).

command(Msg) ->
    untilspace(Msg, []).

untilspace([], Arr) -> {Arr, []};
untilspace([32 | Rest], Arr) -> {Arr, Rest};
untilspace([H | T], Arr) ->
    untilspace(T, Arr ++ [H]).

