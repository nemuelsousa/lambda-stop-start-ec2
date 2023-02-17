resource "aws_iam_role" "lambda_role" {
name   = "lambda-start-stop-ec2"
assume_role_policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Action":"sts:AssumeRole",
         "Principal":{
            "Service":"lambda.amazonaws.com"
         },
         "Effect":"Allow",
         "Sid":""
      }
   ]
}
EOF
}
resource "aws_iam_policy" "iam_policy_lambda" {
 name         = "policy-start-stop-ec2"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
         ],
         "Resource":"arn:aws:logs:*:*:*"
      },
      {
         "Effect":"Allow",
         "Action":[
            "ec2:DescribeInstances",
            "ec2:DescribeRegions",
            "ec2:Start*",
            "ec2:Stop*"
         ],
         "Resource":"*"
      }
   ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role_1" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_lambda.arn
}
 
data "archive_file" "zip_python_code_start_instances" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/start-instances.zip"
}
 
resource "aws_lambda_function" "lambda_func_start-instances" {
filename                       = "${path.module}/python/start-instances.zip"
function_name                  = "startEC2instances"
role                           = aws_iam_role.lambda_role.arn
handler                        = "lambda_function.lambda_handler"
runtime                        = "python3.9"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_1]
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role_2" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_lambda.arn
}
 
data "archive_file" "zip_python_code_stop-instances" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/stop-instances.zip"
}
 
resource "aws_lambda_function" "lambda_func_stop-instances" {
filename                       = "${path.module}/python/stop-instances.zip"
function_name                  = "stopEC2instances"
role                           = aws_iam_role.lambda_role.arn
handler                        = "lambda_function.lambda_handler"
runtime                        = "python3.9"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_2]
}