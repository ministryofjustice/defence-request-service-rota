#!/usr/bin/ruby

require "optparse"
require "pp"

def generate_shifts!(no_shifts)
  File.open("shifts.lp", "w+") do |f|
    (1..no_shifts).each do |i|
      f.write("shift(s#{i}).\n")
    end
  end
end

def generate_per_days!(no_shifts, no_days)
  File.open("per_day.lp", "w+") do |f|
    (1..no_shifts).each do |s|
      days = %w{fri sat sun mon tue wed thu}
      day = days.cycle

      (1..no_days).each do |i|
        f.write("slots_per_shift_date(s#{s}, #{day.next}, #{i}, 1).\n")
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
    days = %w{fri sat sun mon tue wed thu}
    day = days.cycle

    (1..no_days).each do |i|
      f.write("date(#{day.next}, #{i}).\n")
    end
  end
end

def generate_constants!(options)
  File.open("constants.lp", "w+") do |f|
    f.write("#const num_firms = #{options[:firms]}.\n")
    f.write("#const num_shifts = #{options[:shifts]}.\n")
    f.write("#const num_days = #{options[:days]}.\n")
    f.write("#const num_slots = #{options[:days] * options[:shifts]}.\n")
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
generate_per_days!(options[:shifts], options[:days])
generate_firms!(options[:firms])
generate_days!(options[:days])
generate_constants!(options)
