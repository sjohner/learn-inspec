control 'exists_resourcegroup' do
    impact 1.0
    title "Check rg 'grcpool-prod-rg'"
    desc "Check if resource group 'grcpool-prod-rg' is present"
    describe azurerm_resource_groups.where(name: 'grcpool-prod-rg') do
        it { should exist }
    end
end