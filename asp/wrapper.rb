#!/usr/bin/ruby

require "tinytable"
require "date"

NO_SHIFTS = 5
SHIFT_NAMES = (1..NO_SHIFTS).map { |i| "s#{i}" }

def process_allocations(allocate_clauses)
  puts <<-EOM
+-------------+
| ALLOCATIONS |
+-------------+

  EOM

  hsh = allocate_clauses.inject({}) do |acc, clause|
    shift, date, firm = extract_allocation(clause)
    date_obj = Date.new(2015, 5, date.to_i)
    acc[date_obj] ||= []
    acc[date_obj] << [shift, firm]
    acc
  end

  table_rows = []
  hsh.keys.sort.each do |date|
    table_row = []
    date_row = hsh[date]
    table_row << date.strftime("%a, %d/%m/%Y")
    SHIFT_NAMES.each do |s|
      firm_name = date_row.select { |x| x.first == s }.map(&:last)
      table_row << firm_name
    end
    table_rows << table_row
  end

  header = ["", SHIFT_NAMES].flatten

  print_table(header, table_rows)
end

def process_totals(total_clauses)
  puts <<-EOM
===================================================================================================
+--------+
| TOTALS |
+--------+

  EOM

  total_hsh = total_clauses.inject({}) do |acc, clause|
    firm, total = extract_total(clause)
    acc[firm] = total.to_i
    acc
  end

  table_rows = []
  total_hsh.keys.sort.each do |firm|
    firm_total = total_hsh[firm]
    table_rows << [firm, firm_total]
  end

  header = %w[Firm Total]

  print_table(header, table_rows)
end

def process_shift_totals(total_shift_clauses)
  puts <<-EOM
===================================================================================================
+--------------+
| SHIFT TOTALS |
+--------------+

  EOM
  shift_hsh = total_shift_clauses.inject({}) do |acc, clause|
    firm, shift, total = extract_shift_total(clause)
    acc[firm] ||= {}
    acc[firm][shift] = total.to_i
    acc
  end

  table_rows = []
  shift_hsh.keys.sort.each do |firm|
    this_row = [firm]
    firm_shifts = shift_hsh[firm]
    SHIFT_NAMES.each do |shift|
      this_row << firm_shifts[shift]
    end
    table_rows << this_row
  end

  header = ["", SHIFT_NAMES].flatten

  print_table(header, table_rows)
end

def extract_allocation(clause)
  clause.match(/allocated\(([^,]*),[^,]*,(\d+),([^,]*)\)/).captures
end

def extract_total(clause)
  clause.match(/total_slots_for_firm\(([^,]*),(\d+)\)/).captures
end

def extract_shift_total(clause)
  clause.match(/slots_for_shift_for_firm\(([^,]*),([^,]*),(\d+)\)/).captures
end

def print_table(header, rows)
  table = TinyTable::Table.new

  table.header = header

  rows.each do |r|
    table << r
  end

  puts table.to_text
end

answer = `clingo3 -n 1 *.lp 2> /dev/null`

lines = answer.split("\n")

unsatisfiable = lines.find { |l| l =~ /UNSATISFIABLE/ }

if unsatisfiable
  puts "No solution possible."
else
  clauses = lines.reverse.find { |l| l =~ /allocated/ }.split(/\s/)

  allocate_clauses    = clauses.select { |x| x =~ /allocate/ }
  total_clauses       = clauses.select { |x| x =~ /total_slots_for_firm/ }
  total_shift_clauses = clauses.select { |x| x =~ /slots_for_shift_for_firm/ }

  process_allocations(allocate_clauses)

  process_totals(total_clauses)

  process_shift_totals(total_shift_clauses)
end
