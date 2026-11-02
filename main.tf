terraform { 
  required_providers { 
    azurerm = { 
      source  = "hashicorp/azurerm" 
      version = "~> 3.0" 
    } 
  } 
} 
  
provider "azurerm" { 
  features {} 
} 
  
data "azurerm_client_config" "current" {}
resource "azurerm_resource_group" "main" { 
  name     = "rg-cost-dashboard-${var.yourname}" 
  location = var.location 
  tags     = var.tags 
}
resource "azurerm_log_analytics_workspace" "main" { 
  name                = "law-cost-${var.yourname}" 
  location            = var.location 
  resource_group_name = azurerm_resource_group.main.name 
  sku                 = "PerGB2018" 
  retention_in_days   = 30 
  tags                = var.tags 
}
resource "azurerm_monitor_action_group" "email_alerts" { 
  name                = "ag-cost-alerts-${var.yourname}" 
  resource_group_name = azurerm_resource_group.main.name 
  short_name          = "costalerts" 
  
  email_receiver { 
    name                    = "owner-email" 
    email_address           = var.alert_email 
    use_common_alert_schema = true 
  } 
  
  tags = var.tags 
}
resource "azurerm_consumption_budget_subscription" "main" {
  name            = "monthly-budget"
  subscription_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  amount     = 200
  time_grain = "Monthly"

  time_period {
    start_date = "2026-11-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 25
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_groups = [azurerm_monitor_action_group.email_alerts.id]
  }

  notification {
    enabled        = true
    threshold      = 50
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_groups = [azurerm_monitor_action_group.email_alerts.id]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_groups = [azurerm_monitor_action_group.email_alerts.id]
  }
}
resource "azurerm_logic_app_workflow" "cost_alert" { 
  name                = "la-cost-alert-${var.yourname}" 
  location            = var.location 
  resource_group_name = azurerm_resource_group.main.name 
  tags                = var.tags 
}
resource "azurerm_monitor_diagnostic_setting" "subscription_logs" { 
  name                       = "diag-sub-to-law" 
  target_resource_id         = "/subscriptions/${data.azurerm_client_config.current.subscription_id}" 
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id 
  
  enabled_log { 
    category = "Administrative" 
  } 
  
  enabled_log { 
    category = "Security" 
  } 
  
  enabled_log { 
    category = "Policy" 
  } 
}