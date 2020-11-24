# frozen_string_literal: true

title 'soda-delfin archives profile'

control 'soda-delfin archive' do
  impact 1.0
  title 'should not be installed'

  describe file('/opt/soda/delfin-1.0.0/etc') do
    it { should_not exist }
    it { should_not be_directory }
    its('type') { should_not eq :directory }
  end
end
