-module(irc).
-author("Emil Tullstedt <sakjur@gmail.com>").
-include("irc.hrl").
-export([connect/2]).
-export([server/1, server/2, user/1, user/3]).

server(Host) ->
    server(Host, 6667).
server(Host, Port) ->
    #server{host=Host, port=Port}.

user(Nickname) ->
    user(Nickname, Nickname, ?version).
user(Nickname, Username, Realname) ->
    #ircuser{nickname=Nickname, username=Username, realname=Realname}.

connect(Server, User) ->
    {ok, Socket} = gen_tcp:connect(Server#server.host, Server#server.port,
        [binary, {packet, 2}]),
    io:format("~s~n", [print_user(User)]),
    io:format("Socket ~p~n", [Socket]),
    gen_tcp:send(Socket, print_user(User)),
    Reply = wait_reply(Socket),
    io:format("Reply = ~p~n", [Reply]),
    gen_tcp:close(Socket).

wait_reply(_Socket) ->
    receive
        Reply -> {value, Reply}
    after 100000 ->
        timeout
    end.

print_user(User) ->
    "NICK " ++ User#ircuser.nickname ++ ?newline
        ++ "USER "
        ++ User#ircuser.username ++ " 0 * :"
        ++ User#ircuser.realname ++ ?newline.

