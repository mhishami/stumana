-module (home_ws_controller).
-behaviour (tuah_ws_controller).

-include ("stumana.hrl").

-export ([version/0, handle_ws/2]).

version() -> 1.0.

handle_ws({text, Data}, _Req) ->
    ?DEBUG("Data: ~p~n", [Data]),
    case serial_worker:read() of
        ok -> {text, ok};
        {ok, UID} -> {text, UID}
    end.
    % {text, << <<"You said: ">>/binary, Data/binary >>}.
