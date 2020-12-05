# frozen_string_literal: true

control 'soda-delfin service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('soda-delfin') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
