-module(irc_test).
-compile(export_all).
-include("irc.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(server, "irc.mjuk.is").
-define(altport, 6697).

server_format_function_test() ->
    ?assertEqual(#server{host=?server}, irc:server_fmt(?server, ?ircport)).

server_format_hostname_test() ->
    Server = irc:server_fmt(?server),
    ?assertEqual(Server#server.host, ?server).

server_format_custom_port_test() ->
    Server = irc:server_fmt(?server, ?altport),
    ?assertEqual(Server#server.port, ?altport).

server_format_custom_port_fail_test() ->
    Server = irc:server_fmt(?server, ?altport),
    ?assertNotEqual(Server#server.port, ?ircport).

user_format_test() ->
    ?assertEqual(irc:user_fmt("user"),
        #ircuser{nickname="user", username="user", realname=?version}).

user_format_fail_test() ->
    ?assertNotEqual(
        irc:user_fmt("user", "user", "NOTREALLY"),
        #ircuser{nickname="user", username="user", realname=?version}
    ).

