# namespace :test do

#   desc "Run the JSZVCR Tests for iOS"
#   task :ios do
#     simulators = get_ios_simulators
#     destinations = Array.new
#     # collect all sims except for "Resizable sims"
#     simulators.each { |version, available_simulators|
#       # sims for 7.0.3 exist on Travis CI but not on local machines, so remove
#       # because we can't reproduce results locally
#       if (available_simulators[:runtime] != '7.0') || (available_simulators[:runtime] != '7.1')
#         available_simulators[:device_names].each { |device|
#           if !device.match(/^Resizable/)
#             destinations.push("platform=iOS Simulator,OS=#{available_simulators[:runtime]},name=#{device}")
#             puts "Will run tests for iOS Simulator on iOS #{available_simulators[:runtime]} using #{device}"
#           end
#         }
#       end
#     }
#     final_exit_status = 0
#     destinations.each { |destination|
#       puts '**********************************'
#       puts destination
#       puts '**********************************'
#       kill_sim()
#       sleep(5)
#       run_tests('JSZVCR-Example', 'iphonesimulator', destination)
#       current_exit_status = $?.exitstatus
#       if current_exit_status != 0
#         final_exit_status = current_exit_status
#       end
#     }
#     kill_sim()
#     exit final_exit_status
#   end

# end

# desc "Run the JSZVCR Tests for iOS"
# task :test do
#   Rake::Task['test:ios'].invoke
# end

# task :default => 'test'


# private

# def run_tests(scheme, sdk, destination)
#     sim_destination = "-destination \'#{destination}\'"
#     # clean is removed for now, try to get it back in!
#     sh("xcodebuild -workspace JSZVCR.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' #{sim_destination} -configuration 'Debug' test | xcpretty -c; exit ${PIPESTATUS[0]}") rescue nil
# end

# def kill_sim()
#   sh('killall -9 "iOS Simulator" || echo "No matching processes belonging to sim were found"')
# end

# def get_ios_simulators
#   device_section_regex = /== Devices ==(.*?)(?=(?===)|\z)/m
#   runtime_section_regex = /== Runtimes ==(.*?)(?=(?===)|\z)/m
#   runtime_version_regex  = /iOS (.*) \((.*) - .*?\)/
#   xcrun_output = `xcrun simctl list`
#   puts "Available iOS Simulators: \n#{xcrun_output}"
  
#   simulators = Hash.new
#   runtimes_section = xcrun_output.scan(runtime_section_regex)[0]
#   runtimes_section[0].scan(runtime_version_regex) {|result|
#     simulators[result[0]] = Hash.new
#     simulators[result[0]][:runtime] = result[1]
#   }
  
#   device_section = xcrun_output.scan(device_section_regex)[0]
#   version_regex = /-- iOS (.*?) --(.*?)(?=(?=-- .*? --)|\z)/m
#   simulator_name_regex = /(.*) \([A-F0-9-]*\) \(.*\)/
#   device_section[0].scan(version_regex) {|result| 
#     simulators[result[0]][:device_names] = Array.new
#     result[1].scan(simulator_name_regex) { |device_name_result| 
#       device_name = device_name_result[0].strip
#       simulators[result[0]][:device_names].push(device_name)
#     }
#    }
#    return simulators
# end

include FileUtils::Verbose
require 'json'

namespace :test do

  task :prepare do
    puts 'Start'
    kill_open_sims
    clean_all_sims
  end

  desc "Run the JSZVCR Tests for iOS"
  task :ios => :prepare do
    destinations = get_sims_for_run('iOS')
    final_exit_status = 0
    destinations.each { |destination|
      puts '**********************************'
      puts destination
      puts '**********************************'
      sleep(5)
      run_tests('JSZVCR-Example', 'iphonesimulator', destination)
      tests_failed('iOS') unless $?.success?
    }
  end

  desc "Run the JSZVCR Tests for watchOS"
  task :watchos => :prepare do
    destinations = get_sims_for_run('watchOS')
    final_exit_status = 0
    destinations.each { |destination|
      puts '**********************************'
      puts destination
      puts '**********************************'
      sleep(5)
      run_tests('JSZVCR-Example', 'watchsimulator', destination)
      tests_failed('watchOS') unless $?.success?
    }
  end

  desc "Run the JSZVCR Tests for tvOS"
  task :tvos => :prepare do
    destinations = get_sims_for_run('tvOS')
    final_exit_status = 0
    destinations.each { |destination|
      puts '**********************************'
      puts destination
      puts '**********************************'
      sleep(5)
      run_tests('JSZVCR-Example-tvOS', 'appletvsimulator', destination)
      tests_failed('tvOS') unless $?.success?
    }
  end

  desc "Run the JSZVCR Tests for Mac OS X"
  task :osx => :prepare do
    run_tests('JSZVCR-Example-OSX', 'macosx', 'platform=OS X,arch=x86_64')
    tests_failed('OSX') unless $?.success?
  end
