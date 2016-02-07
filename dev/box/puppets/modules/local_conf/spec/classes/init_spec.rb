require 'spec_helper'
describe 'local_conf' do

  context 'with defaults for all parameters' do
    it { should contain_class('local_conf') }
  end
end
