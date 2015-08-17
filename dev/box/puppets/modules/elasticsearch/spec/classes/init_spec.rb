require 'spec_helper'
describe 'elasticsearch' do

  context 'with defaults for all parameters' do
    it { should contain_class('elasticsearch') }
  end
end
