%%%%%%%
% LUA %
%%%%%%%

#begin_lua

  -----------------------------------------------------------
  -- Lua is necessary here as ASP only deals with integer  --
  -- division. In order to fairly distribute slots we need --
  -- to round up the average number of slots to create an  --
  -- upper bound.                                          --
  -----------------------------------------------------------

  -- 1) The maximum total slots allowed for each firm
  function max_total_slots_allowed(num_slots, num_firms)
    return math.ceil(num_slots / num_firms)
  end

  -- 2) The minimum total slots allowed for each firm
  function min_total_slots_allowed(num_slots, num_firms)
    return math.floor(num_slots / num_firms)
  end

  -- 3)
  function min_slots_per_shift_firm(slots_for_shift, num_firms)
    return math.floor(slots_for_shift / num_firms)
  end

  -- 4)
  function max_slots_per_shift_firm(slots_for_shift, num_firms)
    return math.ceil(slots_for_shift / num_firms)
  end

  -- 5)
  function max_slots_for_date(num_firms_required, num_firms)
    return math.ceil(num_firms_required / num_firms)
  end

  -- 6)
  function min_slots_for_date(num_firms_required, num_firms)
    return math.floor(num_firms_required / num_firms)
  end

#end_lua.

%%%%%%%%%%%%%%
% GENERATORS %
%%%%%%%%%%%%%%

% Generate enough allocations such that each shift has
% the required number it needs for each date.
N { allocated(S, Da, D, F) : firm(F) } N :-
  slots_per_shift_date(S, Da, D, N),
  date(Da, D),
  shift(S).

%%%%%%%%%%%%%%%%%%%
% UTILITY CLAUSES %
%%%%%%%%%%%%%%%%%%%

% Define a clause which states the total number of
% slots to fill for the entire rota.
total_slots(N) :-
  N = #sum [ slots_per_shift_date(_, _, _, X) = X].

% Define a clause which states how many slots a firm
% has been allocated in total.
total_slots_for_firm(F, N) :-
  N = #count { allocated(_, _, _, F) },
  firm(F).

% Define a clause which states how many slots a firm
% has on any given date.
firm_slots_for_date(F, D, N) :-
  N = #count { allocated(_, _, D, F) },
  date(_, D),
  firm(F).

% Define a clause which states how many slots are required across
% shifts for a given day of the week.
total_slots_required_on_date(D, N) :-
  N = #sum [ slots_per_shift_date(_, _, D, X) = X],
  date(_, D).

% Define a clause which states how many slots are required across
% all days for a specific shift.
total_slots_for_shift(S, N) :-
  N = #sum [ slots_per_shift_date(S, _, _, X) = X],
  shift(S).

% Define a clause which states how many times a firm has been
% allocated on a day of the week.
slots_for_firm_on_day(F, Da, N) :-
  N = #count { allocated(_, Da, _, F) },
  date(Da, _),
  firm(F).

% Define a clause which states how many times a firm
% appears on a particular shift.
slots_for_shift_for_firm(F, S, N) :-
  N = #count { allocated(S, _, _, F) },
  firm(F),
  shift(S).

% Define what it means to have two consecutive dates.
consecutive_dates(D1, D2) :-
  date(_, D1),
  date(_, D2),
  D1 + 1 == D2.

consecutive_dates(D1, D2) :-
  date(_, D1),
  date(_, D2),
  D1 - 1 == D2.

% Identify when a firm is on the same shift on two consecutive dates.
allocated_on_consecutive_dates(F) :-
  allocated(S1, Da1, D1, F),
  allocated(S2, Da2, D2, F),
  consecutive_dates(D1, D2),
  S1 == S2.

%%%%%%%%%%%%%%%
% CONSTRAINTS %
%%%%%%%%%%%%%%%

% Ensure that the total number of slots allocated to each firm
% is within a fairness window.
% This window is the range
%   floor(X/F)..ceil(X/F)
% where X = total number of slots
%       F = total number of firms
:- total_slots_for_firm(_, N), total_slots(X),
  N > @max_total_slots_allowed(X, num_firms).
:- total_slots_for_firm(_, N), total_slots(X),
  N < @min_total_slots_allowed(X, num_firms).

% Ensure that the total number of slots allocated to each firm
% on any specific date is within a fairness window.
% This window is the range
%   floor(R/F)..ceil(K/F)
% where R = total number of slots required for that day
%       F = total number of firms
:- firm_slots_for_date(_, D, N), total_slots_required_on_date(D, R),
  N > @max_slots_for_date(R, num_firms).
:- firm_slots_for_date(_, D, N), total_slots_required_on_date(D, R),
  N < @min_slots_for_date(R, num_firms).

% Ensure that the total number of slots allocated to each firm
% on any specific shift is within a fairness window.
% This window is the range
%   floor(K/F)..ceil(K/F)
% where K = total number of slots required for that shift
%       F = total number of firms
:- slots_for_shift_for_firm(_, S, N), total_slots_for_shift(S, K),
  N > @max_slots_per_shift_firm(K, num_firms).
:- slots_for_shift_for_firm(_, S, N), total_slots_for_shift(S, K),
  N < @min_slots_per_shift_firm(K, num_firms).

%%%%%%%%%%%%%%%%%
% OPTIMIZATIONS %
%%%%%%%%%%%%%%%%%

% Minimize (don't completely disallow) the same shift on
% consecutive days. This is a soft constraint to ensure that
% in small scenarios (for example when num_firms < num_shifts)
% there is a still a valid solution.
#minimize { allocated_on_consecutive_dates(_) }.

%%%%%%%%%%%%%%%%
% PRESENTATION %
%%%%%%%%%%%%%%%%

#hide.
#show allocated/4.
% #show total_slots_for_firm/2.
% #show slots_for_shift_for_firm/3.
% #show slots_for_firm_on_day/3.
