require 'logger'

def match_algorithm(applicant_info, program_info, logger: nil)
  logger ||= default_logger
  # Inputs:
  # program_info
  # key: program's name
  # value: hash with two keys (symbols).
  #   `limit`: number of applicants they can accept
  #   `list`:  array of applicants they interviewed in ranked order
  #
  # applicant_info
  # key: applicant's name,
  # value: array of programs they interviewed at in ranked order
  results = {
    applicants: {},
    programs: Hash.new { |hash, key| hash[key] = [] }
  }
  # key: applicant name,
  # value: offset in that applicant's
  # ranked order list is their top choice currently
  applicant_offset = Hash.new(0)

  # Actual algorithm begins here
  loop do
    applicant = pluck_applicant_without_program(applicant_info.keys,
                                                results[:applicants].keys)
    break if applicant.nil?

    logger.debug("Processing #{applicant}")
    current_program = applicant_info[applicant][applicant_offset[applicant]]
    # TODO: double check if this is right or if the candidate can be re-evaluaed
    if current_program.nil?
      add_applicant(results, applicant, 'Scramble', applicant_offset, logger)
      next
    end

    if program_wants_and_can_take_applicant?(
      program_info[current_program],
      applicant,
      results[:programs][current_program]
    )
      add_applicant(results, applicant, current_program, applicant_offset,
                    logger)
    else
      lesser_ranked_applicant = lesser_ranked_applicant_for_program(
        program_info[current_program][:list],
        results[:programs][current_program],
        applicant
      )
      if lesser_ranked_applicant != applicant
        # program prefers applicant over lesser_ranked_applicant
        logger.debug("#{current_program} prefers #{applicant} over "\
                     "#{lesser_ranked_applicant}")
        add_applicant(results, applicant, current_program, applicant_offset,
                      logger)
        remove_applicant(results, lesser_ranked_applicant,
                         current_program, applicant_offset, logger)
      else
        # program does not prefer applicant over anyone in their current list
        logger.debug("#{current_program} does not want #{applicant} "\
                     "over anyone in: #{results[:programs][current_program]}")
        applicant_offset[applicant] += 1
      end
    end
  end
  results
end

def pluck_applicant_without_program(applicants, applicants_with_programs)
  applicants.each do |applicant|
    return applicant unless applicants_with_programs.include?(applicant)
  end
  nil
end

def lesser_ranked_applicant_for_program(program_ranked_list,
                                        program_current_residents,
                                        potential_applicant)
  # return potential_applicant if this applicant would be last in current list
  # otherwise, return the last applicant in the current residens list
  rank = program_ranked_list.index(potential_applicant)
  return potential_applicant if rank.nil? # program did not rank this applicant

  program_current_residents.each do |resident|
    residents_rank = program_ranked_list.index(resident)
    return resident if rank < residents_rank
  end
  potential_applicant
end

def program_wants_and_can_take_applicant?(program_info,
                                          applicant,
                                          program_current_residents)
  filled_spots = program_current_residents.length
  filled_spots < program_info[:limit] && program_info[:list].include?(applicant)
end

def add_applicant(results, applicant, program, applicant_offset, logger)
  logger.debug("Placing #{applicant} at #{program}")
  results[:applicants][applicant] = program
  results[:programs][program].push(applicant)
  # move offset so that if they get kicked out they
  # are moved back to their previous current top choice
  # TODO: test this
  applicant_offset[applicant] += 1
end

def remove_applicant(results, applicant, program, applicant_offset, logger)
  logger.debug("Removing #{applicant} from #{program}")
  results[:programs][program].delete(applicant)
  results[:applicants].delete(applicant)
  # TODO: test this
  applicant_offset[applicant] -= 1
end

def default_logger
  logger = Logger.new(STDOUT)
  logger.level = Logger::WARN
  logger
end
