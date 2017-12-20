resource "aws_db_subnet_group" "main" {
  count       = "${var.create_rds}"
  name        = "${var.name}-subnet-group"
  description = "Group of DB subnets"
  subnet_ids  = ["${var.subnets}"]
}

resource "aws_rds_cluster_instance" "cluster_instance_0" {
  count                        = "${var.create_rds}"
  identifier                   = "${var.name}-aurora-node-0"
  cluster_identifier           = "${aws_rds_cluster.default.id}"
  instance_class               = "${var.instance_type}"
  publicly_accessible          = "${var.publicly_accessible}"
  db_subnet_group_name         = "${aws_db_subnet_group.main.name}"
  db_parameter_group_name      = "${var.db_parameter_group_name}"
  preferred_maintenance_window = "${var.preferred_maintenance_window}"
  apply_immediately            = "${var.apply_immediately}"
  auto_minor_version_upgrade   = "${var.auto_minor_version_upgrade}"
  promotion_tier               = "0"
}

resource "aws_rds_cluster_instance" "cluster_instance_n" {
  depends_on                   = ["aws_rds_cluster_instance.cluster_instance_0"]
  count                        = "${var.replica_count}"
  identifier                   = "${var.name}-aurora-node-${count.index + 1}"
  cluster_identifier           = "${aws_rds_cluster.default.id}"
  instance_class               = "${var.instance_type}"
  publicly_accessible          = "${var.publicly_accessible}"
  db_subnet_group_name         = "${aws_db_subnet_group.main.name}"
  db_parameter_group_name      = "${var.db_parameter_group_name}"
  preferred_maintenance_window = "${var.preferred_maintenance_window}"
  apply_immediately            = "${var.apply_immediately}"
  auto_minor_version_upgrade   = "${var.auto_minor_version_upgrade}"
  promotion_tier               = "${count.index + 1}"
}

resource "aws_rds_cluster" "default" {
  count                           = "${var.create_rds}"
  cluster_identifier              = "${var.name}-aurora-cluster"
  master_username                 = "${var.username}"
  master_password                 = "${var.password}"
  backup_retention_period         = "${var.backup_retention_period}"
  preferred_backup_window         = "${var.preferred_backup_window}"
  preferred_maintenance_window    = "${var.preferred_maintenance_window}"
  port                            = "${var.port}"
  db_subnet_group_name            = "${aws_db_subnet_group.main.name}"
  vpc_security_group_ids          = ["${aws_security_group.main_db_access.id}"
  snapshot_identifier             = "${var.snapshot_identifier}"
  storage_encrypted               = "${var.storage_encrypted}"
  apply_immediately               = "${var.apply_immediately}"
  db_cluster_parameter_group_name = "${var.db_cluster_parameter_group_name}"
}

resource "random_id" "server" {
  keepers = {
    id = "${aws_db_subnet_group.main.name}"
  }

  byte_length = 8
}

# Security groups
resource "aws_security_group" "main_db_access" {
  count = "${var.create_rds}"
  name = "${var.name}-access"
  description = "Allow access to the database"
  vpc_id = "${var.rds_vpc_id}"
}

resource "aws_security_group_rule" "allow_db_access" {
    count = "${var.create_rds}"
    type = "ingress"

    from_port = "${var.port}"
    to_port = "${var.port}"
    protocol = "tcp"
    cidr_blocks = ["${var.private_cidr}"]

    security_group_id = "${aws_security_group.main_db_access.id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
    count = "${var.create_rds}"
    type = "egress"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.main_db_access.id}"
}