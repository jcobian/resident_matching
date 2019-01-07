require 'logger'

require './match_algorithm'
require './seeds'

def match
  seed_info = create_seed_data
  applicant_info = seed_info[:applicant_info]
  program_info = seed_info[:program_info]
  results = match_algorithm(applicant_info, program_info)
  print_results(results, applicant_info, program_info)
end

def print_results(results, applicant_info, program_info)
  logger = Logger.new(STDOUT)
  logger.level = Logger::INFO
  logger.formatter = proc do |_severity, _time, _progname, msg|
    "#{msg}\n"
  end

  logger.info('Pre Match Information')
  logger.info('---------------------')
  # TODO
  applicant_info.each do |applicant, applicant_rank_list|
    logger.info("\t#{applicant} rank list:")
    applicant_rank_list.each do |program|
      logger.info("\t\t#{program}")
    end
  end

  program_info.each do |program, info|
    logger.info("\t#{program} rank list (#{info[:limit]} spots:")
    info[:list].each do |applicant|
      logger.info("\t\t#{applicant}")
    end
  end

  logger.info('')
  logger.info('Applicant Results')
  logger.info('----------')
  results[:applicants].each do |applicant, program|
    logger.info("\t#{applicant}: #{program}")
  end

  logger.info('')
  logger.info('Programs Results')
  logger.info('----------------')
  results[:programs].each do |program, admitted_applicants|
    logger.info("\t#{program}:")
    admitted_applicants.each do |applicant|
      logger.info("\t\t#{applicant}")
    end
  end
end

match
