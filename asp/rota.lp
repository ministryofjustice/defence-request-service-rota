#begin_lua

  -----------------------------------------------------------
  -- Lua is necessary here as ASP only deals with integer  --
  -- division. In order to fairly distribute slots we need --
  -- to round up the average number of slots to create an  --
  -- upper bound.                                          --
  -----------------------------------------------------------

  function avg_total_slots_reqd(num_slots, num_firms)
    return math.ceil(num_slots / num_firms)
  end

  function min_num_shifts(num_shifts, num_days)
    return math.min(num_shifts - 1, num_days)
  end

  function max_slots_per_shift_firm(num_shifts, num_days)
    return math.ceil(num_days / num_shifts)
  end

#end_lua.

#const num_slots  = 31.
#const num_firms  = 6.
#const num_shifts = 1.
#const num_days   = 31.

% Generate enough allocations such that each shift has
% the required number it needs for each date.
N { allocated(S, Da, D, F) : firm(F) } N :- date(Da, D), shift(S),
  slots_per_shift_day(S, N).

% Define a clause which states how many slots a firm
% has been allocated in total.
total_slots_for_firm(F, N) :- N = #count { allocated(_, _, _, F) }, firm(F).

% Define a clause which states how many slots a firm
% has on any given date.
firm_slots_for_date(F, D, N) :- N = #count { allocated(_, Da, D, F) },
  date(Da, D), firm(F).

% Define a clause which ignores the date, and just tells
% whether a firm is on shift S at any point.
shift_allocated_to_firm(S, F) :- allocated(S, _, _, F).

% Define a clause which states how many different shifts
% a firm has been allocated on one shift.
diff_shifts_for_firm(F, S, N) :- N = #count { shift_allocated_to_firm(_, F) },
  firm(F), shift(S).

% Define a clause which states how many times a firm
% appears on a particular shift.
slots_for_shift_for_firm(F, S, N) :- N = #count { allocated(S, _, _, F) },
  firm(F), shift(S).

% Calculate the average number of slots each firm should have
% and round up. Ensure that all firms have within 1 of the average
% number of slots each.
:- total_slots_for_firm(_, N),
  N > @avg_total_slots_reqd(num_slots, num_firms).
:- total_slots_for_firm(_, N),
  N < @avg_total_slots_reqd(num_slots, num_firms) - 1.

% Make sure that no firm has more than one slot
% on any given date.
:- firm_slots_for_date(_, _, N), N > 1.

% Make sure that no firm appears on one shift vastly more
% than any other.
:- slots_for_shift_for_firm(_, _, N),
  N > @max_slots_per_shift_firm(num_shifts, num_days).

% Make sure that each firm is on each shift at least once.
:- diff_shifts_for_firm(_, S, N), N < @min_num_shifts(num_shifts, num_days).

% Define what it means to have two consecutive dates.
consecutive_dates(D1, D2) :- date(_, D1), date(_, D2), D1 + 1 == D2.
consecutive_dates(D1, D2) :- date(_, D1), date(_, D2), D1 - 1 == D2.

% Make sure that a firm can't be on the same shift
% on two consecutive dates.
:- allocated(S1, Da1, D1, F), allocated(S2, Da2, D2, F), S1 == S2,
  consecutive_dates(D1, D2).

#hide.
#show allocated/4.
#show total_slots_for_firm/2.
