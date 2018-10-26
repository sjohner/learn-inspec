control 'azurerm_subnet' do
    title "Check subnet 'default'"
    desc "Check if subnet 'default' is present and in compliant state"
    describe azurerm_subnet(resource_group: 'grcpool-prod-rg', vnet: 'grcpool-prod-rg-vnet', name: 'default') do
        it { should exist }
        its('name') { should eq('default') }
        its('type') { should eq 'Microsoft.Network/virtualNetworks/subnets' }
        its('address_prefix') { should eq "10.2.1.0/24" }
        its('nsg') { should eq 'subnet-default-nsg'}
    end
end