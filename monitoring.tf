# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "patient_service" {
  name              = "/ecs/patient-service"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "appointment_service" {
  name              = "/ecs/appointment-service"
  retention_in_days = 7
}

# CloudWatch Alarms (Example for CPU)
resource "aws_cloudwatch_metric_alarm" "high_cpu_patient" {
  alarm_name          = "patient-service-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 70


  dimensions = {
    ClusterName = aws_ecs_cluster.healthcare_cluster.name
    ServiceName = aws_ecs_service.patient_service.name
  }
}