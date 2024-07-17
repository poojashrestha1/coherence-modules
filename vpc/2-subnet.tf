#################
# Public Subnets
#################

locals {
  no_of_azs = length(var.azs)
}

resource "aws_subnet" "public" {
  count = local.no_of_azs

  vpc_id                  = aws_vpc.this.id
  availability_zone       = var.azs[count.index]
  cidr_block              = var.public_subnets[count.index].cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      Name = format("${var.vpc_name}-subnet-${var.public_subnet_suffix}-%s", element(var.azs, count.index))
    },
    var.tags,
    var.public_subnet_tags
  )
}

##################
# Private Subnets
##################

resource "aws_subnet" "private" {
  count = local.no_of_azs

  vpc_id            = aws_vpc.this.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnets[count.index].cidr

  tags = merge(
    {
      Name = format("${var.vpc_name}-subnet-${var.private_subnet_suffix}-%s", element(var.azs, count.index))
    },
    var.tags,
    var.private_subnet_tags
  )
}


###################
# Database Subnets
###################

locals {
  len_database_subnets        = length(var.database_subnets)
  create_database_subnets     = local.len_database_subnets > 0
  create_database_route_table = local.create_database_subnets && var.create_database_subnet_route_table
}

resource "aws_subnet" "database" {
  count = local.create_database_subnets ? local.len_database_subnets : 0

  vpc_id            = aws_vpc.this.id
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block        = var.database_subnets[count.index].cidr


  tags = merge(
    {
      Name = try(
        var.database_subnet_names[count.index],
        format("${var.vpc_name}-%s", element(var.azs, count.index), )
      )
    },
    var.tags,
    var.database_subnet_tags,
  )
}

resource "aws_db_subnet_group" "database" {
  count = local.create_database_subnets && var.create_database_subnet_group ? 1 : 0

  name        = lower(coalesce(var.database_subnet_group_name, var.vpc_name))
  description = "Database subnet group for ${var.vpc_name}"
  subnet_ids  = aws_subnet.database[*].id

  tags = merge(
    {
      "Name" = lower(coalesce(var.database_subnet_group_name, var.vpc_name))
    },
    var.tags,
    var.database_subnet_group_tags,
  )
}
