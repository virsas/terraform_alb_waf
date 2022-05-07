provider "aws" {
  region = var.region
}

resource "aws_wafv2_web_acl" "main" {
  name     = var.waf.name
  scope    = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.waf.cloudwatch
    metric_name                = var.waf.name
    sampled_requests_enabled   = var.waf.sampled
  }

  dynamic "rule" {
    for_each = var.waf.rules
    content {
      name     = rule.value["name"]
      priority = rule.value["priority"]

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value["name"]
          vendor_name = rule.value["vendor"]
          dynamic "excluded_rule" {
            for_each = rule.value["excludes"]
            content {
              name = excluded_rule.value["name"]
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.waf.cloudwatch
        metric_name                = rule.value["name"]
        sampled_requests_enabled   = var.waf.sampled
      }
    }
  }
}

resource "aws_wafv2_web_acl_association" "web_acl_association_my_lb" {
  resource_arn = var.alb
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}