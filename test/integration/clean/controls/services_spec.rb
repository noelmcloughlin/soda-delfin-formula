# frozen_string_literal: true

# Prepare platform "finger"
platform_finger = system.platform[:finger].split('.').first.to_s

control 'soda-delfin service' do
  impact 0.5
  title 'should not be running and enabled'

  describe service('soda-delfin') do
    it { should_not be_installed }
    it { should_not be_enabled }
    it { should_not be_running }
  end
end
