puts ""
puts "###############################################################################"
puts "#                                                                             #"
puts "# CARNOT ENGINES - ONE EXHAUSTIBLE RESERVOIR WRT HEAT version 01.10           #"
puts "# Copyright 2011-2015 by Mark Ciotola  GNU license   www.heatsuite.com        #"
puts "#                                                                             #"
puts "###############################################################################"
puts ""

      ###############################################################################
      #                                                                             #
      # Created on 5 September 2014. Last revised on 18 February 2015.              #
      #_____________________________________________________________________________#
      #                                                                             #
      # Developed with Ruby 2.0.0                                                   #
      #                                                                             #
      ###############################################################################


# Require

  require "csv"


# Set Parameters

  hotenergyinit = 1000000.0   # Initial energy of hot reservoir in J (U_h)
  hotspecificheat = 1.0       # Specific heat of hot reservoir in J/(kg K) (C_h)
  hotvolume = 1000.0          # Volume of hot reservoir in m^3 (V_h)
  coldtemp = 300.0            # Temperature of cold reservoir in K (T_c)

  engineconsumption = 10000.0 # J/s; serves as heat flow increment (Q_h)
                              # 300.0 provides a long tail
                              # 500.0 is short
                              # 1000.0 is even shorter

# Initialize Variables

  hotenergy = hotenergyinit #J
  hottemp = hotenergy/(hotvolume * hotspecificheat) #K
  cumheatflow = 0.0
  cumwork = 0.0

  puts "\n"
  puts "PARAMETERS AND INITIAL VALUES:\n"
  puts "\n"
  puts sprintf "  Hot reservoir energy (U): \t\t\t\t %7.0f J" , hotenergyinit.to_s
  puts sprintf "  Hot reservoir initial temperature (T): \t\t %7.3f K" , hottemp.to_s
  puts sprintf "  Cold reservoir initial temperature (T): \t\t %7.3f K" , coldtemp.to_s
  puts "\n"


# CREATE OUTPUT FILE

  prompt = ">"

  puts "What is the desired name for your output file? [carnot_exhaust_one_output_wrt_heat.csv]:"
  print prompt
  carnot_exhaust_one_output = STDIN.gets.chomp()

  if carnot_exhaust_one_output > ""
      carnot_exhaust_one_output = carnot_exhaust_one_output
    	else
      carnot_exhaust_one_output = "carnot_exhaust_one_output_wrt_heat" #+ efficiency_decay.to_s + "_" + bubble.growthfactor.to_s + "_v02.txt"
  end

  carnot_exhaust_one_output = carnot_exhaust_one_output + ".csv"

  # target = File.open(carnot_exhaust_one_output, 'w')  # If writing to a text file


# Display Simulation Banner

  puts "\n"
  puts "RESULTS: \n"
  puts "\n"
  puts " Q_h  \t U_h  \t∑Q_h k\t T_h  \t T_c  \tEffic\t Work  \t  ∑ Work \t ∆ S_h \t ∆ S_c  \n"
  puts "------\t------\t------\t------\t------\t-----\t-------\t --------\t-------\t------- \n"


# Calculate and Display Results

  while coldtemp < hottemp
      
    # Calculate results
    
      efficiency = 1 - (coldtemp/hottemp)
  
      work = (engineconsumption * efficiency)
  
      hotenergy = hotenergy - engineconsumption
    
      cumheatflow = cumheatflow + engineconsumption
  
      cumwork = cumwork + work
  
      hotentropychange = - engineconsumption / hottemp
  
      coldentropychange = (engineconsumption - work) / coldtemp
 

    # Set Variable Short Names

      ec = engineconsumption
      chf = cumheatflow * 0.001
      ht = hottemp
      ct = coldtemp
      he = hotenergy
      eff = efficiency
      wk = work
      cw = cumwork
      hs = hotentropychange
      cs = coldentropychange


    # Display Results
    
      mystring = ("%6.0f\t%6.0f\t%6.0f\t%6.1f\t%6.0f\t%5.3f\t%7.2f\t%9.2f\t%7.2f\t%7.2f")
      puts sprintf mystring, ec.to_s, he.to_s, chf.to_s, ht.to_s, ct.to_s, eff.to_s, wk.to_s, cw.to_s, hs.to_s, cs.to_s

    # Write to Output File
      periodstring = chf.to_s+"\t"+ht.to_s+"\t"+ct.to_s+"\t"+eff.to_s+"\t"+wk.to_s+"\t"+cw.to_s # +"\t"+hs.to_s+"\t"+cs.to_s

      CSV.open(carnot_exhaust_one_output, "a+") do |csv|
      csv << [chf.to_s, eff.to_s, wk.to_s, cw.to_s]
    end

    #target.write(periodstring)    # If writing to a text file
    #target.write("\n")            # If writing to a text file


    # Update hot temperature

      hottemp = hotenergy/(hotvolume * hotspecificheat) # in K

  end # for loop


  puts "\n"


  # CLOSE OUTPUT FILE    # If writing to a text file
  # target.close()         # If writing to a text file

puts "\nSimulation is completed. \n\n"


# Reference Information

  puts "\n"
  puts "================================= Columns Key =================================\n\n"
  puts "\n"
  puts "       Q_h     engine consumption"
  puts "       ∑Q_h    cumulative heat flow"
  puts "       U_h     hot energy"
  puts "       T_h     hot reservoir temperature"
  puts "       T_c     cold reservoir temperature"
  puts "       Effic   efficiency"
  puts "       Work    work"
  puts "       ∑ Work  cumulative work"
  puts "       ∆ S_h   hot entropy change"
  puts "       ∆ S_c   cold entropy change"
  puts "\n"
  puts "\n"


  puts "================================== Units Key ==================================\n\n"
  puts "  Abbreviation: \t\t Unit:"
  puts "\n"
  puts "       J \t\t\t Joules, a unit of energy"
  puts "       K \t\t\t Kelvin, a unit of temperature"
  puts "       m \t\t\t meters, a unit of length"
  puts "       kg \t\t\t kilograms, a unit of mass"
  puts "       s \t\t\t seconds, a unit of time"
  puts "\n"
  puts "\n"
  puts "================================== References =================================\n\n"
  puts "Daniel V. Schroeder, 2000, \"An Introduction to Thermal Physics.\""
  puts "\n\n"

# Draw flowchart for Olivia
