resource "aws_lb" "lb" {
  name               = "lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.subnet.id]

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "tg"
  port     = 30000
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "tg-worker1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.worker1.id
  port             = 30000
}

resource "aws_lb_target_group_attachment" "tg-worker2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.worker2.id
  port             = 30000
}

resource "aws_lb_target_group_attachment" "tg-worker3" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.worker3.id
  port             = 30000
}