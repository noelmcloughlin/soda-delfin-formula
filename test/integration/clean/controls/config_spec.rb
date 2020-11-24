# frozen_string_literal: true

control 'soda-delfin configuration' do
  title 'should match desired lines'

  describe file('/etc/delfin/delfin.conf') do
    it { should_not be_file }
  end
end
