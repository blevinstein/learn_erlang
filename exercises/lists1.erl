-module(lists1).
-export([min/1, max/1, min_max/1]).

min([H|[]]) -> H;
min([H|T]) ->
  Min = min(T),
  case H < Min of
    true -> H;
    false -> Min
  end.

max([H|[]]) -> H;
max([H|T]) ->
  Max = max(T),
  case H > Max of
    true -> H;
    false -> Max
  end.

min_max(List) -> {min(List), max(List)}.

