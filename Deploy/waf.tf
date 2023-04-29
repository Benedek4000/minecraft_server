locals {
  waf_scope = "CLOUDFRONT"
}

resource "aws_wafv2_web_acl" "webAcl" {
  count    = var.enable_waf ? 1 : 0
  provider = aws.northVirginia
  name     = "${var.project}-webAcl"
  scope    = local.waf_scope

  default_action {
    allow {}
  }

  rule {
    name     = "${var.project}-rate-limit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.project}-website-waf-rate-limit"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.project}-waf-web-acl-cloudwatch"
    sampled_requests_enabled   = false
  }
}
