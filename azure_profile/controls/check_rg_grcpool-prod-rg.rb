control 'exists_resourcegroup' do
    impact 1.0
    title "Resource Group exists"
    desc "A resource group grcpool-prod-rg should exist."
    describe azurerm_resource_groups.where('name' => 'grcpool-prod-rg') do
        it { should exist }
    end
end