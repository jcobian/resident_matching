require './seeds'
require './match_algorithm'

def match
  seed_info = create_seed_data
  applicant_info = seed_info[:applicant_info]
  program_info = seed_info[:program_info]
  results = match_algorithm(applicant_info, program_info)
  print_results(results, applicant_info, program_info)
end

def print_results(results, applicant_info, program_info)
  puts('Pre Match Information')
  puts('---------------------')
  # TODO
  applicant_info.each do |applicant, applicant_rank_list|
    puts("\t#{applicant} rank list:")
    applicant_rank_list.each do |program|
      puts("\t\t#{program}")
    end
  end

  program_info.each do |program, info|
    puts("\t#{program} rank list (#{info[:limit]} spots:")
    info[:list].each do |applicant|
      puts("\t\t#{applicant}")
    end
  end

  puts('')
  puts('Applicant Results')
  puts('----------')
  results[:applicants].each do |applicant, program|
    puts("\t#{applicant}: #{program}")
  end

  puts('')
  puts('Programs Results')
  puts('----------------')
  results[:programs].each do |program, admitted_applicants|
    puts("\t#{program}:")
    admitted_applicants.each do |applicant|
      puts("\t\t#{applicant}")
    end
  end
end

match
