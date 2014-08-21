require_relative "../../helpers/queue.rb"

describe "helper/queue.rb" do
  describe 'configure_queue' do
    it 'configures the server and client' do
      expect(Sidekiq).to receive(:configure_client)
      expect(Sidekiq).to receive(:configure_server)
      configure_queue
    end
  end
  describe 'enqueue_scripts' do
    it 'adds the job to the queue' do
      expect(RunScriptsWorker).to receive(:perform_async)
      enqueue_scripts 1, 2, 3
    end
  end
end
