resource "aws_route53_zone" "private" {
  name = "quadzig.dsa.internal"

  vpc {
    vpc_id = aws_vpc.this.id
  }
}
