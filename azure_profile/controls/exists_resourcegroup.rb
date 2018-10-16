control 'exists_resourcegroup' do
    impact 1.0
    title "Resource Group exists"
    desc "A resource group jhnr-dev-rg-01 should exist."
    describe azurerm_resource_groups.where('name' => 'pgc-dev-rg-01') do
        it { should exist }
    end
end