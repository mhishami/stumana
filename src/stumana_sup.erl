-module(stumana_sup).
-behaviour(supervisor).

-include ("stumana.hrl").

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  Serial = ?CHILD(serial_worker, worker),
	Procs = [Serial],
	{ok, {{one_for_one, 1, 5}, Procs}}.
