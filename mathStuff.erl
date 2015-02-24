-module(mathStuff).
-export([perimeter/1]).

perimeter({square, S}) -> 4 * S;
perimeter({circle, R}) -> math:pi() * 2 * R;
perimeter({triangle, A, B, C}) -> A + B + C.
