-module(irc_test).
-compile(export_all).
-include("irc.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(server, "irc.mjuk.is").
-define(port, 6667).
-define(altport, 6697).

server_format_function_test() ->
    ?assertEqual(#server{host=?server}, irc:server(?server, ?port)).

server_format_hostname_test() ->
    Server = irc:server(?server),
    ?assertEqual(Server#server.host, ?server).

server_format_custom_port_test() ->
    Server = irc:server(?server, ?altport),
    ?assertEqual(Server#server.port, ?altport).

server_format_custom_port_fail_test() ->
    Server = irc:server(?server, ?altport),
    ?assertNotEqual(Server#server.port, ?port).

user_format_test() ->
    ?assertEqual(irc:user("user"),
        #ircuser{nickname="user", username="user", realname=?version}).

user_format_fail_test() ->
    ?assertNotEqual(
        irc:user("user", "user", "NOTREALLY"),
        #ircuser{nickname="user", username="user", realname=?version}
    ).

