# Run this command in rails console to run the script:
# load 'lib/scripts/create_s3_bucket.rb'

# place this file in the lib/scripts/ directory

require "aws-sdk-s3"

# AWS credentials
Aws.config.update({
  region: Settings.aws.region,
  credentials: Aws::Credentials.new(Settings.aws.access_key, Settings.aws.secret_access_key)
})

s3_client = Aws::S3::Client.new

puts "Please provide a bucket name for your new S3 bucket: "
print "-" * 10
print "Bucket name requirements:"
puts "-" * 10
puts "1. Length: 3-63 characters."
puts "2. Characters: Lowercase letters, numbers, dots (.), and hyphens (-)."
puts "3. Must not contain spaces ( )"
puts "4. Must start and end with a letter or number."
puts "5. Cannot contain two adjacent periods or resemble an IP address (e.g., 192.168.5.4)."
puts "6. Avoid names starting with 'xn--', 'sthree-', or 'sthree-configurator'."
puts "7. Avoid names ending with '-s3alias' or '--ol-s3'."
puts "8. Must be globally unique across AWS accounts and regions in the same partition."

bucket_name = gets.chomp

if bucket_name.blank?
  puts "Bucket name is required, failed to create!"
  return
end

cors_configuration = {
  cors_rules: [
    {
      allowed_methods: %w[GET PUT POST DELETE],
      allowed_origins: ["*"], # Change to specific domains you want to allow
      allowed_headers: [],
      max_age_seconds: 3000,
      expose_headers: []
    }
  ]
}

s3_client.create_bucket(bucket: bucket_name)

s3_client.put_bucket_cors(
  bucket: bucket_name,
  cors_configuration:
)

# Disable "Block Public Access" for the bucket
s3_client.put_public_access_block(
  bucket: bucket_name,
  public_access_block_configuration: {
    block_public_acls: false,
    ignore_public_acls: false,
    block_public_policy: false,
    restrict_public_buckets: false
  }
)

# Define your bucket policy as a JSON string
bucket_policy = {
  Version: "2012-10-17",
  Statement: [
    {
      Sid: "Statement1",
      Effect: "Allow",
      Principal: "*",
      Action: [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:DeleteObject"
      ],
      Resource: "arn:aws:s3:::#{bucket_name}/*"
    }
  ]
}.to_json

s3_client.put_bucket_policy(
  bucket: bucket_name,
  policy: bucket_policy
)

puts "S3 bucket '#{bucket_name}' created with custom CORS and bucket policies."
