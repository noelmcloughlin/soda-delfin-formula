# frozen_string_literal: true

control '`map.jinja` YAML dump' do
  title 'should contain the lines'

  describe file('/tmp/salt_mapdata_dump.yaml') do
    it { should exist }
  end
end
