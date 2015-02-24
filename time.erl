-module(time).
-export([swedish_date/0]).

swedish_date() ->
  {Y, M, D} = date(),
  lists:append([
    pad(integer_to_list(Y rem 100)),
    pad(integer_to_list(M)),
    pad(integer_to_list(D))]).

pad([A]) -> [$0, A];
pad([A, B]) -> [A, B].
