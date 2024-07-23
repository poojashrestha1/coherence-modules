####################
# Autoscaling group
####################

variable "name" {
  description = "Name used across the resources created"
  type        = string
}

variable "instance_name" {
  description = "Name that is propogated to launched EC2 instances via a tag - if not provided, defaults to `var.name`"
  type        = string
  default     = ""
}

variable "launch_template_id" {
  description = "ID of an existing launch template to be used (created outside of this module)"
  type        = string
  default     = null
}

variable "launch_template_version" {
  description = "Launch template version. Can be version number, `$Latest`, or `$Default`"
  type        = string
  default     = null
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones`"
  type        = list(string)
  default     = null
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = null
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = null
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  default     = null
}

variable "desired_capacity_type" {
  description = "The unit of measurement for the value specified for desired_capacity. Supported for attribute-based instance type selection only. Valid values: `units`, `vcpu`, `memory-mib`."
  type        = string
  default     = null
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  type        = number
  default     = null
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior."
  type        = number
  default     = null
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
  default     = null
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = null
}

variable "default_instance_warmup" {
  description = "Amount of time, in seconds, until a newly launched instance can contribute to the Amazon CloudWatch metrics. This delay lets an instance finish initializing before Amazon EC2 Auto Scaling aggregates instance metrics, resulting in more reliable usage data. Set this value equal to the amount of time that it takes for resource consumption to become stable after an instance reaches the InService state."
  type        = number
  default     = null
}

variable "protect_from_scale_in" {
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events."
  type        = bool
  default     = false
}

variable "health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  type        = string
  default     = null
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = null
}

variable "initial_lifecycle_hooks" {
  description = "One or more Lifecycle Hooks to attach to the Auto Scaling Group before instances are launched. The syntax is exactly the same as the separate `aws_autoscaling_lifecycle_hook` resource, without the `autoscaling_group_name` attribute. Please note that this will only work when creating a new Auto Scaling Group. For all other use-cases, please use `aws_autoscaling_lifecycle_hook` resource"
  type        = list(map(string))
  default     = []
}

variable "delete_timeout" {
  description = "Delete timeout to wait for destroying autoscaling group"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "image_id" {
  description = "The AMI from which to launch the instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of the instance. If present then `instance_requirements` cannot be present"
  type        = string
  default     = null
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The Base64-encoded user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "security_groups" {
  description = "A list of security group IDs to associate"
  type        = list(string)
  default     = []
}

##################
# Launch Template
##################

variable "create_launch_template" {
  description = "Determines whether to create launch template or not"
  type        = bool
  default     = true
}

variable "launch_template_name" {
  description = "Name of launch template to be created"
  type        = string
  default     = ""
}

variable "launch_template_description" {
  description = "Description of the launch template"
  type        = string
  default     = null
}

variable "default_version" {
  description = "Default Version of the launch template"
  type        = string
  default     = null
}

variable "network_interfaces" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(any)
  default     = []
}

variable "tag_specifications" {
  description = "The tags to apply to the resources during launch"
  type        = list(any)
  default     = []
}


##############################################
# Autoscaling group traffic source attachment
##############################################

variable "create_traffic_source_attachment" {
  description = "Determines whether to create autoscaling group traffic source attachment"
  type        = bool
  default     = false
}

variable "traffic_source_identifier" {
  description = "Identifies the traffic source. For Application Load Balancers, Gateway Load Balancers, Network Load Balancers, and VPC Lattice, this will be the Amazon Resource Name (ARN) for a target group in this account and Region. For Classic Load Balancers, this will be the name of the Classic Load Balancer in this account and Region"
  type        = string
  default     = ""
}

variable "traffic_source_type" {
  description = "Provides additional context for the value of identifier. The following lists the valid values: `elb` if `identifier` is the name of a Classic Load Balancer. `elbv2` if `identifier` is the ARN of an Application Load Balancer, Gateway Load Balancer, or Network Load Balancer target group. `vpc-lattice` if `identifier` is the ARN of a VPC Lattice target group"
  type        = string
  default     = "elbv2"
}


#####################
# Autoscaling policy
#####################

variable "create_scaling_policy" {
  description = "Determines whether to create target scaling policy schedule or not"
  type        = bool
  default     = true
}

variable "scaling_policies" {
  description = "Map of target scaling policy schedule to create"
  type        = any
  default     = {}
}


###########################
# Autoscaling notification
###########################

variable "notifications" {
  description = "List of Notification Types that trigger notifications"
  type        = list(string)
  default     = []
}

variable "sns_topic_arn" {
  description = "Topic ARN for notifications to be sent through"
  type        = string
  default     = null
}


##############################
# IAM Role / Instance Profile
##############################

variable "create_iam_instance_profile" {
  description = "Determines whether an IAM instance profile is created or to use an existing IAM instance profile"
  type        = bool
  default     = false
}

variable "iam_instance_profile_arn" {
  description = "Amazon Resource Name (ARN) of an existing IAM instance profile. Used when `create_iam_instance_profile` = `false`"
  type        = string
  default     = null
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile to be created (`create_iam_instance_profile` = `true`) or existing (`create_iam_instance_profile` = `false`)"
  type        = string
  default     = null
}

variable "role_name" {
  description = "Name of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "policy_name" {
  description = "IAM policy name. It override the default value, which is the same as role_name"
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Path of policies to that should be added to IAM role for CodeBuild"
  type        = string
  default     = null
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to CodeBuild role"
  type        = any
  default     = {}
}

variable "iam_role_policies" {
  description = "IAM policies to attach to the IAM role"
  type        = map(string)
  default     = {}
}
