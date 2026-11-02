output "resource_group_name" { 
  value = azurerm_resource_group.main.name 
} 
  
output "log_analytics_workspace_id" { 
  value = azurerm_log_analytics_workspace.main.id 
} 
  
output "logic_app_callback_url" { 
  description = "Use this URL when configuring the Logic App HTTP trigger in the portal." 
  value       = azurerm_logic_app_workflow.cost_alert.access_endpoint 
} 
  
output "action_group_id" { 
  value = azurerm_monitor_action_group.email_alerts.id 
}