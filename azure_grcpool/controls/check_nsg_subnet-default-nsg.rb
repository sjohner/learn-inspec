control 'azurerm_network_security_group' do
    title "Check nsg 'subnet-default-nsg'"
    desc "Check if nsg 'subnet-default-nsg' is present and in compliant state"
    describe azurerm_network_security_group(resource_group: 'grcpool-prod-rg', name: 'subnet-default-nsg') do
        it { should exist }
        it { should allow_ssh_from_internet }
        it { should_not allow_rdp_from_internet }
        its('security_rules') { should_not be_empty }
        its('default_security_rules') { should_not be_empty }
    end
end