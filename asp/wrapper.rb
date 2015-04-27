#!/usr/bin/ruby

require 'tinytable'
require 'date'

answer = `clingo3 -n 1 *.lp 2> /dev/null`

lines = answer.split("\n")

solution = lines[1]
solutions = solution.split(/\s/)

allocate_clauses = solutions.select { |x| x =~ /allocate/ }
total_clauses = solutions.select { |x| x =~ /total/ }

hsh = allocate_clauses.inject({}) do |acc, clause|
  shift, date, firm = clause.match(/allocated\(([^,]*),(\d+),([^,]*)\)/).captures
  date = date.to_i
  acc[date] ||= []
  acc[date] << [shift, firm]
  acc
end

table = TinyTable::Table.new
shifts = ["s1", "s2", "s3", "s4", "s5", "s6"]

table.header = ["", [shifts]].flatten

hsh.keys.sort.each do |date|
  table_row = []
  date_row = hsh[date]
  table_row << date
  shifts.each do |s|
    firm_name = date_row.select { |x| x.first == s }.first.last
    table_row << firm_name
  end
  table << table_row
end

puts table.to_text

total_hsh = total_clauses.inject({}) do |acc, clause|
  firm, total = clause.match(/total_slots_for_firm\(([^,]*),(\d+)\)/).captures
  total = total.to_i
  acc[firm] = total
  acc
end

totals_table = TinyTable::Table.new

totals_table.header = ["Firm", "Total"]

total_hsh.keys.sort.each do |firm|
  firm_total = total_hsh[firm]
  totals_table << [firm, firm_total]
end

puts totals_table.to_text