end

desc "Run the JSZVCR Tests for various platforms"
task :test do
  Rake::Task['test:ios'].invoke
  # Rake::Task['test:watchos'].invoke
  Rake::Task['test:tvos'].invoke
  Rake::Task['test:osx'].invoke if is_mavericks_or_above
end

task :default => 'test'


private

def run_tests(scheme, sdk, destination)
  sim_destination = "-destination \'#{destination}\'"
  # sh("xcodebuild -workspace JSZVCR.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' #{sim_destination} -configuration 'Debug' test | xcpretty -c; exit ${PIPESTATUS[0]}") rescue nil
  sh("xcodebuild -workspace JSZVCR.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' #{sim_destination} -configuration 'Release' test | xcpretty -tc ; exit ${PIPESTATUS[0]}") rescue nil
end

def is_mavericks_or_above
  osx_version = `sw_vers -productVersion`.chomp
  Gem::Version.new(osx_version) >= Gem::Version.new('10.9')
end

def tests_failed(platform)
  puts red("#{platform} unit tests failed")
  exit $?.exitstatus
end

def red(string)
 "\033[0;31m! #{string} \033[0m"
end

def clean_all_sims()
  puts 'Clean all sims'
  sh('xcrun simctl list devices | grep -v \'^[-=]\' | cut -d "(" -f2 | cut -d ")" -f1 | xargs -I {} xcrun simctl erase "{}"')
end

def kill_open_sims()
  sh('killall -9 "Simulator" || echo "No matching processes belonging to sim were found"')
end

def get_sims_for_run(platform)
  simulators = get_simulators platform
  destinations = Array.new
  simulators.each { |runtime, available_simulators|
    available_simulators.each { |simulator|
      destinations.push("platform=#{platform} Simulator,OS=#{runtime},name=#{simulator}")
    }
  }
  return destinations
end

def get_simulators(platform)
  minimum_runtime_versions = {'iOS' => '8.0', 'watchOS' => '2.0', 'tvOS' => '9.0'}
  return get_simulators_by_platform(platform, minimum_runtime_versions[platform])
end

def get_simulators_by_platform(platform, minimum_supported_runtime)
  devices = JSON.parse(`xcrun simctl list -j`)
  simulators = Hash.new
  devices['devices'].each { |os, simulators_list| 
    if os.start_with?(platform)
      runtime = os.split(' ')[1]
      next if Gem::Version.new(runtime) < Gem::Version.new(minimum_supported_runtime)
      simulators[runtime] = Array.new unless simulators.key?(runtime)
      simulators_list.each { |simulator|
        next unless simulator['availability'] == '(available)' && !simulator['name'].start_with?('Resizable')
        simulators[runtime] << simulator['name']
      }
      simulators[runtime].uniq!
    end
  }
  puts "Test targets for #{platform}\n#{test_targets_info_table(simulators, platform)}"
  simulators
end

def test_targets_info_table(sim, platform)
  index_col_name = 'Target name / runtime'
  runtimes = sim.keys.sort! { |x, y| Gem::Version.new(x) <=> Gem::Version.new(y) }
  runtime_names = runtimes.map { |runtime| "#{platform} #{runtime}" }
  names = (sim.values.flatten.uniq || sim.values.flatten).sort_by!(&:length)
  name_col_width = (Array.new(names) << index_col_name).sort_by(&:length).last.length + 2
  runtime_col_width = runtime_names.sort_by(&:length).last.length + 2
  column_names = runtime_names.insert(0, index_col_name)
  separator = '+'
  column_names.each_index { |index| 
    separator << ''.ljust((index == 0 ? name_col_width : runtime_col_width), '-') << ((index == column_names.length - 1) ? "+\n" : '+')
  }
  table = separator.dup
  rows = names.insert(0, index_col_name)
  rows.map! { |value| 
    is_header = value == rows.first
    row = '|'
    column_names.each_index { |index| 
      col_value = (value == rows.first ? column_names[index] : (index == 0 ? value : sim[runtimes[index-1]].include?(value) ? '+' : '-'))
      left_offset = (((index == 0 ? name_col_width : runtime_col_width) - col_value.length) * 0.5).round
      right_offset = (index == 0 ? name_col_width : runtime_col_width) - col_value.length - left_offset
      row << ''.ljust(left_offset, ' ') << col_value <<  ''.ljust(right_offset, ' ') << ((index == column_names.length - 1) ? "|\n" : '|')
    }
    row
  }
  table << rows.join("#{separator}") << separator
end
