resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high-cpu-eks"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EKS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Triggers when EKS CPU usage exceeds 80%"
  alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:my-sns-topic"]
}
