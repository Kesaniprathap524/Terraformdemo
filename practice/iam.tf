resource "aws_iam_role" "my-s3-role" {
    name = "my-s3-role"
    assume_role_policy = file("./policies/assume_role.json")
}

data "aws_iam_policy" "awsS3Fullaccess" {
 arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role = aws_iam_role.my-s3-role.name
  policy_arn = data.aws_iam_policy.awsS3Fullaccess.arn
}