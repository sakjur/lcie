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
    gen_tcp:send(Socket, print_user(User)),
    recv(Socket);
connect(ServerStr, UserStr) ->
    connect({ServerStr, ?ircport}, UserStr).

recv(Socket) ->
    Self = self(),
    receive
        {tcp, Socket, Data} ->
            spawn(fun() -> manager(Data, Self) end);
        {pong, Server} ->
            gen_tcp:send(Socket, "PONG " ++ Server),
            io:format("Sent pong!")
    end,
    recv(Socket).

manager(Data, Ctrl) ->
    String = binary_to_list(Data),
    Msgs = ircstr:parse(String),
    manageline(Msgs, Ctrl).

manageline([], _) -> ok;
manageline([{Prefix, Command, Msg} | Tail], Ctrl) ->
    case Command of
        "PING" ->
            [$: | Server] = Msg,
            Ctrl ! {pong, Server};
        "NOTICE" -> ok;
        ?RPL_WELCOME -> ok;
        ?RPL_YOURHOST -> ok;
        ?RPL_CREATED -> ok;
        ?RPL_MYINFO -> ok;
        ?RPL_BOUNCE -> ok;
        ?RPL_MOTD -> ok;
        ?RPL_MOTDSTART -> ok;
        ?RPL_ENDOFMOTD -> ok;
        _ -> io:format("~s ~s ~s~n", [Prefix, Command, Msg])
    end,
    manageline(Tail, Ctrl).
    

print_user(User) ->
    "NICK " ++ User#ircuser.nickname ++ ?newline
        ++ "USER "
        ++ User#ircuser.username ++ " 0 * :"
        ++ User#ircuser.realname ++ ?newline.

