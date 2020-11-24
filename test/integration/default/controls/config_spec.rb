# frozen_string_literal: true

control 'soda-delfin configuration' do
  title 'should match desired lines'

  describe file('/etc/delfin/delfin.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') do
      should include(
        'api_max_limit = 1000'
      )
    end
  end
end
