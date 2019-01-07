require './match_algorithm'
require 'pry'

describe 'match_algorithm' do
  let(:applicant_info) do
    {
      'jeff' => %w[UCSF Northwestern UChicago],
      'ozzy' => %w[UCSF Northwestern],
      'sandra' => %w[Northwestern UChicago],
      'cirie' => %w[UChicago UCSF Northwestern],
      'russell' => %w[Northwestern]
    }
  end

  let(:program_info) do
    {
      'UCSF' => { list: %w[jeff sandra cirie russell ozzy], limit: 2 },
      'Northwestern' => { list: %w[jeff cirie ozzy russell], limit: 3 },
      'UChicago' => { list: %w[sandra cirie], limit: 1 }
    }
  end

  let(:expected_applicant_results) do
    {
      'jeff' => 'UCSF',
      'cirie' => 'UCSF',
      'ozzy' => 'Northwestern',
      'sandra' => 'UChicago',
      'russell' => 'Northwestern'
    }
  end

  it 'correctly allocates applicants to programs' do
    results = match_algorithm(applicant_info, program_info)
    expect(results[:applicants]).to eq(expected_applicant_results)
  end
end
