-module (serial_worker).
-behaviour (gen_server).
-author ('Hisham Ismail <mhishami@gmail.com>').

-include ("stumana.hrl").

%% API.
-export([start_link/0]).
-export ([read/0]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-record(state, {fd}).

-define (SPEED, b115200).
-define (DEV, "/dev/cu.usbmodem1411").

% =============================================================================
% Exported functions
% =============================================================================
-spec start_link() -> {ok, pid()}.
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

read() ->
    gen_server:call(?MODULE, {read}).

% =============================================================================
% gen_server callbacks
% =============================================================================
-spec init(list()) -> {ok, any()}.
init([]) ->
    {DEV, SPEED} = case application:get_env(stumana, serial) of
        {ok, [{device, Dev}, {speed, Speed}]} -> {Dev, Speed};
        _ -> 
            ?ERROR("Invalid serial settings...", []),
            {none, none}
    end,
    ?DEBUG("DEV: ~p, SPEED: ~p", [DEV, SPEED]),

    {ok, FD} = serctl:open(DEV),
    Termios = lists:foldl(
        fun(Fun, Acc) -> Fun(Acc) end,
        serctl:mode(raw),
        [
            fun(N) -> serctl:flow(N, false) end,
            fun(N) -> serctl:ispeed(N, SPEED) end,
            fun(N) -> serctl:ospeed(N, SPEED) end
        ]
    ),
    ok = serctl:tcsetattr(FD, tcsanow, Termios),
    {ok, _} = serctl:tcgetattr(FD),
    {ok, #state{fd=FD}}.

-spec handle_call(any(), any(), any()) -> {ok, any()} | {error, any()}.
handle_call({read}, _From, #state{fd=FD} = State) ->
    case serctl:read(FD, 512) of
        {ok, <<>>} ->
            {reply, ok, State};
        {ok, Data} ->
            % ?DEBUG(">> ~p~n", [Data]),
            case binary:split(Data, <<"Value:  ">>) of
                <<>> ->
                    {reply, ok, State};
                List ->
                    % ?DEBUG("List: ~p~n", [List]),
                    % normally on the second one
                    case catch binary:split(lists:nth(2, List), <<"\r\n\r\n">>) of
                        L2 when is_list(L2) ->
                            % ?DEBUG("L2= ~p~n", [L2]),
                            {reply, {ok, lists:nth(1, L2)}, State};
                        _ ->
                            {reply, ok, State}
                    end
            end
    end;

handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

-spec handle_cast(any(), any()) -> {noreply, any()}.
handle_cast(_Msg, State) ->
    {noreply, State}.

-spec handle_info(any(), any()) -> {noreply, any()}.
handle_info(_Info, State) ->
    {noreply, State}.

-spec terminate(any(), any()) -> ok.
terminate(_Reason, _State) ->
    ok.

-spec code_change(any(), any(), any()) -> {ok, any()}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


