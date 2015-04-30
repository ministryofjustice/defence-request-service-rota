#!/usr/bin/ruby

require "optparse"
require "pp"

def generate_shifts!(no_shifts)
  File.open("shifts.lp", "w+") do |f|
    (1..no_shifts).each do |i|
      f.write("shift(s#{i}).\n")
    end
  end

  File.open("per_day.lp", "w+") do |f|
    (1..no_shifts).each do |i|
      %w{mon tue wed thu fri sat sun}.each do |day|
        f.write("slots_per_shift_day(s#{i}, #{day}, 1).\n")
      end

      f.write("\n")
    end
  end
end

def generate_firms!(no_firms)
  File.open("firms.lp", "w+") do |f|
    (1..no_firms).each do |i|
      firm_name = (96 + i).chr
      f.write("firm(#{firm_name}).\n")
    end
  end
end

def generate_days!(no_days)
  File.open("dates.lp", "w+") do |f|
    days = %w{fri sat sun mon tue wed thu fri}
    day = days.cycle

    (1..no_days).each do |i|
      f.write("date(#{day.next}, #{i}).\n")
    end
  end
end

options = {}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: generate.rb [options]"

  opts.on("--shifts=SHIFTS", "Specify a number of shifts") do |sh|
    options[:shifts] = sh.to_i
  end

  opts.on("--firms=FIRMS", "Specify a number of firms") do |fi|
    options[:firms] = fi.to_i
  end

  opts.on("--days=DAYS", "Specify a number of days") do |da|
    da = da.to_i
    if da > 31
      puts "Setting days to 31."
      da = 31
    end
    options[:days] = da
  end

  opts.on("--debug", "Debug mode") do |d|
    options[:debug] = true
  end

  options[:shifts] ||= 4
  options[:firms] ||= 4
  options[:days] ||= 7
end

parser.parse!

if options[:debug]
  puts "=== DEBUG ==="
  options.each_pair do |k, v|
    puts "#{k.to_s.capitalize}: #{v}"
  end
  puts "============="
end

generate_shifts!(options[:shifts])
generate_firms!(options[:firms])
generate_days!(options[:days])
