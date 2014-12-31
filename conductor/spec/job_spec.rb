require_relative '../lib/job'

describe 'conductor', 'load_all_job_data' do
  before(:context) do
    @jobs = load_all_job_data
    @job_name = 'example'
  end
  
  it 'returns a hash of job data' do
    expect(@jobs).to be_a Hash
  end
  
  it 'stores a job\'s data under the key of the job\'s name' do 
    expect(@jobs).to have_key @job_name
    job = @jobs[@job_name]
    ['branches', 'scripts', 'environment'].each do |key|
      expect(job).to have_key(key)
    end
  end
  
  it 'adds the job\'s name in it\'s data' do
    job = @jobs[@job_name]
    expect(job['name']).to eq 'example'
  end
end
