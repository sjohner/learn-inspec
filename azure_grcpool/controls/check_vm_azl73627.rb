control 'azurerm_virtual_machine' do
    title "Check azl73627"
    desc "Check if vm azl73627 is present and in compliant state"
    describe azurerm_virtual_machine(resource_group: 'grcpool-prod-rg', name: 'azl73627') do
        it                                { should exist }
        it                                { should have_monitoring_agent_installed }
        it                                { should_not have_endpoint_protection_installed([]) }
        it                                { should have_only_approved_extensions(['MicrosoftMonitoringAgent']) }
        its('type')                       { should eq 'Microsoft.Compute/virtualMachines' }
        its('installed_extensions_types') { should include('MicrosoftMonitoringAgent') }
        its('installed_extensions_names') { should include('LogAnalytics') }
    end
end
