-module(irc).
-author("Emil Tullstedt <sakjur@gmail.com>").
-include("irc.hrl").
-export([connect/2]).
-ifdef(TEST).
-export([server_fmt/1, server_fmt/2, user_fmt/1, user_fmt/3]).
-endif.

server_fmt(Host) ->
    server_fmt(Host, ?ircport).
server_fmt(Host, Port) ->
    #server{host=Host, port=Port}.

user_fmt(Nickname) ->
    user_fmt(Nickname, Nickname, ?version).
user_fmt(Nickname, Username, Realname) ->
    #ircuser{nickname=Nickname, username=Username, realname=Realname}.

connect({ServerStr, Port}, UserStr) ->
    Server = server_fmt(ServerStr, Port),
    User = user_fmt(UserStr),
    {ok, Socket} = gen_tcp:connect(Server#server.host, Server#server.port,
        [binary, {packet, 0}]),
    io:format("~s~n", [print_user(User)]),
    io:format("Socket ~p~n", [Socket]),
    gen_tcp:send(Socket, print_user(User)),
    recv(Socket);
connect(ServerStr, UserStr) ->
    connect({ServerStr, ?ircport}, UserStr).

recv(Socket) ->
    receive
        {tcp, Socket, Data} ->
            io:format("Received: ~p~n", [Data]),
            recv(Socket)
    end.

print_user(User) ->
    "NICK " ++ User#ircuser.nickname ++ ?newline
        ++ "USER "
        ++ User#ircuser.username ++ " 0 * :"
        ++ User#ircuser.realname ++ ?newline.

