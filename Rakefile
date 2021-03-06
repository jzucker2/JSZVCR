namespace :test do

  desc "Run the JSZVCR Tests for iOS"
  task :ios do
    simulators = get_ios_simulators
    destinations = Array.new
    # collect all sims except for "Resizable sims"
    simulators.each { |version, available_simulators|
      # sims for 7.0.3 exist on Travis CI but not on local machines, so remove
      # because we can't reproduce results locally
      if (available_simulators[:runtime] != '7.0') || (available_simulators[:runtime] != '7.1')
        available_simulators[:device_names].each { |device|
          if !device.match(/^Resizable/)
            destinations.push("platform=iOS Simulator,OS=#{available_simulators[:runtime]},name=#{device}")
            puts "Will run tests for iOS Simulator on iOS #{available_simulators[:runtime]} using #{device}"
          end
        }
      end
    }
    final_exit_status = 0
    destinations.each { |destination|
      puts '**********************************'
      puts destination
      puts '**********************************'
      kill_sim()
      sleep(5)
      run_tests('JSZVCR-Example', 'iphonesimulator', destination)
      current_exit_status = $?.exitstatus
      if current_exit_status != 0
        final_exit_status = current_exit_status
      end
    }
    kill_sim()
    exit final_exit_status
  end

end

desc "Run the JSZVCR Tests for iOS"
task :test do
  Rake::Task['test:ios'].invoke
end

task :default => 'test'


private

def run_tests(scheme, sdk, destination)
    sim_destination = "-destination \'#{destination}\'"
    # clean is removed for now, try to get it back in!
    sh("xcodebuild -workspace JSZVCR.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' #{sim_destination} -configuration 'Debug' test | xcpretty -c; exit ${PIPESTATUS[0]}") rescue nil
end

def kill_sim()
  sh('killall -9 "iOS Simulator" || echo "No matching processes belonging to sim were found"')
end

def get_ios_simulators
  device_section_regex = /== Devices ==(.*?)(?=(?===)|\z)/m
  runtime_section_regex = /== Runtimes ==(.*?)(?=(?===)|\z)/m
  runtime_version_regex  = /iOS (.*) \((.*) - .*?\)/
  xcrun_output = `xcrun simctl list`
  puts "Available iOS Simulators: \n#{xcrun_output}"
  
  simulators = Hash.new
  runtimes_section = xcrun_output.scan(runtime_section_regex)[0]
  runtimes_section[0].scan(runtime_version_regex) {|result|
    simulators[result[0]] = Hash.new
    simulators[result[0]][:runtime] = result[1]
  }
  
  device_section = xcrun_output.scan(device_section_regex)[0]
  version_regex = /-- iOS (.*?) --(.*?)(?=(?=-- .*? --)|\z)/m
  simulator_name_regex = /(.*) \([A-F0-9-]*\) \(.*\)/
  device_section[0].scan(version_regex) {|result| 
    simulators[result[0]][:device_names] = Array.new
    result[1].scan(simulator_name_regex) { |device_name_result| 
      device_name = device_name_result[0].strip
      simulators[result[0]][:device_names].push(device_name)
    }
   }
   return simulators
end
