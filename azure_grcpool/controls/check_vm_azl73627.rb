control 'azurerm_virtual_machine' do
    title "Check vm 'azl73627'"
    desc "Check if vm 'azl73627' is present and in compliant state"
    describe azurerm_virtual_machine(resource_group: 'grcpool-prod-rg', name: 'azl73627') do
        it { should exist }
        its('location') { should eq('westeurope') }
        its('name') { should eq('azl73627') }
        its('type') { should eq 'Microsoft.Compute/virtualMachines' }
        its('installed_extensions_types') { should include('OmsAgentForLinux') }
        its('installed_extensions_names') { should include('OmsAgentForLinux') }
    end
end
