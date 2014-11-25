require 'chefspec'

describe 'tasktop-sync-studio::default' do
  
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new('platform' => 'ubuntu', 'version'=> '12.04')
    runner.converge('tasktop-sync-studio::default')
  end
    
  it 'should include the tasktop-sync-studio recipe by default' do
    expect(chef_run).to include_recipe 'tasktop-sync-studio::default'
  end

end
