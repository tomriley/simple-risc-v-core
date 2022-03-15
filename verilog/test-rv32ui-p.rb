#!/usr/bin/env ruby

RESET  = "\033[0m"
BLACK  = "\033[30m"
RED    = "\033[31m" 
GREEN  = "\033[32m" 
YELLOW = "\033[33m"
BLUE   = "\033[34m"

passed = 0
failed = 0

`make`
if !$?.success?
  puts 'Verilog compile seems to be failing'
end
  
Dir.glob('tests/rv32ui-p-*').sort.each do |f|
  puts f
  `vvp -N core_tb +MEM=#{f}` # -N make $fail() exit with code 1
  if $?.success? # this is because we have to 
    puts GREEN + "  PASSED" + RESET
    passed += 1
  else
    puts RED + "  FAILING" + RESET
    failed += 1
  end
end
puts "\n  (#{passed} / #{passed + failed}) tests passed\n"
