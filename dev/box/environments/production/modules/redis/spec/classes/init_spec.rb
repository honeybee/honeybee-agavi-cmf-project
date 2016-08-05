require 'spec_helper'
describe 'redis' do

  context 'with defaults for all parameters' do
    it { should contain_class('redis') }
  end
end
