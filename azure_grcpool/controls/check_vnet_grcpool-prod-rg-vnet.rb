control 'azurerm_virtual_network' do
    title "Check vnet 'grcpool-prod-rg-vnet'"
    desc "Check if vnet 'grcpool-prod-rg-vnet' is present and in compliant state"
    describe azurerm_virtual_network(resource_group: 'grcpool-prod-rg', name: 'grcpool-prod-rg-vnet') do
        it { should exist }
        its('location') { should eq('westeurope') }
        its('name') { should eq('grcpool-prod-rg-vnet') }
        its('type') { should eq 'Microsoft.Network/virtualNetworks' }
        its('subnets') { should eq ["default"] }
        its('address_space') { should eq ["10.2.1.0/24"] }
        its('dns_servers') { should eq ["1.1.1.1", "1.0.0.1"] }
        its('enable_ddos_protection') { should eq false }
    end
end