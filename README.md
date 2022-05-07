# terraform_alb_waf

Create a firewall for your ALB to filter out bad traffic.

##  Dependencies

- ALB listener - <https://github.com/virsas/terraform_alb_application>

## Files

- None

## Terraform example

``` terraform
##############
# Variable
##############
variable "alb_waf_main" {
  default = {
    name = "alb_waf_main"
    sampled = true
    cloudwatch = true
    rules = [
      { 
        name = "AWSManagedRulesCommonRuleSet"
        vendor = "AWS"
        priority = 2
        excludes = [
          { name = "GenericRFI_BODY" },
          { name = "SizeRestrictions_BODY" }
        ]
      },
      {
        name = "AWSManagedRulesSQLiRuleSet"
        vendor = "AWS"
        priority = 1
        excludes = []
      }
    ]
  }
}

##############
# Module
##############
module "alb_main_waf" {
  source = "github.com/virsas/terraform_alb_waf"
  alb = module.alb_main.arn
  waf = var.alb_waf_main
}
```