#begin_lua

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

#const num_slots  = 180.
#const num_firms  = 6.
#const num_shifts = 6.
#const num_days   = 30.

% Generate enough allocations such that each shift has
% the required number it needs for each date.
N { allocated(S, D, F) : firm(F) } N :- date(D), shift(S),
  slots_per_shift_day(S, N).

% Define a clause which states how many slots a firm
% has been allocated in total.
total_slots_for_firm(F, N) :- N = #count { allocated(_, _, F) }, firm(F).

% Define a clause which states how many slots a firm
% has on any given date.
firm_slots_for_date(F, D, N) :- N = #count { allocated(_, D, F) },
  date(D), firm(F).

% Define a clause which ignores the date, and just tells
% whether a firm is on shift S at any point.
shift_allocated_to_firm(S, F) :- allocated(S, _, F).

% Define a clause which states how many different shifts
% a firm has been allocated on one shift.
diff_shifts_for_firm(F, S, N) :- N = #count { shift_allocated_to_firm(_, F) },
  firm(F), shift(S).

% Define a clause which states how many times a firm
% appears on a particular shift.
slots_for_shift_for_firm(F, S, N) :- N = #count { allocated(S, _, F) },
  firm(F), shift(S).

% Make sure that no firm has more than the upper
% average number of slots.
:- total_slots_for_firm(_, N), N > @avg_total_slots_reqd(num_slots, num_firms).

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
consecutive_dates(D1, D2) :- date(D1), date(D2), D1 + 1 == D2.
consecutive_dates(D1, D2) :- date(D1), date(D2), D1 - 1 == D2.

% Make sure that a firm can't be on the same shift
% on two consecutive dates.
:- allocated(S1, D1, F), allocated(S2, D2, F), S1 == S2,
  consecutive_dates(D1, D2).

#hide.
#show allocated/3.
#show total_slots_for_firm/2.
