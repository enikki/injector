-module(colors).

-export([find/2]).

-export([
         fitness/2,
         check_fitness/4,
         get_rgb/1,
         to_hex/1
        ]).

-record(color, {need, avail, best, best_fitness}).


find(Needful, AvailColors) ->
     find(Needful, AvailColors, #color{}).


find(Need, Avail, Color) ->
    ok.



get_rgb(Color) ->
    {(Color band 16#FF0000) bsr 16, (Color band 16#00FF00) bsr 8, (Color band 16#0000FF)}.

to_hex({R,G,B}) ->
    erlang:integer_to_list(
      R bsl 16 + G bsl 8, B, 16).



blend_colors(C1, C2, T) ->
    blend_color_values(get_rgb(C1), get_rgb(C2), T).

blend_color_values({R1, G1, B1}, {R2, G2, B2}, T) ->
%%    √̅(̅1̅-̅t̅)̅*̅a̅²̅ ̅+̅ ̅t̅*̅b̅²̅)
    {
      math:sqrt( (1-T) * R1 * R1 + T * R2*R2),
      math:sqrt((1-T) * G1 * G1 + T * G2*G2),
      math:sqrt((1-T) * B1 * B1 + T * B2*B2)
    }.

%%------------------------------------------------------------

fitness(Needful, Color) ->
    math:sqrt(
          math:pow((Needful band 16#00FF00 - Color band 16#00FF00) bsr 8, 2) +
          math:pow((Needful band 16#FF0000 - Color band 16#FF0000)  bsr 16, 2) +
          math:pow(Needful band 16#0000FF - Color band 16#0000FF, 2)
     ).


check_fitness(undefined, undefined, NextColor, NextFitness) ->
    {NextColor, NextFitness};
check_fitness(_PrevColor, PrevFitness, NextColor, NextFitness) when NextFitness < PrevFitness->
    {NextColor, NextFitness};
check_fitness(PrevColor, PrevFitness, _, _) ->
    {PrevColor, PrevFitness}.
