# frozen_string_literal: true

title 'soda-delfin archives profile'

control 'soda-delfin archive' do
  impact 1.0
  title 'should be installed'

  describe file('/opt/soda/delfin-1.0.0/etc') do
    it { should exist }
    it { should be_directory }
    its('type') { should eq :directory }
  end
end
