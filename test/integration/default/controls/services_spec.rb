# frozen_string_literal: true

# Prepare platform "finger"
platform_finger = system.platform[:finger].split('.').first.to_s

control 'soda-delfin service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('soda-delfin') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
