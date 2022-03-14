resource "aws_backup_plan" "Daily" {
  name = "${var.customer_name}_Daily_backup_plan"
    
  rule {
    rule_name         = "${var.customer_name}_Daily_backup_rule"
    target_vault_name = "Default"
    schedule          = "cron(0 22 ? * * *)"
    start_window = 60
    completion_window = 180
    lifecycle {
        delete_after = var.dailyRetention
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "disabled"
    }
    resource_type = "EC2"
  }
}

resource "aws_backup_plan" "weekly" {
  name = "${var.customer_name}_Weekly_backup_plan"
    
  rule {
    rule_name         = "${var.customer_name}_Weekly_backup_rule"
    target_vault_name = "Default"
    schedule          = "cron(0 22 ? * 6 *)"
    start_window = 60
    completion_window = 180
    lifecycle {
        delete_after = var.weeklyRetention
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "disabled"
    }
    resource_type = "EC2"
  }
}

resource "aws_backup_plan" "monthly" {
  name = "${var.customer_name}_monthly_backup_plan"
    
  rule {
    rule_name         = "${var.customer_name}_monthly_backup_rule"
    target_vault_name = "Default"
    schedule          = "cron(0 22 1 * ? *)"
    start_window = 60
    completion_window = 180
    lifecycle {
        delete_after = var.monthlyRetention
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "disabled"
    }
    resource_type = "EC2"
  }
}

resource "aws_iam_role" "backup_role" {
  name               = "backup_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

resource "aws_backup_selection" "dailySelection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "Daily"
  plan_id      = aws_backup_plan.Daily.id
  
  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "DAILY"
  }
}

resource "aws_backup_selection" "weeklySelection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "Weekly"
  plan_id      = aws_backup_plan.weekly.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "WEEKLY"
  }
}

resource "aws_backup_selection" "monthlySelection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "Monthly"
  plan_id      = aws_backup_plan.monthly.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "MONTHLY"
  }
}