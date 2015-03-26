-module(irc).
-author("Emil Tullstedt <sakjur@gmail.com>").
-include("irc.hrl").
-export([connect/2, send/2]).
-ifdef(TEST).
-export([server_fmt/2, user_fmt/1, user_fmt/3]).
-endif.

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
    gen_tcp:send(Socket, "JOIN #lcietest" ++ ?newline),
    recv(Socket);
connect(ServerStr, UserStr) ->
    connect({ServerStr, ?ircport}, UserStr).

send(Pid, Data) ->
    Pid ! {send, Data}.

recv(Socket) ->
    Self = self(),
    Ctrl = spawn(fun() -> irccontroller:start_controller(Self) end),
    receive
        {tcp, Socket, Data} ->
            spawn(fun() -> manager(Data, Ctrl) end);
        {send, Data} ->
            gen_tcp:send(Socket, Data)
    end,
    recv(Socket).

manager(Data, Ctrl) ->
    String = binary_to_list(Data),
    Msgs = ircstr:parse(String),
    manageline(Msgs, Ctrl).

manageline([], _) -> ok;
manageline([IrcData | Tail], Ctrl) ->
    Ctrl ! {irc, IrcData},
    manageline(Tail, Ctrl).
    

print_user(User) ->
    "NICK " ++ User#ircuser.nickname ++ ?newline
        ++ "USER "
        ++ User#ircuser.username ++ " 0 * :"
        ++ User#ircuser.realname ++ ?newline.

