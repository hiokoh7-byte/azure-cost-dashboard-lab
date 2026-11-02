variable "yourname" { 
  description = "Your name, lowercase, no spaces. Used to make resource names unique." 
  type        = string 
} 
  
variable "location" { 
  description = "Azure region to deploy into." 
  type        = string 
  default     = "Mexico Central" 
} 
  
variable "alert_email" { 
  description = "Email address to receive cost alert notifications." 
  type        = string 
} 
  
variable "tags" { 
  type = map(string) 
  default = { 
    project     = "cost-dashboard" 
    environment = "dev" 
    managed_by  = "terraform" 
  } 
}