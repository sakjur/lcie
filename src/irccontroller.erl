-module(irccontroller).
-author("Emil Tullstedt <sakjur@gmail.com>").
-include("irc.hrl").
-export([start_controller/1]).
-ifdef(TEST).
-export([]).
-endif.

start_controller(Ctrl) ->
    handler(Ctrl).

handler(Ctrl) ->
    receive
        {irc, Data} ->
            spawn(fun() -> irc_msg(Data, Ctrl) end),
            handler(Ctrl)
    end.

irc_msg({_, "PING", [$: | Server]}, Ctrl) ->
    irc:send(Ctrl, "PONG " ++ Server);
irc_msg({_, [$0 | _], _}, _) ->
    ok;
irc_msg({_, ?RPL_MOTD, _}, _) ->
    ok;
irc_msg({_, "NOTICE", _}, _) ->
    ok;
irc_msg({Prefix, Command, Msg}, _) ->
    io:format("~s ~s ~s~n", [Prefix, Command, Msg]).

