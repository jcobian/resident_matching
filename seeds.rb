APPLICANT_LIMIT = 25 # roughly how many applicants in the universe
PROGRAM_LIMT = 4 # roughly how many programs in the universe

PROGRAM_RANGE = (2..6).freeze # range of how many spots a program has
# range of applicants a program will interview
# for now, 5 times the lowe and upper limits of number of spots a program has
PROGRAM_INTERVIEW_RANGE = (10..15).freeze

STARTER_APPLICANT_NAMES = [
  'sarah',
  'jon',
  'lily',
  'sam',
  'brian',
  'anne marie',
  'mallory',
  'noah'
].freeze

STARTER_PROGRAM_NAMES = [
  'UCSF',
  'Brigham',
  'U Colorado',
  'San Diego',
  'Washington',
  'Northwestern'
].freeze

# create universe by iterating over a starter list until
# we've roughly hit a soft limit
def create_entity_list(starter_list, list_soft_limit)
  i = 1
  final_list = []
  loop do
    starter_list.each do |name|
      final_list.push("#{name} #{i}")
    end
    break if final_list.length >= list_soft_limit

    i += 1
  end
  final_list
end

def create_seed_data(applicant_limit: APPLICANT_LIMIT,
                     program_limit: PROGRAM_LIMT,
                     program_range: PROGRAM_RANGE,
                     program_interview_range: PROGRAM_INTERVIEW_RANGE)
  # create universe of applicants and programs
  applicant_names = create_entity_list(STARTER_APPLICANT_NAMES, applicant_limit)
  program_names = create_entity_list(STARTER_PROGRAM_NAMES, program_limit)

  # Information about who interviewed with who
  # hash with 2 keys, which are symbols
  #   `programs`: hash
  #     key: name of program
  #     value: arrray of applicants they interviewed
  #   `applicants`: hash
  #     key: name of applicant
  #     value: arrray of programs they interviewed at
  interview_info = {
    programs: {},
    applicants: Hash.new { |hash, key| hash[key] = [] }
  }

  # Information about a program
  # key: program's name
  # value: hash with two keys (symbols).
  #   `limit`: number of applicants they can accept
  #   `list`:  array of applicants they interviewed in ranked order
  program_info = Hash.new { |hash, key| hash[key] = {} }
  program_names.each do |program_name|
    # create list of applicants they interviewed randomly
    num_applicants_interviewed = rand(program_interview_range)
    applicants_interviewed = applicant_names.sample(num_applicants_interviewed)

    # populate interview info
    interview_info[:programs][program_name] = applicants_interviewed
    applicants_interviewed.each do |applicant_name|
      interview_info[:applicants][applicant_name].push(program_name)
    end

    # create a random ranked order list
    program_info[program_name][:list] = applicants_interviewed.shuffle
    program_info[program_name][:limit] = rand(program_range)
  end

  # Information about an applicant
  # key: applicant's name,
  # value: array of programs they interviewed at in ranked order
  applicant_info = {}
  applicant_names.each do |applicant_name|
    programs_interviewed_at = interview_info[:applicants][applicant_name]
    next if programs_interviewed_at.empty? # :(

    # create a random ranked order list
    applicant_info[applicant_name] = programs_interviewed_at.shuffle
  end

  {
    applicant_info: applicant_info,
    program_info: program_info
  }
end
