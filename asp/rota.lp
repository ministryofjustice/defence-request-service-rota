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

  -- 2)
  function max_num_diff_shifts(num_slots, num_firms)
    return math.ceil(num_slots / num_firms)
  end

  -- 3)
  function min_num_diff_shifts(num_slots, num_firms)
    return math.floor(num_slots / num_firms)
  end

  -- 4)
  function min_slots_per_shift_firm(num_slots, num_shifts, num_firms)
    return math.floor(num_slots / (num_shifts * num_firms))
  end

  -- 5)
  function max_slots_per_shift_firm(num_slots, num_shifts, num_firms)
    return math.ceil(num_slots / (num_shifts * num_firms))
  end

  -- 6)
  function max_slots_per_day(num_firms_required, num_firms)
    return math.ceil(num_firms_required / num_firms)
  end

#end_lua.

%%%%%%%%%%%%%
% CONSTANTS %
%%%%%%%%%%%%%

#const num_slots  = 21.
#const num_firms  = 2.
#const num_shifts = 3.
#const num_days   = 7.

%%%%%%%%%%%%%%
% GENERATORS %
%%%%%%%%%%%%%%

% Generate enough allocations such that each shift has
% the required number it needs for each date.
N { allocated(S, Da, D, F) : firm(F) } N :- date(Da, D), shift(S),
  slots_per_shift_day(S, Da, N).

%%%%%%%%%%%%%%%%%%%
% UTILITY CLAUSES %
%%%%%%%%%%%%%%%%%%%

% Define a clause which states how many slots a firm
% has been allocated in total.
total_slots_for_firm(F, N) :- N = #count { allocated(_, _, _, F) }, firm(F).

% Define a clause which states how many slots a firm
% has on any given date.
firm_slots_for_day(F, Da, N) :- N = #count { allocated(_, Da, D, F) },
  date(Da, D), firm(F).

% Define a clause which ignores the date, and just tells
% whether a firm is on shift S at any point.
shift_allocated_to_firm(S, F) :- allocated(S, _, _, F).

total_slots_required_on_day(Da, N) :-
  N = #sum [ slots_per_shift_day(_, Da, X) = X], date(Da, _).

% Define a clause which states how many different shifts
% a firm has been allocated on one shift.
diff_shifts_for_firm(F, S, N) :- N = #count { shift_allocated_to_firm(_, F) },
  firm(F), shift(S).

% Define a clause which states how many times a firm
% appears on a particular shift.
slots_for_shift_for_firm(F, S, N) :- N = #count { allocated(S, _, _, F) },
  firm(F), shift(S).

% Define what it means to have two consecutive dates.
consecutive_dates(D1, D2) :- date(_, D1), date(_, D2), D1 + 1 == D2.
consecutive_dates(D1, D2) :- date(_, D1), date(_, D2), D1 - 1 == D2.

% Identify when a firm is on the same shift on two consecutive dates.
allocated_on_consecutive_days(F) :- allocated(S1, Da1, D1, F),
  allocated(S2, Da2, D2, F), S1 == S2, consecutive_dates(D1, D2).

%%%%%%%%%%%%%%%
% CONSTRAINTS %
%%%%%%%%%%%%%%%

% Calculate the average number of slots each firm should have
% and round up. Ensure that all firms have within 1 of the average
% number of slots each.
:- total_slots_for_firm(_, N),
  N > @max_total_slots_allowed(num_slots, num_firms).
:- total_slots_for_firm(_, N),
  N < @max_total_slots_allowed(num_slots, num_firms) - 1.

% Make sure that no firm has more than one slot
% on any given date.
:- firm_slots_for_day(_, Da, N), total_slots_required_on_day(Da, R),
  N > @max_slots_per_day(R, num_firms).

% Make sure that no firm appears on one shift vastly more
% than any other.
:- slots_for_shift_for_firm(_, _, N),
  N > @max_slots_per_shift_firm(num_slots, num_shifts, num_firms).
:- slots_for_shift_for_firm(_, _, N),
  N < @min_slots_per_shift_firm(num_slots, num_shifts, num_firms).

% Make sure that each firm is on each shift at least once.
% This gets complicated if there are more shifts than there are
% days (hence why Lua does this minimum calculation).
:- diff_shifts_for_firm(_, S, N), num_days > num_shifts, N < num_shifts.
:- diff_shifts_for_firm(_, S, N), num_days <= num_shifts, N >
  max_num_diff_shifts(num_slots, num_firms).
:- diff_shifts_for_firm(_, S, N), num_days <= num_shifts, N <
  min_num_diff_shifts(num_slots, num_firms).

% Minimize (don't completely disallow) the same shift on
% consecutive days.
#minimize { allocated_on_consecutive_days(_) }.

%%%%%%%%%%%%%%%%
% PRESENTATION %
%%%%%%%%%%%%%%%%

#hide.
#show allocated/4.
#show total_slots_for_firm/2.
