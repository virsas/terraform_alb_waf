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
# will be added soon

##############
# Module
##############
module "alb_main_waf" {
  source = "github.com/virsas/terraform_alb_waf"
  alb = module.alb_main.arn
  waf = var.alb_waf_main
}
```