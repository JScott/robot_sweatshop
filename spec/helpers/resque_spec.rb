require_relative "../../helpers/resque.rb"

describe "helper/resque.rb" do
  describe 'configure_resque' do
    it 'configures resque in a uniform way' do
      expect(Resque).to receive(:configure)
      configure_resque
    end
  end

  describe 'enqueue_scripts' do
    it 'adds the job to the queue' do
      expect(Resque).to receive(:enqueue)
      enqueue_scripts 1, 2, 3
    end
  end
end
