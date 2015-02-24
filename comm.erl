-module(comm).

% Start 2 processes, send a message N times back and forth between them.

-export([main1/0, echo/0]).
-export([main2/0, pass/1]).
-export([main3/0]).

main1() ->
  Echo = spawn(comm, echo, []),
  loop(Echo, "msg", 50).

loop(E, _, 0) -> E ! term;
loop(E, M, N) ->
  io:format("Send ~s~n", [M]),
  E ! {self(), M},
  receive
    X -> io:format("Receive ~s~n", [X])
  end,
  loop(E, M, N-1).

echo() ->
  receive
    term -> done;
    {From, M} -> From ! M,
      echo()
  end.

% Start N processes in a ring, and send a message M times around the ring.

main2() ->
  [H|_] = ring(4, 4),
  H ! "echo".

ring(Nodes, Messages) ->
  Pids = spawnN(Nodes, {comm, pass, [Messages]}),
  Rotated = [lists:nth(Nodes, Pids) | lists:sublist(Pids, Nodes-1)],
  lists:foreach(
    fun({P1, P2}) -> P1 ! {target, P2} end,
    lists:zip(Rotated, Pids)),
  Pids.

spawnN(0, _) -> [];
spawnN(N, {M, F, A}) ->
  Pid = spawn(M, F, A),
  io:format("Spawn ~p~n", [Pid]),
  [Pid | spawnN(N-1, {M, F, A})].

pass(Messages) ->
  receive
    {target, Target} ->
      io:format("I ~p Target ~p~n", [self(), Target]),
      pass(Messages, Target)
  end.

pass(0, _) -> done;
pass(Messages, Target) ->
  receive
    Msg -> Target ! Msg,
           io:format("Pass ~s~n", [Msg]),
           pass(Messages-1, Target)
  end.

% Start N processes in a star, send a message to each M times.

main3() ->
  Pids = spawnN(3, {comm, echo, []}),
  lists:foreach(
    fun(P) -> loop(P, "hi", 3) end,
    Pids),
  lists:foreach(
    fun(P) -> P ! term end,
    Pids).

