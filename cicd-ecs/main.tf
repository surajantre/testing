provider "aws" {
  region = "ap-south-1"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "256"
  memory                  = "512"

  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "072152842782.dkr.ecr.ap-south-1.amazonaws.com/my-app:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = ["subnet-06659f5fb76f972d1"]  # Replace
    security_groups = ["sg-0f1e96c240bc26eba"]      # Replace
    assign_public_ip = true
  }
}
